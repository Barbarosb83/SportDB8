USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcXProGamingCancel]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Casino].[ProcXProGamingCancel]
@Username nvarchar(150),
@GameId bigint,
@RoundId bigint,
@Sequence int,
@Amount money,
@Currency nvarchar(10)

AS


BEGIN
SET NOCOUNT ON;

declare @CurrencyId int
declare @OldBalance  money
declare @OldBonus money=0
declare @CustomerId bigint

set @Currency='EUR'

if exists (select Customer.Customer.CustomerId from Customer.Customer with (nolock) where Customer.Customer.Username=@Username)
begin
				select @OldBalance= Customer.Customer.Balance, @CurrencyId=Customer.Customer.CurrencyId,@CustomerId=Customer.Customer.CustomerId
				From Customer.Customer
				where Customer.Customer.Username=@Username
				if not exists (Select [Casino].[XProGaming.Transaction].[TransactionId] from [Casino].[XProGaming.Transaction] where [GameId]=@GameId and [RoundId]=@RoundId and [Sequence]=@Sequence and CustomerId=@CustomerId and TransactionTypeId=40)
				begin
				if exists (Select [Casino].[XProGaming.Transaction].[TransactionId] from [Casino].[XProGaming.Transaction] where [GameId]=@GameId and [RoundId]=@RoundId and [Sequence]=@Sequence and CustomerId=@CustomerId)
					begin
							select @Amount =[Casino].[XProGaming.Transaction].[Amount] from [Casino].[XProGaming.Transaction] where [GameId]=@GameId and [RoundId]=@RoundId and [Sequence]=@Sequence
							--select @CurrencyId=Parameter.Currency.CurrencyId from Parameter.Currency where Parameter.Currency.Symbol3=@Currency

							 
									declare @XProTransactionId bigint

									INSERT INTO [Casino].[XProGaming.Transaction]
										   ([CustomerId]
										   ,[GameId]
										   ,[RoundId]
										   ,[Sequence]
										   ,[Amount]
										   ,[CurrencyId]
										   ,[CreateDate],TransactionTypeId)
									 VALUES(
									 @CustomerId
									,@GameId
									,@RoundId
									,@Sequence
									,@Amount
									,@CurrencyId
									,GETDATE(),
									40
									)

									set @XProTransactionId=SCOPE_IDENTITY()



									declare @TransactionTypeId int=40
									declare @TypeId int=1


									exec [Job].[FuncCustomerBooking2] @CustomerId,@Amount,@TypeId,@TransactionTypeId,@XProTransactionId


									select dbo.FuncCurrencyConverter(Customer.Customer.Balance ,@CurrencyId,3) as Balance
									,cast(0 as money) Bonus
									,dbo.FuncCurrencyConverter(@OldBalance ,@CurrencyId,3) as OldBalance
									,@OldBonus as OldBonus,'EUR' as Currency
									From Customer.Customer INNER JOIN 
									Parameter.Currency ON Parameter.Currency.CurrencyId=Customer.CurrencyId
									where Customer.Customer.CustomerId=@CustomerId
								 
							 
					end
				else
					begin
						select cast(-30 as money) as Balance
							,cast(0 as money) Bonus
							,cast(-30 as money) as OldBalance
							,cast(0 as money)  as OldBonus,'EUR' as Currency

					end
				end
				else
					begin
							select cast(-30 as money) as Balance
							,cast(0 as money) Bonus
							,cast(-30 as money) as OldBalance
							,cast(0 as money)  as OldBonus,'EUR' as Currency
					end
end
else
	begin
		select cast(-10 as money) as Balance
		,cast(0 as money) Bonus
		,cast(-10 as money) as OldBalance
		,cast(0 as money)  as OldBonus,'EUR' as Currency
	 
	end


END





GO
