USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcSportFixtureTerminalSearch]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
 
CREATE PROCEDURE [GamePlatform].[ProcSportFixtureTerminalSearch] 
@SearchText nvarchar(250),
@LangId int
AS
BEGIN
SET NOCOUNT ON;
declare @EventDate datetime
set @EventDate=DATEADD(DAY,15,GETDATE())
--	declare @tempMatch table (MatchId bigint)


--declare @temptable table (MatchId bigint,OverUnder nvarchar(20),Overs float,Unders float,OverId bigint,UnderId bigint)

	
--	declare @temptable2 table (MatchId bigint,OverUnder nvarchar(20),Overs float,Unders float,OverId bigint,UnderId bigint)

declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2
	
--declare @TempTableComp Table(Ids bigint)

--	insert @TempTableComp 
--select DISTINCT Language.ParameterCompetitor.CompetitorId
--FROM         
--                      Language.ParameterCompetitor with (nolock)  
--                       where Language.ParameterCompetitor.CompetitorName like '%'+@SearchText+'%' and Language.ParameterCompetitor.LanguageId=@LangComp

 

 

SELECT  DISTINCT   Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                      Language.[Parameter.Sport].SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, 
                      Cache.Fixture.Odd1Visibility2 as Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, Cache.Fixture.Odd1Visibility3 as Odd3Visibility, Cache.Fixture.OddTypeCount, 
                      Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround
					   ,case when Match.Code.BetradarMatchId is not null then 1 else 0 end AS IsLive
					   ,'' as Total
					   ,cast(0 as float) as TotalOver
					   ,cast(0 as float) as TotalUnder
					   ,cast(0 as bigint)  as TotalOverId
					   ,cast(0 as bigint) as TotalUnderId
					   ,Parameter.Tournament.CategoryId
					   ,ISNULL(Parameter.Category.SequenceNumber,999) as SequenceNumber
					   ,Parameter.Tournament.IsPopularTerminal
					   ,Language.[Parameter.Tournament].TournamentName,Language.[Parameter.Category].CategoryName
					   ,Cache.Fixture.SportName as SportNameOrginal
					     ,LOWER(Parameter.Iso.IsoName2) as IsoName
							   ,Match.Code.Code
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
					  Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN
                         Match.Code with (nolock) ON Cache.Fixture.BetradarMatchId = Match.Code.BetradarMatchId and Match.Code.BetTypeId=0 INNER JOIN Parameter.Category  with (nolock) On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						   Parameter.Iso with (nolock)  On Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN Language.[Parameter.Tournament] with (nolock)  ON
						 Language.[Parameter.Tournament].TournamentId=Parameter.Tournament.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN Language.[Parameter.Category] with (nolock)  ON
						 Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
						 Language.[Parameter.Sport] with (nolock)  ON Language.[Parameter.Sport].SportId=Parameter.Category.SportId and Language.[Parameter.Sport].LanguageId=@LangId
Where  (ParameterCompetitor_1.CompetitorName like '%'+@SearchText+'%' or Language.ParameterCompetitor.CompetitorName like '%'+@SearchText+'%' )
and  Cache.Fixture.MatchDate>DATEADD(MINUTE,2,GETDATE())
 
  

 

END




GO
