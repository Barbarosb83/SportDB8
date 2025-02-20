USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakTransactionAbort]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Casino].[ProcLuckyStreakTransactionAbort]
@OperatorId bigint,
@TransactionRequestId nvarchar(250),
@AbortedTransactionReguestId nvarchar(250),
@AbortTime Datetime,
@Direction nvarchar(50),
@Currency nvarchar(5),
@Amount money,
@UserName nvarchar(50)


AS


BEGIN
SET NOCOUNT ON;


declare @CurrencyId int
declare @LuckyStreakTransactionAbortId bigint
declare @CustomerId bigint

select @CurrencyId=Parameter.Currency.CurrencyId
from Parameter.Currency
where Parameter.Currency.Symbol3=@Currency

select @CustomerId=Customer.Customer.CustomerId
from Customer.Customer
where Customer.Customer.Username=@UserName

if not exists (select Casino.[LuckyStreak.TransactionAbort].LuckyStreakTransactionAbortId from Casino.[LuckyStreak.TransactionAbort] where Casino.[LuckyStreak.TransactionAbort].AbortTransactionRequestId=@AbortedTransactionReguestId and Casino.[LuckyStreak.TransactionAbort].CustomerId=@CustomerId)
begin

insert Casino.[LuckyStreak.TransactionAbort] (CustomerId,TransactionRequestId,AbortTransactionRequestId,AbortTime,CurrencyId,Amount,Direction)
values (@CustomerId,@TransactionRequestId,@AbortedTransactionReguestId,@AbortTime,@CurrencyId,@Amount,@Direction)
set @LuckyStreakTransactionAbortId=SCOPE_IDENTITY()



declare @TransactionTypeId int=41
declare @TypeId int=1
if(@Direction='Debit')
	begin
	set @TransactionTypeId=40
	set @TypeId=1
	end

exec [Job].[FuncCustomerBooking2] @CustomerId,@Amount,@TypeId,@TransactionTypeId,''




end


select Customer.Customer.Balance,
Parameter.Currency.Symbol3 as currency,
@LuckyStreakTransactionAbortId as refTransactionId
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.CustomerId=@CustomerId



END


GO
