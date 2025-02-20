USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBitcoinTransaction]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [GamePlatform].[ProcCustomerBitcoinTransaction] 
@CustomerId bigint,
@Amount money,
@ApproveCount int,
@BitcoinAddress nvarchar(150)
AS

BEGIN
SET NOCOUNT ON;

declare @result int=0
declare @CurrenyId int=71
declare @Balance money=0

 if(@ApproveCount<7)
 begin
	if(select Count(Customer.BitcoinTransaction2.BitcoinTransactionId) from Customer.BitcoinTransaction2 where CustomerId=@CustomerId and Amount=@Amount and InvoiceId=@BitcoinAddress and Status=@ApproveCount)=0
			begin
				insert Customer.BitcoinTransaction2 (CustomerId,Amount,CurrencyId,CreatedDate,InvoiceId,Status)
				values(@CustomerId,@Amount,71,GETDATE(),@BitcoinAddress,@ApproveCount)
			end
 end

if(@ApproveCount>=6)
	begin
		
		if(select Count(Customer.BitcoinTransaction.BitcoinTransactionId) from Customer.BitcoinTransaction where CustomerId=@CustomerId and Amount=@Amount and InvoiceId=@BitcoinAddress)=0
			begin
				insert Customer.BitcoinTransaction (CustomerId,Amount,CurrencyId,CreatedDate,InvoiceId,Status)
				values(@CustomerId,@Amount,71,GETDATE(),@BitcoinAddress,@ApproveCount)


				set @Amount=dbo.FuncCurrencyConverter(@Amount,25,@CurrenyId)

				insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment)
		values(@CustomerId,@Amount,@CurrenyId,GETDATE(),27,1,@BitcoinAddress)

		select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

		set @Balance=@Balance+@Amount

		update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId


			if exists (select Customer.Bitcoin.BitcoinAddress from Customer.Bitcoin where BitcoinAddress=@BitcoinAddress and CustomerId=@CustomerId)
						update Customer.Bitcoin set BitcoinAddress='' where CustomerId=@CustomerId


--------------------------------------------------------------- BONUS ---------------------------------------------------------------------------------------------------------------------------------------

			if(select COUNT(*) from Bonus.[Rule] where cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date)  and Bonus.[Rule].MinAmount<=@Amount and Bonus.[Rule].BonusTypeId=4 )>0
			BEGIN
				declare @BonusId int=0
				select top 1  @BonusId=Bonus.[Rule].BonusRuleId from Bonus.[Rule] where cast(Bonus.[Rule].BonusStartDate as date)<=CAST(GETDATE() as date) and CAST(Bonus.[Rule].BonusEndDate as date)>CAST(GETDATE() as date) and Bonus.[Rule].BonusTypeId=4
				
				if(select Count(Customer.Bonus.CustomerBonusId) From Customer.Bonus where Customer.Bonus.CustomerId=@CustomerId and Customer.Bonus.BonusId=@BonusId)=0
					begin
						declare @BonusAmount money
						declare @MaxBonusAmount money
						declare @BonusRate float
						select top 1 @MaxBonusAmount=Bonus.[Rule].MaxAmount,@BonusRate=Bonus.[Rule].BonusRate from Bonus.[Rule] where BonusRuleId=@BonusId
						if(@Amount>=@MaxBonusAmount)
							set @BonusAmount=(@MaxBonusAmount/100)*@BonusRate
						else
							set @BonusAmount=(@Amount/100)*@BonusRate


							insert Customer.Bonus (CustomerId,BonusId,CreateDate,BonusAmount) values (@CustomerId,@BonusId,GETDATE(),@BonusAmount)


						insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment)
						values(@CustomerId,@BonusAmount,@CurrenyId,GETDATE(),35,1,@BitcoinAddress)

						select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

						set @Balance=@Balance+@BonusAmount

						update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId


					end

			END

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


				set @result=1
			end
	

	end


return @result



END
GO
