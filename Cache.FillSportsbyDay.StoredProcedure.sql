USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Cache].[FillSportsbyDay]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Cache].[FillSportsbyDay]
	@EndDay int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
SELECT     Parameter.Sport.SportId, 
                          (SELECT     COUNT(Match.Match.MatchId) AS SportEventCount
                            FROM          Parameter.Tournament with (nolock) INNER JOIN
                                                   Match.Match with (nolock) ON Parameter.Tournament.TournamentId = Match.Match.TournamentId INNER JOIN
                                                   Parameter.Category  with (nolock)  ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                                                   Match.Setting with (nolock)  ON Match.Match.MatchId = Match.Setting.MatchId INNER JOIN
                                                   Match.Fixture with (nolock)  ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN
                                                   Match.FixtureDateInfo with (nolock)  ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId 
                            WHERE      (Match.Setting.StateId = 2) AND (Parameter.Category.SportId = Parameter.Sport.SportId) 
                            AND ( Match.FixtureDateInfo.MatchDate  )>=  GETDATE()  AND (CAST(Match.FixtureDateInfo.MatchDate AS Date)<= CAST(DATEADD(day,@EndDay,GETDATE()) AS date) AND
                          ((SELECT     COUNT(Match.Odd.OddId) AS Expr1
FROM         Match.Odd with (nolock)
 --INNER JOIN Match.OddSetting with (nolock) ON Match.Odd.OddId = Match.OddSetting.OddId
WHERE     (Match.Odd.MatchId = Match.Match.MatchId) and Match.Odd.StateId=2) > 0))
                           ) AS SportEventCount,@EndDay as EndDay
FROM          Parameter.Sport 
WHERE     
 (SELECT     COUNT(Match.Match.MatchId)
                            FROM          Parameter.Tournament INNER JOIN
                                                   Match.Match with (nolock) ON Parameter.Tournament.TournamentId = Match.Match.TournamentId  INNER JOIN
                                                   Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                                                   Match.Setting with (nolock) ON Match.Match.MatchId = Match.Setting.MatchId INNER JOIN
                                                   Match.Fixture with (nolock) ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN
                                                   Match.FixtureDateInfo with (nolock) ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId 
                            WHERE      (Match.Setting.StateId = 2) AND (Parameter.Category.SportId = Parameter.Sport.SportId) and Parameter.Sport.IsActive=1
                            AND ( Match.FixtureDateInfo.MatchDate >=  GETDATE() ) AND (CAST(Match.FixtureDateInfo.MatchDate AS Date)<= CAST(DATEADD(day,@EndDay,GETDATE()) AS date))
                            )>0


    
 
    
END


GO
