USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcOddsOfSingleMatch]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Live].[RiskManagement.ProcOddsOfSingleMatch]
	@EventId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT     Live.EventOdd.OddId, Live.[Parameter.OddType].OddTypeId, Live.[Parameter.OddType].OddType, Live.EventOdd.OutCome, case when Live.EventOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
  then CAST( cast(Live.EventOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
  else case when Live.EventOdd.SpecialBetValue<>'-1' then  ISNULL(Live.EventOdd.SpecialBetValue,'') else '' end end as SpecialBetValue, 
                      Live.EventOdd.OddValue
					  , Live.EventOdd.Suggestion
					   ,(Select  [BettingLive].Live.EventOddResult.OddFactor from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.EventOdd.OddId) as OddFactor
					  , Live.EventOdd.IsChanged, Live.EventOdd.IsActive
					  , cast( (Select   [BettingLive].Live.EventOddResult.OddResult from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.EventOdd.OddId)  as bit ) as   OddResult
					  ,  (Select  [BettingLive].Live.EventOddResult.VoidFactor from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.EventOdd.OddId) as   VoidFactor, 
                      cast( (Select [BettingLive].Live.EventOddResult.IsCanceled from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.EventOdd.OddId) as bit) as  IsCanceled,
                      Live.EventOddTypeSetting.LossLimit, Live.EventOddTypeSetting.LimitPerTicket, Live.EventOddTypeSetting.StakeLimit, Live.EventOddTypeSetting.OddTypeSettingId as OddSettingId, 
                      ISNULL((Select [BettingLive].Live.EventOddResult.StateId from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.EventOdd.OddId),2) as  StateId 
					  , Live.EventOddTypeSetting.AvailabilityId, Live.EventOdd.IsOddValueLock,   
                       cast( (Select [BettingLive].Live.EventOddResult.IsEvaluated from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.EventOdd.OddId)  as bit) as  IsEvaluated,
					   dbo.FuncCashFlow(Live.EventOdd.OddId,0,0,1) as Stake,
					  (select COUNT(Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.OddId=Live.EventOdd.OddId) as Bet,
					  TypeTable.OddTypeCount,					  
                      row_number() over (partition by Live.[Parameter.OddType].OddTypeId order by Live.[Parameter.OddType].OddTypeId) as RowNumber
FROM         Live.EventOdd with (nolock) INNER JOIN 
                      Live.[Parameter.OddType] with (nolock) ON Live.EventOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId INNER JOIN
                      Live.EventOddTypeSetting with (nolock) ON Live.EventOdd.OddsTypeId = Live.EventOddTypeSetting.OddTypeId and Live.EventOdd.MatchId = Live.EventOddTypeSetting.MatchId   inner join 
                      (Select Live.[Parameter.OddType].OddTypeId as ExOddTypeId, count(Live.[Parameter.OddType].OddTypeId) as OddTypeCount
								FROM         Live.EventOdd with (nolock) INNER JOIN
											 Live.[Parameter.OddType] with (nolock) ON Live.EventOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId 
											 Where Live.EventOdd.MatchId=@EventId
											 group by Live.[Parameter.OddType].OddTypeId) 
						as TypeTable on Live.EventOdd.OddsTypeId = TypeTable.ExOddTypeId                     
                    Where Live.EventOdd.MatchId=@EventId

  Order By  Live.[Parameter.OddType].OddTypeId
    
END


GO
