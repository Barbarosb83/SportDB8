USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcXProGamingCredit]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Casino].[ProcXProGamingCredit]
@Username nvarchar(150),
@GameId bigint,
@RoundId bigint,
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
				if not exists (Select [Casino].[XProGaming.Transaction].[TransactionId] from [Casino].[XProGaming.Transaction] where [GameId]=@GameId and [RoundId]=@RoundId and CustomerId=@CustomerId and Amount=@Amount and TransactionTypeId=42 )
					begin
						if not exists (Select [Casino].[XProGaming.Transaction].[TransactionId] from [Casino].[XProGaming.Transaction] where [GameId]=@GameId and [RoundId]=@RoundId and CustomerId=@CustomerId and  TransactionTypeId=42  )
							begin
									set @Amount=dbo.FuncCurrencyConverter(@Amount ,3,@CurrencyId)
									--select @CurrencyId=Parameter.Currency.CurrencyId from Parameter.Currency where Parameter.Currency.Symbol3=@Currency
									
							insert dbo.spintest (CustomerID,GameId,TransId,Amount,Round,CreateDate)
				values (@CustomerId,cast(@GameId as nvarchar(250)),cast(-1 as nvarchar(250)),@Amount,cast(@RoundId as nvarchar(250)),GETDATE())


						 
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
											,-1
											,@Amount
											,@CurrencyId
											,GETDATE(),42
											)

											set @XProTransactionId=SCOPE_IDENTITY()



											declare @TransactionTypeId int=42
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

				--				insert dbo.spintest (CustomerID,GameId,TransId,Amount,Round,CreateDate)
				--values (@CustomerId,cast(@GameId as nvarchar(250)),cast(-21 as nvarchar(250)),@Amount,cast(@RoundId as nvarchar(250)),GETDATE())

								select cast(-22 as money) as Balance
									,cast(0 as money) Bonus
									,cast(-22 as money) as OldBalance
									,cast(0 as money)  as OldBonus,'EUR' as Currency

							end
					end
				else
					begin

				--		insert dbo.spintest (CustomerID,GameId,TransId,Amount,Round,CreateDate)
				--values (@CustomerId,cast(@GameId as nvarchar(250)),cast(-22 as nvarchar(250)),@Amount,cast(@RoundId as nvarchar(250)),GETDATE())

					select cast(-21 as money) as Balance
									,cast(0 as money) Bonus
									,cast(-21 as money) as OldBalance
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
