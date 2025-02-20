USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcRealGamingAmaticCustomerGetBalance]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcRealGamingAmaticCustomerGetBalance]
@UserName nvarchar(50),
@GameCurrencyId int


AS


BEGIN
SET NOCOUNT ON;


declare @LuckyStreakTransactionId bigint
declare @CustomerId bigint
declare @CurrencyParity money=40000


select @CustomerId=Customer.Customer.CustomerId
from Customer.Customer
where Customer.Customer.Username=@UserName


--insert Casino.[LuckyStreak.Transaction] (CustomerId,TransactionRequestId,EventType,EventSubType,EventId,Direction,CurrencyId,Amount)
--values (@CustomerId,@TransactionRequestId,@EventType,@EventSubType,@EventId,@Direction,@CurrencyId,@Amount)
--set @LuckyStreakTransactionId=SCOPE_IDENTITY()

select cast((Customer.Customer.Balance/@CurrencyParity) as decimal(18,0)) as Balance,
'36' as currency
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId INNER JOIN
[Casino].[RealGaming.ParameterCurrency] ON [Casino].[RealGaming.ParameterCurrency].[ParameterCurrencyId]=Parameter.Currency.CurrencyId
where Customer.Customer.CustomerId=@CustomerId



END


GO
