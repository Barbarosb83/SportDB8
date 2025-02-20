USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcSlipSystemCreateTemp]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [BetAcceptance].[ProcSlipSystemCreateTemp] 
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
	select @Tax =Parameter.TaxCountry.Tax from Parameter.TaxCountry  with (nolock) where Parameter.TaxCountry.CountryId=@CountryId



if(@IsBranchCustomer=1 )
	select @Balance=Balance from Parameter.Branch with (nolock) where Parameter.Branch.BranchId=@BranchId

INSERT INTO [Customer].[SlipSystemTemp]
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
           ,[System],CouponCount,NewSlipTypeId)
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
	,@System,@SlipStatu,3)




					set @SystemSlipId=SCOPE_IDENTITY()

					



return @SystemSlipId


GO
