USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcSlipSystemCreate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [BetAcceptance].[ProcSlipSystemCreate] 
@CustomerId bigint,
@TotalOddValue float,
@Amount money,
@SlipStateId int,
--@SlipTypeId int,
@SourceId int,
@SlipStatu int,
@EventCount int,
@System nvarchar(150),
@MaxGain money


AS

declare @SystemSlipId bigint=0
declare @CurrencyId int
declare @Balance money=0
declare @BonusAmount money
declare @BonusId int
declare @DepositAmount money
declare @IsBranchCustomer bit
declare @BranchId int
declare @IsTerminalCustomer bit
declare @Tax float=0
declare @CountryId int=0




 

select @CurrencyId=Customer.Customer.CurrencyId,@Balance=Customer.Balance,@IsBranchCustomer=IsBranchCustomer,@BranchId=BranchId,@IsTerminalCustomer=IsTerminalCustomer,@CountryId=CountryId 
from Customer.Customer with (nolock) where Customer.CustomerId=@CustomerId

 if exists (select  Parameter.TaxCountry.CountryTaxId from Parameter.TaxCountry with (nolock) where Parameter.TaxCountry .CountryId=@CountryId)
	if(@BranchId<>32643)
	select @Tax =Parameter.TaxCountry.Tax from Parameter.TaxCountry  with (nolock) where Parameter.TaxCountry.CountryId=@CountryId



if(@IsBranchCustomer=1 )
	select @Balance=Balance from Parameter.Branch with (nolock) where Parameter.Branch.BranchId=@BranchId

INSERT INTO [Customer].[SlipSystem]
           ([CustomerId]
           ,MaxGain
		   ,[TotalOddValue]
           ,[Amount]
           ,[SlipStateId]
           ,[CreateDate]
           ,[GroupId]
           ,[SlipTypeId]
           ,[SourceId]
           ,[SlipStatuId]
           ,[CurrencyId]
           ,[EventCount]
           ,[System],CouponCount,NewSlipTypeId,MaxGain2)
     VALUES(
	 @CustomerId
	 ,@MaxGain
	 ,@TotalOddValue
	,@Amount
	,@SlipStateId
	,GETDATE()
	,0
	,3
	,@SourceId
	,1
	,@CurrencyId
	,@EventCount
	,@System,@SlipStatu,3,@MaxGain)




					set @SystemSlipId=SCOPE_IDENTITY()

					insert Customer.[Transaction](CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
					values(@CustomerId,@Amount,@CurrencyId,GETDATE(),4,1,CAST(@TotalOddValue as nvarchar(100))+'-'+CAST(@SystemSlipId as nvarchar(20)),@Balance-@Amount)

					if(@IsBranchCustomer=0)
						update Customer.Customer set Balance=@Balance-@Amount where Customer.CustomerId=@CustomerId
					else
						update Parameter.Branch set Balance=@Balance-@Amount where Parameter.Branch.BranchId=@BranchId

						set @Balance=@Balance-@Amount

					if (@Tax>0 and @Tax is not null)
					begin
							declare @TotalAmount money
							declare @TaxAmount money = (@Amount*@Tax)/100
							 

							set @TotalAmount=@Amount+@TaxAmount
							 insert Customer.Tax ([CustomerId],[SlipId],[TotalAmount],[SlipAmount],[TaxAmount],[CurrencyId],[TransactionTypeId],[TaxStatusId],SourceId,CreateDate,SlipTypeId)
								 values (
								 @CustomerId
								 ,@SystemSlipId
								 ,@TotalAmount
								 ,@Amount
								 ,@TaxAmount
								 ,@CurrencyId
								 ,53
								 ,1
								 ,1
								 ,GETDATE()
								 ,3
								 )

								if(@IsBranchCustomer=0)
								begin
 
								update Customer.Customer set Balance=Balance-@TaxAmount where CustomerId=@CustomerId
								end
								else
								begin

								update Parameter.Branch set Balance=Balance-@TaxAmount where Parameter.Branch.BranchId=@BranchId
								end

								insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
								values(@CustomerId,@TaxAmount,@CurrencyId,GETDATE(),53,1,cast(@SystemSlipId as nvarchar(20)),@Balance-@TaxAmount)

					end



return @SystemSlipId


GO
