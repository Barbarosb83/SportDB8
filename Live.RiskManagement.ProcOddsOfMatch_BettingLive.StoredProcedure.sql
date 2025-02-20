USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcOddsOfMatch_BettingLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[RiskManagement.ProcOddsOfMatch_BettingLive]
	@EventId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT     Live.EventOdd.OddId, Live.[Parameter.OddType].OddTypeId, Live.[Parameter.OddType].OddType, Live.EventOdd.OutCome, Live.EventOdd.SpecialBetValue, 
                      Live.EventOdd.OddValue, Live.EventOdd.Suggestion
					  , cast(1 as float) as OddFactor
					  , Live.EventOdd.IsChanged, Live.EventOdd.IsActive
						  , cast([BettingLive].Live.EventOddResult.OddResult  as bit ) as   OddResult
					  ,  [BettingLive].Live.EventOddResult.VoidFactor as   VoidFactor, 
                      cast( ( [BettingLive].Live.EventOddResult.IsCanceled) as bit) as  IsCanceled,
                      Live.EventOddTypeSetting.LossLimit, Live.EventOddTypeSetting.LimitPerTicket, Live.EventOddTypeSetting.StakeLimit, Live.EventOddTypeSetting.OddTypeSettingId as  OddSettingId, 
                      ISNULL( [BettingLive].Live.EventOddResult.StateId,2) as  StateId 
					  , Live.EventOddTypeSetting.AvailabilityId, Live.EventOdd.IsOddValueLock,   
                      cast([BettingLive].Live.EventOddResult.IsEvaluated  as bit) as  IsEvaluated,
					  dbo.FuncCashFlow(Live.EventOdd.OddId,0,0,1) as Stake,
					  (select COUNT(Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.OddId=Live.EventOdd.OddId) as Bet
FROM         Live.EventOdd with (nolock) INNER JOIN
                      Live.[Parameter.OddType] with (nolock) ON Live.EventOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
                      Live.EventOddTypeSetting with (nolock) ON Live.EventOdd.OddsTypeId = Live.EventOddTypeSetting.OddTypeId and Live.EventOdd.MatchId=Live.EventOddTypeSetting.MatchId INNER JOIN
					  [BettingLive].Live.EventOddResult with (nolock) On [BettingLive].Live.EventOddResult.OddId=Live.EventOdd.OddId
                     
                    Where Live.EventOdd.MatchId=@EventId

 -- Order By  Live.[Parameter.OddType].OddTypeId
    
END


GO
