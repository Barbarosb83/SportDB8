USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentEventList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [GamePlatform].[ProcTournamentEventList] 
@TournamentId int,
@TournamentDate datetime,
@LangId int

AS

BEGIN
SET NOCOUNT ON;

declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2


SELECT DISTINCT 
                      TOP (100) PERCENT Match.Match.MatchId, Match.FixtureDateInfo.MatchDate, 
                      Language.ParameterCompetitor.CompetitorName + '-' + ParameterCompetitor_1.CompetitorName AS EventName, Language.[Parameter.Sport].SportName, 
                      Odd_3.OddId AS OddId1, Odd_3.OddValue AS OddValue1, CASE WHEN Odd_3.StateId <> 2 THEN 'hidden' ELSE '' END AS Odd1Visibility, 
                      Odd_1.OddId AS OddId2, Odd_1.OddValue AS OddValue2, CASE WHEN Odd_1.StateId <> 2 AND 
                      Language.[Parameter.Sport].SportId in (5,20,14,16,18) THEN 'hidden' ELSE '' END AS Odd2Visibility, Odd_2.OddId AS OddId3, Odd_2.OddValue AS OddValue3, 
                      CASE WHEN Odd_2.StateId <> 2 THEN 'hidden' ELSE '' END AS Odd3Visibility,
                          (SELECT     COUNT(DISTINCT OddTypeId) AS Expr1
                            FROM          Match.OddTypeSetting  with (nolock) 
                            WHERE      (MatchId = Match.Match.MatchId) AND (StateId = 2)) AS OddTypeCount, @TournamentId AS TournamentId,Match.Fixture.NeutralGround,null AS HasStreaming
FROM         Parameter.Tournament with (nolock) INNER JOIN
                      Match.FixtureCompetitor AS FixtureCompetitor_1 with (nolock) INNER JOIN
                      Match.Match with (nolock) INNER JOIN
                      Match.Fixture with (nolock) ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN
                      Match.FixtureDateInfo with (nolock) ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId ON 
                      FixtureCompetitor_1.FixtureId = Match.Fixture.FixtureId INNER JOIN
                      Match.FixtureCompetitor with (nolock) ON Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId AND Match.FixtureDateInfo.FixtureId = Match.FixtureCompetitor.FixtureId AND 
                      FixtureCompetitor_1.FixtureId = Match.FixtureCompetitor.FixtureId ON Parameter.Tournament.TournamentId = Match.Match.TournamentId INNER JOIN
                      Parameter.Category with (nolock)  ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                      Language.[Parameter.Sport] with (nolock) ON Parameter.Category.SportId = Language.[Parameter.Sport].SportId INNER JOIN
                      Match.Setting with (nolock) ON Match.Match.MatchId = Match.Setting.MatchId AND Match.Fixture.MatchId = Match.Setting.MatchId INNER JOIN
                      Match.Odd AS Odd_3 with (nolock) ON Match.Match.MatchId = Odd_3.MatchId AND Match.Fixture.MatchId = Odd_3.MatchId INNER JOIN
                      Match.Odd AS Odd_1 with (nolock) ON Match.Match.MatchId = Odd_1.MatchId AND Match.Fixture.MatchId = Odd_1.MatchId AND Odd_3.MatchId = Odd_1.MatchId INNER JOIN
                      Match.Odd AS Odd_2 with (nolock) ON Match.Match.MatchId = Odd_2.MatchId AND Match.Fixture.MatchId = Odd_2.MatchId AND Odd_1.MatchId = Odd_2.MatchId AND 
                      Match.Setting.MatchId = Odd_2.MatchId AND Odd_3.MatchId = Odd_2.MatchId INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON FixtureCompetitor_1.CompetitorId = Language.ParameterCompetitor.CompetitorId AND 
                      Language.[Parameter.Sport].LanguageId = Language.ParameterCompetitor.LanguageId INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Match.FixtureCompetitor.CompetitorId = ParameterCompetitor_1.CompetitorId AND 
                      Language.ParameterCompetitor.LanguageId = ParameterCompetitor_1.LanguageId AND 
                      Language.[Parameter.Sport].LanguageId = ParameterCompetitor_1.LanguageId INNER JOIN
                      GamePlatform.[Parameter.GamePlatformTopOdd] with (nolock) ON Odd_3.ParameterOddId = GamePlatform.[Parameter.GamePlatformTopOdd].ParameterOddId AND 
                      Language.[Parameter.Sport].SportId = GamePlatform.[Parameter.GamePlatformTopOdd].SportId INNER JOIN
                      GamePlatform.[Parameter.GamePlatformTopOdd] AS [Parameter.GamePlatformTopOdd_1] with (nolock) ON 
                      Odd_1.ParameterOddId = [Parameter.GamePlatformTopOdd_1].ParameterOddId AND 
                      GamePlatform.[Parameter.GamePlatformTopOdd].SportId = [Parameter.GamePlatformTopOdd_1].SportId AND 
                      Language.[Parameter.Sport].SportId = [Parameter.GamePlatformTopOdd_1].SportId INNER JOIN
                      GamePlatform.[Parameter.GamePlatformTopOdd] AS [Parameter.GamePlatformTopOdd_2] with (nolock) ON 
                      Odd_2.ParameterOddId = [Parameter.GamePlatformTopOdd_2].ParameterOddId AND 
                      [Parameter.GamePlatformTopOdd_1].SportId = [Parameter.GamePlatformTopOdd_2].SportId AND 
                      GamePlatform.[Parameter.GamePlatformTopOdd].SportId = [Parameter.GamePlatformTopOdd_2].SportId AND 
                      Language.[Parameter.Sport].SportId = [Parameter.GamePlatformTopOdd_2].SportId  
WHERE     (Match.Match.TournamentId = @TournamentId) AND (FixtureCompetitor_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) AND (Match.Setting.StateId = 2) AND 
                      (CAST(Match.FixtureDateInfo.MatchDate AS Date) = CAST(@TournamentDate AS date)) AND (Language.[Parameter.Sport].LanguageId = @LangId) AND 
                      (Language.ParameterCompetitor.LanguageId = @LangComp) AND (ParameterCompetitor_1.LanguageId = @LangComp) AND 
                      (GamePlatform.[Parameter.GamePlatformTopOdd].OutCome = '1') AND ([Parameter.GamePlatformTopOdd_1].OutCome = 'X') AND 
                      ([Parameter.GamePlatformTopOdd_2].OutCome = '2')
ORDER BY Match.FixtureDateInfo.MatchDate

END




GO
