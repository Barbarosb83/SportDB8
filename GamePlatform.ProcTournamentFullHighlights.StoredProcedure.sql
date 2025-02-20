USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentFullHighlights]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
 
CREATE PROCEDURE [GamePlatform].[ProcTournamentFullHighlights] 
@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @TempTable table(MatchId bigint,CountBet int)

declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2

insert @TempTable
SELECT  top 32   Customer.SlipOdd.MatchId,count(Customer.SlipOdd.SlipId)
FROM       Customer.SlipOdd with (nolock)	 			  
WHERE     (CAST(Customer.SlipOdd.EventDate AS date) >= CAST(GETDATE() AS date))
					  group by Customer.SlipOdd.MatchId ORDER by count(Customer.SlipOdd.MatchId) desc


if ((select count(MatchId) from  @TempTable)<4)
begin
	insert @TempTable
	SELECT  top 32  Cache.Fixture.MatchId,1
		FROM       Cache.Fixture with (nolock)				  
		WHERE     Cache.Fixture.IsPopular=1 
end


declare @tFixture table (CacheMatchId bigint NOT NULL,
	BetradarMatchId bigint NULL,
	MatchId bigint NOT NULL,
	MatchDate datetime NOT NULL,
	HomeTeam int NOT NULL,
	AwayTeam int NOT NULL,
	SportName nvarchar(50) NOT NULL,
	OddId1 bigint NULL,
	OddValue1 float NULL,
	Odd1Visibility nchar(6) NULL,
	OddId2 bigint NULL,
	OddValue2 float NULL,
	Odd1Visibility2 nchar(6) NULL,
	OddId3 bigint NULL,
	OddValue3 float NULL,
	Odd1Visibility3 nchar(6) NULL,
	OddTypeCount int NULL,
	TournamentId int NOT NULL,
	IsPopular bit NULL,
	SportId int NULL,
	NeutralGround bit NULL)


insert @tFixture 
	select    * from Cache.Fixture with (nolock) where (CAST(Cache.Fixture.MatchDate AS Date) >= CAST(GETDATE() AS date)) and MatchId in (select distinct MatchId from @TempTable)

SELECT   CacheFixture.MatchId, CacheFixture.MatchDate,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                      CacheFixture.SportName, CacheFixture.OddId1, CacheFixture.OddValue1, CacheFixture.Odd1Visibility, CacheFixture.OddId2, CacheFixture.OddValue2, 
                      CacheFixture.Odd1Visibility2 as Odd2Visibility, CacheFixture.OddId3, CacheFixture.OddValue3, CacheFixture.Odd1Visibility3 as Odd3Visibility, CacheFixture.OddTypeCount, 
                      CacheFixture.TournamentId,CacheFixture.NeutralGround,
					  Language.[Parameter.Tournament].TournamentName,
					  Language.[Parameter.Category].CategoryName,
					  Language.[Parameter.Category].CategoryName+'-'+Language.[Parameter.Tournament].TournamentName as GroupName
					  ,null AS HasStreaming
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      @tFixture as  CacheFixture  ON Parameter.Competitor.CompetitorId = CacheFixture.HomeTeam ON Competitor_1.CompetitorId = CacheFixture.AwayTeam INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangId INNER JOIN
					  Language.[Parameter.Tournament] with (nolock) on Language.[Parameter.Tournament].TournamentId=CacheFixture.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangComp INNER JOIN
					  Parameter.Tournament with (nolock) on Parameter.Tournament.TournamentId=CacheFixture.TournamentId INNER JOIN
					  Language.[Parameter.Category] with (nolock) on Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
					  @TempTable AS temp ON CacheFixture.MatchId=temp.MatchId 
WHERE        CacheFixture.MatchDate > GETDATE() 
ORDER BY temp.CountBet desc
--ORDER BY temp.CountBet desc

END
GO
