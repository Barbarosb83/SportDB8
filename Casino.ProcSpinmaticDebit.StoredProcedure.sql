USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcSpinmaticDebit]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcSpinmaticDebit]
@CustomerId bigint,
@GameId bigint,
@TransactionId nvarchar(250),
@Amount money,
@Currency nvarchar(10),
@Round nvarchar(50)

AS


BEGIN
SET NOCOUNT ON;

declare @CurrencyId int
declare @OldBalance  money
declare @OldBonus money=0


--select @CurrencyId=Parameter.Currency.CurrencyId from Parameter.Currency where Parameter.Currency.Symbol3=@Currency

select @OldBalance= Customer.Customer.Balance, @CurrencyId=Customer.Customer.CurrencyId
From Customer.Customer
where Customer.Customer.CustomerId=@CustomerId
if(@Amount is not null)
begin
set @Amount=dbo.FuncCurrencyConverter(@Amount ,3,@CurrencyId)

declare @SpinmaticTransactionId bigint

insert Casino.[Spinmatic.Transaction](
GameId
,CustomerId
,Amount
,CurrencyId
,[round]
,SpinmaticTransactionId
,CreateDate

)
values (
@GameId
,@CustomerId
,@Amount
,@CurrencyId
,@Round
,@TransactionId
,GETDATE()
)

set @SpinmaticTransactionId=SCOPE_IDENTITY()



declare @TransactionTypeId int=43
declare @TypeId int=0


exec [Job].[FuncCustomerBooking2] @CustomerId,@Amount,@TypeId,@TransactionTypeId,@SpinmaticTransactionId


end
select dbo.FuncCurrencyConverter(Customer.Customer.Balance ,@CurrencyId,3) as Balance,cast(0 as money) Bonus,dbo.FuncCurrencyConverter(@OldBalance ,@CurrencyId,3) as OldBalance,@OldBonus as OldBonus
From Customer.Customer INNER JOIN 
Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
where Customer.Customer.CustomerId=@CustomerId

END




GO
