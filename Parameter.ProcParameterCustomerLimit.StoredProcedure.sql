USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Parameter].[ProcParameterCustomerLimit]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Parameter].[ProcParameterCustomerLimit]



AS




BEGIN
SET NOCOUNT ON;


SELECT Parameter.CustomerLimit.ParameterLimitId,
Parameter.CustomerLimit.CreditLimit, 
Parameter.CustomerLimit.LimitPerTicket,
Parameter.CustomerLimit.MaxStakeGame, 
Parameter.CustomerLimit.MaxStakeFactor, 
Parameter.CustomerLimit.MaxStakeGamePercent,
Parameter.CustomerLimit.LimitPerLiveTicket,
Parameter.CustomerLimit.StakeDay,
Parameter.CustomerLimit.StakeWeek, 
Parameter.CustomerLimit.StakeMonth,
Parameter.CustomerLimit.StakeDailyLimit, 
Parameter.CustomerLimit.StakeWeeklyLimit, 
Parameter.CustomerLimit.StakeMonthlyLimit, 
Parameter.CustomerLimit.DepositDailyLimit, 
Parameter.CustomerLimit.DepositWeeklyLimit, 
Parameter.CustomerLimit.DepositMonthlyLimit, 
Parameter.CustomerLimit.LossDailyLimit, 
Parameter.CustomerLimit.LossWeeklyLimit, 
Parameter.CustomerLimit.LossMonthlyLimit, 
Parameter.CustomerLimit.MinCombiBranch, 
Parameter.CustomerLimit.MinCombiInternet, 
Parameter.CustomerLimit.MinCombiMachine,
[LimitPerVirtualTicket]
FROM         Parameter.CustomerLimit 

END


GO
