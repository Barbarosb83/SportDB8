USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcMobileFixtureShow]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [GamePlatform].[ProcMobileFixtureShow] 
@Tournaments nvarchar(max),
@LangId int

AS

BEGIN
SET NOCOUNT ON;

declare @SportId int
declare @TournamentId nvarchar(max)
declare @TimeRandeId int

declare @StartDate date
declare @EndDate date


set @TournamentId=@Tournaments

set @StartDate=GetDate()
set @EndDate=DATEADD(MONTH,6,GetDate())

declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2

if (@TournamentId is not null)
begin

	----
	DECLARE @Delimeter char(1)
	SET @Delimeter = ','
	declare @sayac int=0
	DECLARE @tblOdd TABLE(oddId bigint)
	DECLARE @ak nvarchar(10)
	DECLARE @StartPos int, @Length int
	WHILE LEN(@TournamentId) > 0
	  BEGIN
		SET @StartPos = CHARINDEX(@Delimeter, @TournamentId)
		IF @StartPos < 0 SET @StartPos = 0
		SET @Length = LEN(@TournamentId) - @StartPos - 1
		IF @Length < 0 SET @Length = 0
		IF @StartPos > 0
		  BEGIN
			SET @ak = SUBSTRING(@TournamentId, 1, @StartPos - 1)
			SET @TournamentId = SUBSTRING(@TournamentId, @StartPos + 1, LEN(@TournamentId) - @StartPos)
			set @sayac=@sayac+1
		  END
		ELSE
		  BEGIN
			SET @ak = @TournamentId
			SET @TournamentId = ''
			set @sayac=@sayac+1
		  END
		INSERT @tblOdd (oddId) VALUES(@ak)
	END
	----
	
	SELECT     Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
	  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
						  Cache.Fixture.SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, 
						  Cache.Fixture.Odd1Visibility2 as Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, Cache.Fixture.Odd1Visibility3 as Odd3Visibility, Cache.Fixture.OddTypeCount, 
						  Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,
						  Language.[Parameter.Category].CategoryName+' » '+Language.[Parameter.Tournament].TournamentName as TournamentName
						  ,Live.EventLiveStreaming.Web AS HasStreaming
	FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
						  Parameter.Competitor with (nolock) INNER JOIN
						  Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
						  Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
						  Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN
						  Language.[Parameter.Tournament] with (nolock) ON  Language.[Parameter.Tournament].TournamentId=Cache.Fixture.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						  Parameter.Tournament with (nolock) on Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
						  Language.[Parameter.Category] with (nolock) ON Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId  and Language.[Parameter.Category].LanguageId=@LangId LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Cache.Fixture.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId
	Where  Cache.Fixture.TournamentId in (select oddId from @tblOdd) and 
			((CAST(Cache.Fixture.MatchDate AS Date))<(CAST(@EndDate AS Date))) and ((CAST(Cache.Fixture.MatchDate AS Date)>=(CAST(@StartDate AS Date)))) and  Cache.Fixture.MatchDate>GETDATE()
	order by Cache.Fixture.MatchDate
end

end


GO
