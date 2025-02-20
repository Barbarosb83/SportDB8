USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataResultOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameDataResultOne] 
@MatchId int,
@LangId int,
@username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;




if exists(select Archive.Match.MatchId from Archive.Match with (nolock) where Archive.Match.MatchId=@MatchId)
begin
select [Archive].Match.MatchId,[Archive].Fixture.FixtureId,dbo.UserTimeZoneDate(''+@username+'',[Archive].FixtureDateInfo.MatchDate,0) as MatchDate,Parameter.Competitor.CompetitorId AS Team1Id, 
Parameter.Competitor.CompetitorName AS Team1,CompetiTip_1.CompetitorId AS Team2Id,CompetiTip_1.CompetitorName AS Team2,[Archive].Match.TournamentId, 
[Archive].Setting.StateId,Parameter.MatchState.State,Parameter.MatchState.StatuColor,[Archive].Setting.LossLimit,[Archive].Setting.LimitPerTicket,[Archive].Setting.StakeLimit,[Archive].Setting.AvailabilityId, 
Parameter.MatchAvailability.Availability,[Archive].Setting.MinCombiBranch,[Archive].Setting.MinCombiInternet,[Archive].Setting.MinCombiMachine,Parameter.Sport.Icon,Parameter.Sport.IconColor, Language.[Parameter.Sport].SportName,Language.[Parameter.Tournament].TournamentName,dbo.FuncCashFlow(0,[Archive].Setting.MatchId,4,0) as CashFlow,[Archive].Setting.IsPopular,Parameter.Category.CategoryName
FROM Parameter.Competitor INNER JOIN
                      [Archive].FixtureCompetitor AS FixtureCompetiTip_1 ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
                      [Archive].Match INNER JOIN
                      [Archive].Fixture ON [Archive].Match.MatchId = [Archive].Fixture.MatchId INNER JOIN
                      [Archive].FixtureDateInfo ON [Archive].Fixture.FixtureId = [Archive].FixtureDateInfo.FixtureId AND [Archive].Fixture.FixtureId = [Archive].FixtureDateInfo.FixtureId ON 
                      FixtureCompetiTip_1.FixtureId = [Archive].Fixture.FixtureId INNER JOIN
                      Parameter.Competitor AS CompetiTip_1 INNER JOIN
                      [Archive].FixtureCompetitor ON CompetiTip_1.CompetitorId = [Archive].FixtureCompetitor.CompetitorId ON 
                      [Archive].Fixture.FixtureId = [Archive].FixtureCompetitor.FixtureId INNER JOIN
                      [Archive].Setting ON [Archive].Match.MatchId = [Archive].Setting.MatchId INNER JOIN
                      Parameter.MatchState ON [Archive].Setting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON [Archive].Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.Tournament ON [Archive].Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                      Language.[Parameter.Sport] ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId INNER JOIN
                      Language.[Parameter.Tournament] ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
                      [Archive].FixtureDateInfo.LanguageId = Language.[Parameter.Tournament].LanguageId AND 
                      Language.[Parameter.Sport].LanguageId = Language.[Parameter.Tournament].LanguageId 
WHERE (FixtureCompetiTip_1.TypeId = 1) AND ([Archive].FixtureCompetitor.TypeId = 2) AND [Archive].Match.MatchId=@MatchId
end
else if exists(select [Match].Match.MatchId from [Match].Match with (nolock) where [Match].Match.MatchId=@MatchId)
begin
select [Match].Match.MatchId,[Match].Fixture.FixtureId,dbo.UserTimeZoneDate(''+@username+'',[Match].FixtureDateInfo.MatchDate,0) as MatchDate,Parameter.Competitor.CompetitorId AS Team1Id, 
Parameter.Competitor.CompetitorName AS Team1,CompetiTip_1.CompetitorId AS Team2Id,CompetiTip_1.CompetitorName AS Team2,[Match].Match.TournamentId, 
[Match].Setting.StateId,Parameter.MatchState.State,Parameter.MatchState.StatuColor,[Match].Setting.LossLimit,[Match].Setting.LimitPerTicket,[Match].Setting.StakeLimit,[Match].Setting.AvailabilityId, 
Parameter.MatchAvailability.Availability,[Match].Setting.MinCombiBranch,[Match].Setting.MinCombiInternet,[Match].Setting.MinCombiMachine,Parameter.Sport.Icon,Parameter.Sport.IconColor, Language.[Parameter.Sport].SportName,Language.[Parameter.Tournament].TournamentName,dbo.FuncCashFlow(0,[Match].Setting.MatchId,4,0) as CashFlow,[Match].Setting.IsPopular,Parameter.Category.CategoryName
FROM Parameter.Competitor INNER JOIN
                      [Match].FixtureCompetitor AS FixtureCompetiTip_1 ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
                      [Match].Match INNER JOIN
                      [Match].Fixture ON [Match].Match.MatchId = [Match].Fixture.MatchId INNER JOIN
                      [Match].FixtureDateInfo ON [Match].Fixture.FixtureId = [Match].FixtureDateInfo.FixtureId AND [Match].Fixture.FixtureId = [Match].FixtureDateInfo.FixtureId ON 
                      FixtureCompetiTip_1.FixtureId = [Match].Fixture.FixtureId INNER JOIN
                      Parameter.Competitor AS CompetiTip_1 INNER JOIN
                      [Match].FixtureCompetitor ON CompetiTip_1.CompetitorId = [Match].FixtureCompetitor.CompetitorId ON 
                      [Match].Fixture.FixtureId = [Match].FixtureCompetitor.FixtureId INNER JOIN
                      [Match].Setting ON [Match].Match.MatchId = [Match].Setting.MatchId INNER JOIN
                      Parameter.MatchState ON [Match].Setting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON [Match].Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.Tournament ON [Match].Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                      Language.[Parameter.Sport] ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId INNER JOIN
                      Language.[Parameter.Tournament] ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
                      [Match].FixtureDateInfo.LanguageId = Language.[Parameter.Tournament].LanguageId AND 
                      Language.[Parameter.Sport].LanguageId = Language.[Parameter.Tournament].LanguageId 
WHERE (FixtureCompetiTip_1.TypeId = 1) AND ([Match].FixtureCompetitor.TypeId = 2) AND [Match].Match.MatchId=@MatchId
end


END


GO
