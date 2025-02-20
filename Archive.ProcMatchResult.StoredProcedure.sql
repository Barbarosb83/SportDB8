USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Archive].[ProcMatchResult]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Archive].[ProcMatchResult]


AS

BEGIN TRAN
declare @CheckDateInterval int=-4




declare @TempTable table (MatchId bigint,FixtureId bigint)


insert @TempTable
SELECT     [Archive].Match.MatchId, [Archive].Fixture.FixtureId
FROM         [Archive].Fixture  with (nolock) INNER JOIN
                      [Archive].FixtureDateInfo  with (nolock) ON [Archive].Fixture.FixtureId = [Archive].FixtureDateInfo.FixtureId  INNER JOIN
                      [Archive].Match  with (nolock)  ON [Archive].Fixture.MatchId = [Archive].Match.MatchId
WHERE     ([Archive].FixtureDateInfo.MatchDate < DATEADD(HOUR,@CheckDateInterval,GETDATE()))
 
--------------------------------------------------------------------DELETE-------------------------------

DELETE FROM Match.Card WHERE Match.Card.MatchId in (select MatchId from @TempTable)

DELETE FROM  Match.Goal WHERE Match.Goal.MatchId in (select MatchId from @TempTable)

DELETE  FROM  Match.ScoreComment WHERE Match.ScoreComment.MatchId in (select MatchId from @TempTable)

DELETE    FROM  Match.ScoreInfo WHERE Match.ScoreInfo.MatchId in (select MatchId from @TempTable)


DELETE   FROM  Match.OddsResult WHERE Match.OddsResult.MatchId in (select MatchId from @TempTable)


COMMIT TRAN


GO
