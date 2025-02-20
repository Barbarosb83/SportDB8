USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[RiskManagement.ProcOddsOfMatch]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[RiskManagement.ProcOddsOfMatch]
	@EventId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT     Virtual.EventOdd.OddId, Virtual.[Parameter.OddType].OddTypeId, Virtual.[Parameter.OddType].OddType, Virtual.EventOdd.OutCome, Virtual.EventOdd.SpecialBetValue, 
                      Virtual.EventOdd.OddValue, Virtual.EventOdd.Suggestion,Virtual.EventOdd.OddFactor, Virtual.EventOdd.IsChanged, Virtual.EventOdd.IsActive, Virtual.EventOdd.OddResult, Virtual.EventOdd.VoidFactor, 
                      Virtual.EventOdd.IsCanceled, Virtual.EventOdd.ForTheRest, Virtual.EventOdd.Combination, Virtual.EventOdd.Comment, Virtual.EventOdd.MostBalanced, 
                      Virtual.EventOddSetting.LossLimit, Virtual.EventOddSetting.LimitPerTicket, Virtual.EventOddSetting.StakeLimit, Virtual.EventOddSetting.OddSettingId, 
                      Virtual.EventOddSetting.StateId, Virtual.EventOddSetting.AvailabilityId, Virtual.EventOdd.IsOddValueLock,   
                      Virtual.EventOdd.IsEvaluated,
					  0 as Stake,
					  0 as Bet
FROM         Virtual.EventOdd INNER JOIN
                      Virtual.[Parameter.OddType] ON Virtual.EventOdd.OddsTypeId = Virtual.[Parameter.OddType].OddTypeId INNER JOIN
                      Virtual.EventOddSetting ON Virtual.EventOdd.OddId = Virtual.EventOddSetting.OddId
                     
                    Where Virtual.EventOdd.MatchId=@EventId

  Order By  Virtual.[Parameter.OddType].OddTypeId
    
END


GO
