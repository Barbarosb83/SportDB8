USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakCustomerGetBalance]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Casino].[ProcLuckyStreakCustomerGetBalance]
@UserName nvarchar(50)


AS


BEGIN
SET NOCOUNT ON;


declare @CurrencyId int
declare @LuckyStreakTransactionId bigint
declare @CustomerId bigint



select @CustomerId=Customer.Customer.CustomerId
from Customer.Customer
where Customer.Customer.Username=@UserName


--insert Casino.[LuckyStreak.Transaction] (CustomerId,TransactionRequestId,EventType,EventSubType,EventId,Direction,CurrencyId,Amount)
--values (@CustomerId,@TransactionRequestId,@EventType,@EventSubType,@EventId,@Direction,@CurrencyId,@Amount)
--set @LuckyStreakTransactionId=SCOPE_IDENTITY()

select Customer.Customer.Balance,
Parameter.Currency.Symbol3 as currency
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.CustomerId=@CustomerId



END


GO
