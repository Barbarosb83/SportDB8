USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerSelfLimit]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerSelfLimit] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;


SELECT     Customer.Limit.CustomerLimitId, Customer.Limit.CustomerId, Customer.Limit.StakeDailyLimit, Customer.Limit.StakeDailyLimitConsumed, 
                      Customer.Limit.StakeWeeklyLimit, Customer.Limit.StakeWeeklyLimitConsumed, Customer.Limit.StakeMonthlyLimit, Customer.Limit.StakeMonthlyLimitConsumed, 
                      Customer.Limit.DepositDailyLimit, Customer.Limit.DepositDailyLimitConsumed, Customer.Limit.DepositWeeklyLimit, Customer.Limit.DepositWeeklyLimitConsumed, 
                      Customer.Limit.DepositMonthlyLimit, Customer.Limit.DepositMonthlyLimitConsumed, Customer.Limit.LossDailyLimit, Customer.Limit.LossDailyLimitConsumed, 
                      Customer.Limit.LossWeeklyLimit, Customer.Limit.LossWeeklyLimitConsumed, Customer.Limit.LossMonthlyLimit, Customer.Limit.LossMonthlyLimitConsumed, 
                      Customer.Limit.StakeDailyDate, Customer.Limit.StakeWeeklyDate, Customer.Limit.StakeMonthlyDate, Customer.Limit.DepositDailyDate, 
                      Customer.Limit.DepositWeeklyDate, Customer.Limit.DepositMounthlyDate, Customer.Limit.LossDailyDate, Customer.Limit.LossWeeklyDate, 
                      Customer.Limit.LossMounthlyDate, Parameter.Currency.Sybol, Parameter.Currency.Currency
FROM         Customer.Limit INNER JOIN
                      Customer.Customer ON Customer.Limit.CustomerId = Customer.Customer.CustomerId INNER JOIN
                      Parameter.Currency ON Customer.Customer.CurrencyId = Parameter.Currency.CurrencyId
WHERE     (Customer.Limit.CustomerId = @CustomerId)

END


GO
