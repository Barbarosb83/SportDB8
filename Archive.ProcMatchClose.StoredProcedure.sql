USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Archive].[ProcMatchClose]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Archive].[ProcMatchClose]


AS

update  Match.Setting set Match.Setting.StateId=1 where Match.Setting.SettingId in(
SELECT     Match.Setting.SettingId
FROM         Match.Fixture  with (nolock)  INNER JOIN
                      Match.FixtureDateInfo  with (nolock)  ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId INNER JOIN
                      Match.Match  with (nolock)  ON Match.Fixture.MatchId = Match.Match.MatchId INNER JOIN
                      Match.Setting  with (nolock)  ON Match.Match.MatchId = Match.Setting.MatchId
WHERE     (Match.FixtureDateInfo.MatchDate < GETDATE()) and Match.Setting.StateId=2)


GO
