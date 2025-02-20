USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakTransaction]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Casino].[ProcLuckyStreakTransaction]
@OperatorId bigint,
@TransactionRequestId nvarchar(250),
@EventType nvarchar(250),
@EventSubType nvarchar(250),
@EventId nvarchar(250),
@Direction nvarchar(50),
@Currency nvarchar(5),
@Amount money,
@UserName nvarchar(50)


AS
BEGIN TRANSACTION;

BEGIN
SET NOCOUNT ON;


declare @CurrencyId int
declare @LuckyStreakTransactionId bigint
declare @CustomerId bigint

select @CurrencyId=Parameter.Currency.CurrencyId
from Parameter.Currency
where Parameter.Currency.Symbol3=@Currency

select @CustomerId=Customer.Customer.CustomerId
from Customer.Customer
where Customer.Customer.Username=@UserName

if not exists (select Casino.[LuckyStreak.Transaction].LuckyStreakTransactionId from Casino.[LuckyStreak.Transaction] where Casino.[LuckyStreak.Transaction].TransactionRequestId=@TransactionRequestId and Casino.[LuckyStreak.Transaction].CustomerId=@CustomerId)
begin

insert Casino.[LuckyStreak.Transaction] (CustomerId,TransactionRequestId,EventType,EventSubType,EventId,Direction,CurrencyId,Amount,CreateDate)
values (@CustomerId,@TransactionRequestId,@EventType,@EventSubType,@EventId,@Direction,@CurrencyId,@Amount,GETDATE())
set @LuckyStreakTransactionId=SCOPE_IDENTITY()

declare @TransactionTypeId int=38
declare @TypeId int=1
if(@Direction='Debit')
	begin
	set @TransactionTypeId=39
	set @TypeId=0
	end

exec [Job].[FuncCustomerBooking2] @CustomerId,@Amount,@TypeId,@TransactionTypeId,''


end

select Customer.Customer.Balance,
Parameter.Currency.Symbol3 as currency,
@LuckyStreakTransactionId as refTransactionId
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.CustomerId=@CustomerId



END

COMMIT TRANSACTION;


GO
