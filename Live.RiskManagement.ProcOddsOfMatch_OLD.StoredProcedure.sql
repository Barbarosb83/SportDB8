USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcOddsOfMatch_OLD]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[RiskManagement.ProcOddsOfMatch_OLD]
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
						  , cast( (Select   Live.EventOddResult.OddResult from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=Live.EventOdd.OddId)  as bit ) as   OddResult
					  ,  (Select  Live.EventOddResult.VoidFactor from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=Live.EventOdd.OddId) as   VoidFactor, 
                      cast( (Select Live.EventOddResult.IsCanceled from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=Live.EventOdd.OddId) as bit) as  IsCanceled,
                    --  , Live.EventOdd.ForTheRest
                     -- , Live.EventOdd.Combination
                     -- , Live.EventOdd.Comment
                     -- , Live.EventOdd.MostBalanced, 
                      Live.EventOddTypeSetting.LossLimit, Live.EventOddTypeSetting.LimitPerTicket, Live.EventOddTypeSetting.StakeLimit, Live.EventOddTypeSetting.OddTypeSettingId as  OddSettingId, 
                      ISNULL((Select Live.EventOddResult.StateId from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=Live.EventOdd.OddId),2) as  StateId 
					  , Live.EventOddTypeSetting.AvailabilityId, Live.EventOdd.IsOddValueLock,   
                      cast( (Select Live.EventOddResult.IsEvaluated from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=Live.EventOdd.OddId)  as bit) as  IsEvaluated,
					  dbo.FuncCashFlow(Live.EventOdd.OddId,0,0,1) as Stake,
					  (select COUNT(Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.OddId=Live.EventOdd.OddId) as Bet
FROM         Live.EventOdd with (nolock) INNER JOIN
--Live.EventOddResult with (nolock) On Live.EventOddResult.OddId=Live.EventOdd.OddId INNER JOIN
                      Live.[Parameter.OddType] with (nolock) ON Live.EventOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
                      Live.EventOddTypeSetting with (nolock) ON Live.EventOdd.OddsTypeId = Live.EventOddTypeSetting.OddTypeId and Live.EventOdd.MatchId=Live.EventOddTypeSetting.MatchId
                     
                    Where Live.EventOdd.MatchId=@EventId

 -- Order By  Live.[Parameter.OddType].OddTypeId
    
END


GO
