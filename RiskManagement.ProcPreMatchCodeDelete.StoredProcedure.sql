USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcPreMatchCodeDelete]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [RiskManagement].[ProcPreMatchCodeDelete] 

 AS

BEGIN TRAN 


declare @TempTable table (MatchId bigint,FixtureId bigint)


insert @TempTable
SELECT     Match.Match.MatchId, Match.Fixture.FixtureId
FROM         Match.Fixture with (nolock) INNER JOIN
                      Match.FixtureDateInfo with (nolock) ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId INNER JOIN
                      Match.Match ON Match.Fixture.MatchId = Match.Match.MatchId
where Match.FixtureDateInfo.MatchDate<GETDATE() 

--update     Match.Setting set Match.Setting.StateId=1
--where Match.Setting.MatchId in (select MatchId from @TempTable)


 
 

delete Match.Code where Match.Code.MatchId in (select MatchId from @TempTable) and BetTypeId=0

update Parameter.MatchCode set IsUsed=0 where Code not in (select Match.Code.Code from Match.Code)
 

COMMIT TRAN


GO
