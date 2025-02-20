USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerSelfLimitUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerSelfLimitUID]
@CustomerLimitId bigint,
@StakeDailyLimit money,
@StakeWeeklyLimit money,
@StakeMonthlyLimit money,
@DepositDailyLimit money,
@DepositWeeklyLimit money,
@DepositMonthlyLimit money,
@LossDailyLimit money,
@LossWeeklyLimit money,
@LossMonthlyLimit money,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS




BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @SystemCurrency int
declare @ParamStakeDailyLimit money
declare @ParamStakeWeeklyLimit money
declare @ParamStakeMonthlyLimit money


declare @ParamDepositDailyLimit money
declare @ParamDepositWeeklyLimit money
declare @ParamDepositMonthlyLimit money

declare @ParamLossDailyLimit money
declare @ParamLossWeeklyLimit money
declare @ParamLossMonthlyLimit money

declare @NowStakeDailyLimit money
declare @NowStakeWeeklyLimit money
declare @NowStakeMonthlyLimit money

declare @NowDepositDailyLimit money
declare @NowDepositWeeklyLimit money
declare @NowDepositMonthlyLimit money

declare @NowLossDailyLimit money
declare @NowLossWeeklyLimit money
declare @NowLossMonthlyLimit money

declare @CurrencyId int
declare @CustomerId bigint


select @CustomerId= Customer.Customer.CustomerId,@CurrencyId=Customer.Customer.CurrencyId 
from Customer.Limit INNER JOIN Customer.Customer On Customer.Customer.CustomerId=Customer.Limit.CustomerId 
where Customer.Limit.CustomerLimitId=@CustomerLimitId

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
 


	--Sistemin verdiğinden yüksek olmamalı
	select @ParamStakeDailyLimit= StakeDailyLimit
	,@ParamStakeWeeklyLimit= StakeWeeklyLimit
	,@ParamStakeMonthlyLimit= StakeMonthlyLimit

	,@ParamDepositDailyLimit=DepositDailyLimit
	,@ParamDepositWeeklyLimit=DepositWeeklyLimit
	,@ParamDepositMonthlyLimit=DepositMonthlyLimit

	,@ParamLossDailyLimit=LossDailyLimit
	,@ParamLossWeeklyLimit=LossWeeklyLimit
	,@ParamLossMonthlyLimit=LossMonthlyLimit
	,@NowStakeDailyLimit= StakeDailyLimitConsumed
	,@NowStakeWeeklyLimit= StakeWeeklyLimitConsumed
	,@NowStakeMonthlyLimit= StakeMonthlyLimitConsumed 

	,@NowDepositDailyLimit= DepositDailyLimitConsumed
	,@NowDepositWeeklyLimit=DepositWeeklyLimitConsumed
	,@NowDepositMonthlyLimit=DepositMonthlyLimitConsumed

		,@NowLossDailyLimit=LossDailyLimitConsumed
	,@NowLossWeeklyLimit=LossWeeklyLimitConsumed
	,@NowLossMonthlyLimit=LossMonthlyLimitConsumed

	from Customer.Limit where Customer.Limit.CustomerLimitId=@CustomerLimitId


	--				select @NowStakeDailyLimit= StakeDay
	--,@NowStakeWeeklyLimit= StakeWeek
	--,@NowStakeMonthlyLimit= StakeMonth 

	--,@NowDepositDailyLimit= DepositDay
	--,@NowDepositWeeklyLimit=[DepositWeek]
	--,@NowDepositMonthlyLimit=[DepositMonth]

	--	,@NowLossDailyLimit=[LossDay]
	--,@NowLossWeeklyLimit=[LossWeek]
	--,@NowLossMonthlyLimit=[LossMonth]
	
	
	
	--from Customer.StakeLimit where CustomerId=@CustomerId

	if(@ParamStakeDailyLimit<@StakeDailyLimit)
		set @StakeDailyLimit=@ParamStakeDailyLimit

	if(@ParamStakeWeeklyLimit<@StakeWeeklyLimit)
		set @StakeWeeklyLimit=@ParamStakeWeeklyLimit

	if(@ParamStakeMonthlyLimit<@StakeMonthlyLimit)
		set @StakeMonthlyLimit=@ParamStakeMonthlyLimit

	if(@ParamDepositDailyLimit<@DepositDailyLimit)
		set @DepositDailyLimit=@ParamDepositDailyLimit

	if(@ParamDepositWeeklyLimit<@DepositWeeklyLimit)
		set @DepositWeeklyLimit=@ParamDepositWeeklyLimit

	if(@ParamDepositMonthlyLimit<@DepositMonthlyLimit)
		set @DepositMonthlyLimit=@ParamDepositMonthlyLimit

		if(@ParamLossDailyLimit<@LossDailyLimit)
		set @LossDailyLimit=@ParamLossDailyLimit

	if(@ParamLossWeeklyLimit<@LossWeeklyLimit)
		set @LossWeeklyLimit=@ParamLossWeeklyLimit

	if(@ParamLossMonthlyLimit<@LossMonthlyLimit)
		set @LossMonthlyLimit=@ParamLossMonthlyLimit





if @ActivityCode=1
	begin
		exec [Log].ProcConcatOldValues  'Limit','Customer','CustomerLimitId',@CustomerLimitId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  19,@ActivityCode,@Username,@CustomerLimitId,'Customer.Limit'
	,@NewValues,@OldValues
	
	update Customer.Limit set
	StakeDailyLimitConsumed=@StakeDailyLimit,
	StakeWeeklyLimitConsumed=@StakeWeeklyLimit,
	StakeMonthlyLimitConsumed=@StakeMonthlyLimit,
	DepositDailyLimitConsumed=@DepositDailyLimit,
	DepositWeeklyLimitConsumed=@DepositWeeklyLimit,
	DepositMonthlyLimitConsumed=@DepositMonthlyLimit,
	LossDailyLimitConsumed=@LossDailyLimit,
	LossWeeklyLimitConsumed=@LossWeeklyLimit,
	LossMonthlyLimitConsumed=@LossMonthlyLimit
	,UpdateDate=GETDATE()
	where CustomerLimitId=@CustomerLimitId
	
	if(@NowStakeDailyLimit>@StakeDailyLimit)
		update Customer.StakeLimit set 
							StakeDay=@StakeDailyLimit,UpdateUser=@username,UpdateDate=GETDATE()
							where CustomerId=@CustomerId

	if(@NowStakeWeeklyLimit>@StakeWeeklyLimit)
		update Customer.StakeLimit set 
							StakeWeek=@StakeWeeklyLimit,UpdateUser=@username,UpdateDate=GETDATE()
							where CustomerId=@CustomerId

		if(@NowStakeMonthlyLimit>@StakeMonthlyLimit)
		update Customer.StakeLimit set 
							StakeMonth=@StakeMonthlyLimit,UpdateUser=@username,UpdateDate=GETDATE()
							where CustomerId=@CustomerId


		if(@NowDepositDailyLimit>@DepositDailyLimit)
		update Customer.StakeLimit set 
							DepositDay=@DepositDailyLimit,UpdateUser=@username,UpdateDate=GETDATE()
							where CustomerId=@CustomerId

	if(@NowDepositWeeklyLimit>@DepositWeeklyLimit)
		update Customer.StakeLimit set 
							DepositWeek=@DepositWeeklyLimit,UpdateUser=@username,UpdateDate=GETDATE()
							where CustomerId=@CustomerId

		if(@NowDepositMonthlyLimit>@DepositMonthlyLimit)
		update Customer.StakeLimit set 
							DepositMonth=@DepositMonthlyLimit,UpdateUser=@username,UpdateDate=GETDATE()
							where CustomerId=@CustomerId

	if(@NowLossDailyLimit>@LossDailyLimit)
		update Customer.StakeLimit set 
							LossDay=@LossDailyLimit,UpdateUser=@username,UpdateDate=GETDATE()
							where CustomerId=@CustomerId

	if(@NowLossWeeklyLimit>@LossWeeklyLimit)
		update Customer.StakeLimit set 
							LossWeek=@LossWeeklyLimit,UpdateUser=@username,UpdateDate=GETDATE()
							where CustomerId=@CustomerId

		if(@NowLossMonthlyLimit>@LossMonthlyLimit)
		update Customer.StakeLimit set 
							LossMonth=@LossMonthlyLimit,UpdateUser=@username,UpdateDate=GETDATE()
							where CustomerId=@CustomerId




	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end



	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
