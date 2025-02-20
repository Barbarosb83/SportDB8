USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Cache].[FillTournamentsbyDay]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Cache].[FillTournamentsbyDay]
	@EndDay int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;

SET NOCOUNT ON;

       SELECT DISTINCT Parameter.Tournament.TournamentId, Parameter.Tournament.CategoryId, 0 AS TournamentSportEventCount, @EndDay AS EndDay,
                          (SELECT     COUNT(*) AS Expr1
                            FROM          Match.Odd
                            WHERE      (MatchId = Match.Match.MatchId)) AS OddCount
FROM         Parameter.Tournament with (nolock) INNER JOIN
                      Match.Match with (nolock) ON Parameter.Tournament.TournamentId = Match.Match.TournamentId AND 
                      Parameter.Tournament.TournamentId = Match.Match.TournamentId INNER JOIN
                      Match.Fixture with (nolock) ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN
                      Match.FixtureDateInfo with (nolock) ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId  INNER JOIN
                      Match.Setting with (nolock) ON Match.Match.MatchId = Match.Setting.MatchId INNER JOIN
                      Match.Odd AS Odd_1 with (nolock) ON Match.Match.MatchId = Odd_1.MatchId INNER JOIN
                      --Match.OddSetting with (nolock) ON Odd_1.OddId = Match.OddSetting.OddId INNER JOIN
                      GamePlatform.[Parameter.GamePlatformTopOdd] ON Odd_1.ParameterOddId = GamePlatform.[Parameter.GamePlatformTopOdd].ParameterOddId
WHERE   Parameter.Tournament.IsActive=1 and (Match.Setting.StateId = 2) AND (Match.FixtureDateInfo.MatchDate  >= GETDATE() ) AND (CAST(Match.FixtureDateInfo.MatchDate AS Date) 
                      <= CAST(DATEADD(day, @EndDay, GETDATE()) AS date)) --AND (Match.OddSetting.StateId = 2)
                     


 
    
END


GO
