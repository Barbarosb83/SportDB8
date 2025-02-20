USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameTest]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameTest] 

AS

BEGIN
SET NOCOUNT ON;

SELECT     Match.Match.MatchId, Match.Fixture.FixtureId, Match.FixtureDateInfo.MatchDate, Parameter.Competitor.CompetitorId AS Team1Id, 
                      Parameter.Competitor.CompetitorName AS Team1, CompetiTip_1.CompetitorId AS Team2Id, CompetiTip_1.CompetitorName AS Team2, Match.Match.TournamentId, 
                      Parameter.Sport.Icon, Parameter.Sport.IconColor, Language.[Parameter.Sport].SportName, Language.[Parameter.Tournament].TournamentName,
                          (SELECT     TOP (1) OddId
                            FROM          Match.Odd
                            WHERE      (MatchId = Match.Match.MatchId) AND (ParameterOddId = 1970)
                            ORDER BY OddId DESC) AS HomeOddId,
                          (SELECT     TOP (1) OddValue
                            FROM          Match.Odd AS Odd_9
                            WHERE      (MatchId = Match.Match.MatchId) AND (ParameterOddId = 1970)
                            ORDER BY OddId DESC) AS HomeOddValue,
                          (SELECT     TOP (1) OddId
                            FROM          Match.Odd AS Odd_8
                            WHERE      (MatchId = Match.Match.MatchId) AND (ParameterOddId = 1971)
                            ORDER BY OddId DESC) AS DrawOddId,
                          (SELECT     TOP (1) OddValue
                            FROM          Match.Odd AS Odd_7
                            WHERE      (MatchId = Match.Match.MatchId) AND (ParameterOddId = 1971)
                            ORDER BY OddId DESC) AS DrawOddValue,
                          (SELECT     TOP (1) OddId
                            FROM          Match.Odd AS Odd_6
                            WHERE      (MatchId = Match.Match.MatchId) AND (ParameterOddId = 1972)
                            ORDER BY OddId DESC) AS AwayOddId,
                          (SELECT     TOP (1) OddValue
                            FROM          Match.Odd AS Odd_5
                            WHERE      (MatchId = Match.Match.MatchId) AND (ParameterOddId = 1972)
                            ORDER BY OddId DESC) AS AwayOddValue,
                          (SELECT     TOP (1) OddId
                            FROM          Match.Odd AS Odd_4
                            WHERE      (MatchId = Match.Match.MatchId) AND (ParameterOddId = 1982)
                            ORDER BY OddId DESC) AS OverOddId,
                          (SELECT     TOP (1) OddValue
                            FROM          Match.Odd AS Odd_3
                            WHERE      (MatchId = Match.Match.MatchId) AND (ParameterOddId = 1982)
                            ORDER BY OddId DESC) AS OverOddValue,
                          (SELECT     TOP (1) OddId
                            FROM          Match.Odd AS Odd_2
                            WHERE      (MatchId = Match.Match.MatchId) AND (ParameterOddId = 1983)
                            ORDER BY OddId DESC) AS UnderOddId,
                          (SELECT     TOP (1) OddValue
                            FROM          Match.Odd AS Odd_1
                            WHERE      (MatchId = Match.Match.MatchId) AND (ParameterOddId = 1983)
                            ORDER BY OddId DESC) AS UnderOddValue
FROM         Parameter.Competitor INNER JOIN
                      Match.FixtureCompetitor AS FixtureCompetiTip_1 ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
                      Match.Match INNER JOIN
                      Match.Fixture ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN
                      Match.FixtureDateInfo ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId AND Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId ON 
                      FixtureCompetiTip_1.FixtureId = Match.Fixture.FixtureId INNER JOIN
                      Parameter.Competitor AS CompetiTip_1 INNER JOIN
                      Match.FixtureCompetitor ON CompetiTip_1.CompetitorId = Match.FixtureCompetitor.CompetitorId ON 
                      Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId INNER JOIN
                      Parameter.Tournament ON Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                      Language.[Parameter.Sport] ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId INNER JOIN
                      Language.[Parameter.Tournament] ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
                      Match.FixtureDateInfo.LanguageId = Language.[Parameter.Tournament].LanguageId AND 
                      Language.[Parameter.Sport].LanguageId = Language.[Parameter.Tournament].LanguageId INNER JOIN
                      Match.Setting ON Match.Match.MatchId = Match.Setting.MatchId
WHERE     (FixtureCompetiTip_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) AND (Match.FixtureDateInfo.LanguageId = 1) 
and (select count(OddId) from Match.Odd where Match.Odd.MatchId=Match.Match.MatchId and ParameterOddId=1972 )>0 and Match.Setting.StateId=2
order by Match.FixtureDateInfo.MatchDate




END


GO
