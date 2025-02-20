USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentDate]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcTournamentDate] 
@TournamentId int,
@StartDate datetime,
@EndDate datetime
AS

BEGIN
SET NOCOUNT ON;

SELECT DISTINCT CAST(Match.FixtureDateInfo.MatchDate AS Date) AS TournamentDate, Match.Match.TournamentId
FROM         Match.Match with (nolock) INNER JOIN
                      Match.Fixture with (nolock) ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN
                      Match.FixtureDateInfo with (nolock) ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId INNER JOIN
                      Match.Setting with (nolock) ON Match.Match.MatchId = Match.Setting.MatchId
WHERE     (Match.Match.TournamentId = @TournamentId) AND (CAST(Match.FixtureDateInfo.MatchDate AS Date) >= cast(@StartDate as date)) AND 
                      (CAST(Match.FixtureDateInfo.MatchDate AS Date) <= cast(@EndDate as date)) and Match.Setting.StateId=2  AND (Match.Match.MatchId IN
                          (SELECT     MatchId
                            FROM          Match.Odd  with (nolock) ))


END


GO
