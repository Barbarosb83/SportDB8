USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerLimit]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerLimit]
@CustomerId bigint


AS




BEGIN
SET NOCOUNT ON;


SELECT
Customer.StakeLimit.CustomerId, 
Customer.StakeLimit.CreditLimit, 
Customer.StakeLimit.LimitPerTicket,
Customer.StakeLimit.MaxStakeGame, 
Customer.StakeLimit.MaxStakeFactor, 
Customer.StakeLimit.MaxStakeGamePercent,
Customer.StakeLimit.LimitPerLiveTicket,
Customer.StakeLimit.StakeDay,
Customer.StakeLimit.StakeWeek, 
Customer.StakeLimit.StakeMonth,
Customer.Limit.StakeDailyLimit, 
Customer.Limit.StakeWeeklyLimit, 
Customer.Limit.StakeMonthlyLimit, 
Customer.StakeLimit.DepositDay as DepositDailyLimit, 
Customer.StakeLimit.DepositWeek as DepositWeeklyLimit, 
Customer.StakeLimit.DepositMonth as DepositMonthlyLimit, 
Customer.StakeLimit.LossDay as LossDailyLimit, 
Customer.StakeLimit.LossWeek as LossWeeklyLimit, 
Customer.StakeLimit.LossMonth as LossMonthlyLimit, 
Customer.StakeLimit.MinCombiBranch, 
Customer.StakeLimit.MinCombiInternet, 
Customer.StakeLimit.MinCombiMachine,
Customer.StakeLimit.PendingTime,
Customer.StakeLimit.UpdateDate,
Customer.StakeLimit.UpdateUser
FROM         Customer.Limit INNER JOIN
                      Customer.StakeLimit ON Customer.Limit.CustomerId = Customer.StakeLimit.CustomerId
Where Customer.StakeLimit.CustomerId=@CustomerId                      

END


GO
