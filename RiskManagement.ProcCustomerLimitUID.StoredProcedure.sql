USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerLimitUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerLimitUID]
@CustomerId bigint,
@CreditLimit money,
@LimitPerTicket money,
@MaxStakeGame money,
@MaxStakeFactor float,
@MaxStakeGamePercent float,
@LimitPerLiveTicket money,
@StakeDay money,
@StakeWeek money,
@StakeMonth money,
@MinCombiBranch int,
@MinCombiInternet int,
@MinCombiMachine int,
@StakeDailyLimit money,
@StakeWeeklyLimit money,
@StakeMonthlyLimit money,
@DepositDailyLimit money,
@DepositWeeklyLimit money,
@DepositMonthlyLimit money,
@LossDailyLimit money,
@LossWeeklyLimit money,
@LossMonthlyLimit money,
@PendingTime int,
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
	declare @CurrencyId  int
	declare @SystemCurrency int

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
	
	select @SystemCurrency=General.Setting.SystemCurrencyId from General.Setting

	select @CurrencyId = CurrencyId from Customer.Customer where CustomerId=@CustomerId

if @ActivityCode=1
	begin
		exec [Log].ProcConcatOldValues  'StakeLimit','Customer','CustomerId',@CustomerId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  20,@ActivityCode,@Username,@CustomerId,'Customer.StakeLimit'
	,@NewValues,@OldValues
	
	update Customer.StakeLimit set
	CreditLimit=@CreditLimit,
	LimitPerTicket=@LimitPerTicket,
	MaxStakeGame=@MaxStakeGame,
	MaxStakeFactor=@MaxStakeFactor,
	MaxStakeGamePercent=@MaxStakeGamePercent,
	LimitPerLiveTicket=@LimitPerLiveTicket,
	StakeDay=@StakeDailyLimit,
	StakeWeek=@StakeWeeklyLimit,
	StakeMonth=@StakeMonthlyLimit,
		LossDay=@LossDailyLimit,
	LossWeek=@LossWeeklyLimit,
	LossMonth=@LossMonthlyLimit,
			DepositDay=@DepositDailyLimit,
	DepositWeek=@DepositWeeklyLimit,
	DepositMonth=@DepositMonthlyLimit,
	MinCombiBranch=@MinCombiBranch,
	MinCombiInternet=@MinCombiInternet,
	MinCombiMachine=@MinCombiMachine,
	PendingTime=@PendingTime,
	UpdateDate=GETDATE(),
	UpdateUser=@username

	where CustomerId=@CustomerId
	

	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
