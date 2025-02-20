USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Cache].[FillCategoriesbyDay]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Cache].[FillCategoriesbyDay]
	@EndDay int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;


SELECT     Parameter.Category.CategoryId,
           Parameter.Category.SportId,
           0 AS CategoryEventCount, 
           SUBSTRING(LOWER(Parameter.Iso.IsoName), 0, 3) AS IsoName, 
           Parameter.Category.Ispopular,@EndDay as EndDay
FROM         Parameter.Category with (nolock) INNER JOIN
                      Parameter.Iso with (nolock) ON Parameter.Category.IsoId = Parameter.Iso.IsoId 
WHERE                                 ((SELECT     COUNT(Match_1.MatchId) AS Expr1
                              FROM         Parameter.Tournament AS Tournament_1 with (nolock) INNER JOIN
                                                    Match.Match AS Match_1 with (nolock) ON Tournament_1.TournamentId = Match_1.TournamentId INNER JOIN
                                                    Match.Setting AS Setting_1 with (nolock) ON Match_1.MatchId = Setting_1.MatchId INNER JOIN
                                                    Match.Fixture AS Fixture_1 with (nolock) ON Match_1.MatchId = Fixture_1.MatchId INNER JOIN
                                                    Match.FixtureDateInfo AS FixtureDateInfo_1 with (nolock) ON Fixture_1.FixtureId = FixtureDateInfo_1.FixtureId 
                              WHERE     (Setting_1.StateId = 2) AND ( FixtureDateInfo_1.MatchDate   >= GETDATE() ) 
							  AND (CAST(FixtureDateInfo_1.MatchDate AS Date) <= CAST(DATEADD(day, @EndDay, GETDATE()) AS date)) AND 
                                                    (Tournament_1.CategoryId = Parameter.Category.CategoryId) 
                                                    AND
                                                        ((SELECT     COUNT(Odd_1.OddId) AS Expr1
                                                            FROM         Match.FixtureDateInfo with (nolock) INNER JOIN
                      Match.Fixture with (nolock) ON Match.FixtureDateInfo.FixtureId = Match.Fixture.FixtureId INNER JOIN
                      Match.Odd AS Odd_1 with (nolock) ON Match.Fixture.MatchId = Odd_1.MatchId 
					  --INNER JOIN Match.OddSetting with (nolock) ON Odd_1.OddId = Match.OddSetting.OddId
                                                            WHERE     (Odd_1.MatchId = Match_1.MatchId) AND ( FixtureDateInfo.MatchDate   >=  GETDATE() 
                                                    ) AND (CAST(FixtureDateInfo.MatchDate AS Date) <= CAST(DATEADD(day, @EndDay, GETDATE()) AS date)) ) > 0)) > 0)




    
 
    
END


GO
