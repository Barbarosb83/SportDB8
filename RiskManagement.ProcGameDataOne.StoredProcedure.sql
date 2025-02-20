USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameDataOne] 
@MatchId int,
@LangId int,
@username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;

select Match.Match.MatchId,Match.Fixture.FixtureId,dbo.UserTimeZoneDate(''+@Username+'',Match.FixtureDateInfo.MatchDate,0) as MatchDate,Parameter.Competitor.CompetitorId AS Team1Id, 
Parameter.Competitor.CompetitorName AS Team1,CompetiTip_1.CompetitorId AS Team2Id,CompetiTip_1.CompetitorName AS Team2,Match.Match.TournamentId, 
Match.Setting.StateId,[Language].[Parameter.MatchState].[MatchState] as State,Parameter.MatchState.StatuColor,Match.Setting.LossLimit,Match.Setting.LimitPerTicket,Match.Setting.StakeLimit,Match.Setting.AvailabilityId,
Parameter.MatchAvailability.Availability,Match.Setting.MinCombiBranch,Match.Setting.MinCombiInternet,Match.Setting.MinCombiMachine,Parameter.Sport.Icon,Parameter.Sport.IconColor, Language.[Parameter.Sport].SportName,Language.[Parameter.Tournament].TournamentName,Match.Fixture.Comment,Match.Fixture.VenueId,Match.Setting.IsPopular,Language.[Parameter.Category].CategoryName
FROM Parameter.Competitor with (nolock) INNER JOIN
                      Match.FixtureCompetitor AS FixtureCompetiTip_1 with (nolock) ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
                      Match.Match with (nolock) INNER JOIN
                      Match.Fixture with (nolock) ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN
                      Match.FixtureDateInfo with (nolock) ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId AND Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId ON 
                      FixtureCompetiTip_1.FixtureId = Match.Fixture.FixtureId INNER JOIN
                      Parameter.Competitor  AS CompetiTip_1 with (nolock) INNER JOIN
                      Match.FixtureCompetitor with (nolock)  ON CompetiTip_1.CompetitorId = Match.FixtureCompetitor.CompetitorId ON 
                      Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId INNER JOIN
                      Match.Setting with (nolock)  ON Match.Match.MatchId = Match.Setting.MatchId INNER JOIN
                      [Language].[Parameter.MatchState] with (nolock)  ON Match.Setting.StateId = [Language].[Parameter.MatchState].[MatchStateId] INNER JOIN
					  Parameter.MatchState with (nolock)  ON Parameter.MatchState.StateId=Match.Setting.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock)  ON Match.Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
					  Parameter.Tournament with (nolock)  ON Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category with (nolock)  ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
					  Language.[Parameter.Category] with (nolock)  ON Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId INNER JOIN
                      Parameter.Sport with (nolock)  ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                      Language.[Parameter.Sport] with (nolock)  ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId INNER JOIN
                      Language.[Parameter.Tournament] with (nolock)  ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
                      Language.[Parameter.Sport].LanguageId = Language.[Parameter.Tournament].LanguageId AND Language.[Parameter.Category].LanguageId= Language.[Parameter.Sport].LanguageId AND [Language].[Parameter.MatchState].LanguageId=Language.[Parameter.Sport].LanguageId
WHERE (FixtureCompetiTip_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) AND  Match.MatchId=@MatchId and Match.FixtureCompetitor.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416) and Language.[Parameter.Sport].LanguageId=@LangId
and FixtureCompetiTip_1.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)
END



GO
