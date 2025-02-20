USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcXprressCredit]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Casino].[ProcXprressCredit]
@CustomerId bigint,
@GameId bigint,
@TransactionId nvarchar(250),
@Amount money,
@Currency nvarchar(10),
@Round nvarchar(250)

AS


BEGIN
SET NOCOUNT ON;


declare @CurrencyId int
declare @OldBalance  money
declare @OldBonus money=0

select @OldBalance= Customer.Customer.Balance, @CurrencyId=Customer.Customer.CurrencyId
From Customer.Customer
where Customer.Customer.CustomerId=@CustomerId



set @Amount=dbo.FuncCurrencyConverter(@Amount ,3,@CurrencyId)
--select @CurrencyId=Parameter.Currency.CurrencyId from Parameter.Currency where Parameter.Currency.Symbol3=@Currency

declare @XprressTransactionId bigint

declare @TransactionTypeId int=42
declare @TypeId int=1

if exists (select Casino.[XprressGaming.Transaction].TransactionId from Casino.[XprressGaming.Transaction] where CustomerId=@CustomerId and RoundId=@Round and TransactionTypeId=43 )
begin
		if not exists (select Casino.[XprressGaming.Transaction].TransactionId from Casino.[XprressGaming.Transaction] where CustomerId=@CustomerId and RoundId=@Round and TransactionTypeId=42 )
			begin
						insert Casino.[XprressGaming.Transaction](
						GameId
						,CustomerId
						,Amount
						,CurrencyId
						,XprressTransId
						,CreateDate,
						RoundId,
						TransactionTypeId

						)
						values (
						@GameId
						,@CustomerId
						,@Amount
						,@CurrencyId
						,@TransactionId
						,GETDATE(),
						@Round
						,@TransactionTypeId
						)

						set @XprressTransactionId=SCOPE_IDENTITY()






						exec [Job].[FuncCustomerBooking2] @CustomerId,@Amount,@TypeId,@TransactionTypeId,@XprressTransactionId


						select dbo.FuncCurrencyConverter(Customer.Customer.Balance ,@CurrencyId,3) as Balance,cast(0 as money) Bonus,dbo.FuncCurrencyConverter(@OldBalance ,@CurrencyId,3) as OldBalance,@OldBonus as OldBonus,'EUR' as Currency
						From Customer.Customer INNER JOIN 
						Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
						where Customer.Customer.CustomerId=@CustomerId
				end
				else
					begin
						select cast(-118 as money) as Balance,cast(0 as money) Bonus,dbo.FuncCurrencyConverter(@OldBalance ,@CurrencyId,3) as OldBalance,@OldBonus as OldBonus,'EUR' as Currency
					From Customer.Customer INNER JOIN 
					Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
					where Customer.Customer.CustomerId=@CustomerId
					end

end
else
	begin
		select cast(-112 as money) as Balance,cast(0 as money) Bonus,dbo.FuncCurrencyConverter(@OldBalance ,@CurrencyId,3) as OldBalance,@OldBonus as OldBonus,'EUR' as Currency
					From Customer.Customer INNER JOIN 
					Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
					where Customer.Customer.CustomerId=@CustomerId
	end

END





GO
