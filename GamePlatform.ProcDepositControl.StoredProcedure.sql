USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcDepositControl]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcDepositControl] 
@Id int,
@CustomerId bigint,
@TypeId int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;
declare @CustomerBalance money=0
declare @Reason nvarchar(250)=''
declare @Balance money
declare @CustomerDepositD money
declare @CustomerDepositW money
declare @CustomerDepositM money
declare @DepositMaxValue money=0
declare @WithDrawMaxValue money=0
declare @WithDrawMinValue money=0
declare @CustomerMaxValue money=0
select @CustomerDepositD=Customer.StakeLimit.DepositDay,@CustomerDepositW=Customer.StakeLimit.DepositWeek,
@CustomerDepositM=Customer.StakeLimit.DepositMonth from Customer.StakeLimit where CustomerId=@CustomerId



declare @Multiple int=0

--select @Multiple= [dbo].[MultipleAccount](@CustomerId)


if(@TypeId=1) --Deposit
select @DepositMaxValue=MaxValue from Parameter.PaymentType where TransactionTypeId=@Id and TypeId=1
else
begin
select @WithDrawMinValue=MinValue ,@WithDrawMaxValue=MaxValue from Parameter.PaymentType where TransactionTypeId=@Id and TypeId=2
set @Reason='Max witdraw limit:'+cast(@WithDrawMaxValue as nvarchar(20))
end
select @CustomerDepositD=@CustomerDepositD-ISNULL(SUM(DepositAmount),0) from Customer.DepositTransfer where CustomerId=@CustomerId and cast(TransferDateTime as date)=cast(GETDATE() as date) and DepositStatuId=2

if not exists ((Select Customer.PEPControl.CustomerId from Customer.PEPControl where IsDoc=1) ) OR (Select count(Customer.Document.CustomerId) from Customer.Document where CustomerId=@CustomerId)=0
	begin
		set @CustomerMaxValue=2000
		set @WithDrawMaxValue=0
		set @WithDrawMinValue=0

		select @Reason=ErrorCode from Log.ErrorCodes where ErrorCodeId=175 and LangId=@LangId
	end
else
	begin
		set @CustomerMaxValue=2000
		if exists (select Customer.PEPControl.CustomerId from Customer.PEPControl where CustomerId=@CustomerId and (IsPep=0 or IsPep is null))
			set @CustomerMaxValue=5000
		else
			begin
			set @CustomerMaxValue=2000
			set @WithDrawMaxValue=0
			set @WithDrawMinValue=0
			set @Reason='Pep control'
			end
		if exists (select Customer.PEPControl.CustomerId from Customer.PEPControl where CustomerId=@CustomerId and IsSanction=0)
			begin
			set @CustomerMaxValue=0
			set @Reason='Is Sanction'
			end
	
	end
		if @Multiple=1
			begin
				set @CustomerMaxValue=0
				set @Reason='Multiple account'
			end
	if(@CustomerMaxValue<@DepositMaxValue)
		set @DepositMaxValue=@CustomerMaxValue


	if(@CustomerDepositD<0)
	begin
	set @CustomerDepositD=0
	set @Reason='Günlük para  yükleme limitiniz dolmuştur.'
	end

	if (@CustomerDepositD<@DepositMaxValue)
		begin
			set @DepositMaxValue=@CustomerDepositD
			set @Reason='Daily limit: '+cast(@CustomerDepositD as nvarchar(20))
		end

		


if(@TypeId=1) --Deposit
select IsActive,MinValue,  @DepositMaxValue   as MaxValue,@Reason as Reason from Parameter.PaymentType where TransactionTypeId=@Id and TypeId=1
else
select IsActive,case when @WithDrawMinValue<MinValue then @WithDrawMinValue else MinValue end as MinValue,case when @WithDrawMaxValue<MaxValue then @WithDrawMaxValue else MaxValue end as MaxValue,@Reason as Reason from Parameter.PaymentType where TransactionTypeId=@Id and TypeId=2
 

END



GO
