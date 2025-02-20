USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcFixtureTopEvent]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [GamePlatform].[ProcFixtureTopEvent] 
@LangId int
AS

BEGIN
SET NOCOUNT ON;
 
 declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2

SELECT Cache.Fixture.BetradarMatchId, Cache.Fixture.MatchId, Cache.Fixture.MatchDate, 
                         Language.ParameterCompetitor.CompetitorName + '-' + ParameterCompetitor_1.CompetitorName AS EventName, Cache.Fixture.SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, 
                         Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, Cache.Fixture.Odd1Visibility2 AS Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, 
                         Cache.Fixture.Odd1Visibility3 AS Odd3Visibility, Cache.Fixture.OddTypeCount, Cache.Fixture.TournamentId, Cache.Fixture.MatchDate AS TournamentDate, Language.[Parameter.Tournament].TournamentName, 
                         Language.[Parameter.Category].CategoryName, Language.[Parameter.Category].CategoryName + '-' + Language.[Parameter.Tournament].TournamentName AS GroupName, Cache.Fixture.NeutralGround, 
                         Live.EventLiveStreaming.Web AS HasStreaming
FROM            Parameter.Competitor  AS Competitor_1 with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) INNER JOIN
                         Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId AND Language.ParameterCompetitor.LanguageId = @LangComp INNER JOIN
                         Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
                         Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId AND ParameterCompetitor_1.LanguageId = @LangComp INNER JOIN
                         Language.[Parameter.Tournament] with (nolock) ON Language.[Parameter.Tournament].TournamentId = Cache.Fixture.TournamentId AND Language.[Parameter.Tournament].LanguageId = @LangId INNER JOIN
                         Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId = Cache.Fixture.TournamentId INNER JOIN
                         Language.[Parameter.Category] with (nolock) ON Language.[Parameter.Category].CategoryId = Parameter.Tournament.CategoryId AND Language.[Parameter.Category].LanguageId = @LangId LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Cache.Fixture.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId INNER JOIN
						 Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Language.[Parameter.Category].CategoryId
WHERE        (Cache.Fixture.IsPopular = 1) AND (Cache.Fixture.MatchDate > GETDATE())
ORDER BY Parameter.Category.SequenceNumber,Language.[Parameter.Category].CategoryName + '-' + Language.[Parameter.Tournament].TournamentName,Cache.Fixture.MatchDate




END


GO
