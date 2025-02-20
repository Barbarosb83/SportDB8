USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[MTS.ProcSelection]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [BetAcceptance].[MTS.ProcSelection] 
 @TicketId bigint
AS

SELECT        SelectionId, TicketId, line, BetradarOddsTypeId,
 BetradarOddsSubTypeId, SpecialBetValue, Outcome, BetradarMatchId,
  OddValue, bank,
   case when ((select COUNT(DISTINCT Match.Match.BetradarMatchId) from Match.Match where Match.Match.BetradarMatchId in (select BetradarMatchId from MTS.Selection where MTS.Selection.TicketId=@TicketId) and Match.Match.TournamentId in (select Parameter.Tournament.TournamentId from Parameter.Tournament where (TournamentName LIKE '%H2H%'))))>1 then 1 else ways end as ways,
    OddId, Amount, StateId, BetTypeId, MatchId, ParameterOddId, 
                         EventName, EventDate, CurrencyId
FROM            MTS.Selection
WHERE  MTS.Selection.TicketId=@TicketId


GO
