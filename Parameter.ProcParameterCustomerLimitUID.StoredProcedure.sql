USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Parameter].[ProcParameterCustomerLimitUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Parameter].[ProcParameterCustomerLimitUID]
@ParameterLimitId int,
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
@LimitPerVirtualTicket money,
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

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


if @ActivityCode=1
	begin
		exec [Log].ProcConcatOldValues  'CustomerLimit','Parameter','ParameterLimitId',@ParameterLimitId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  21,@ActivityCode,@Username,@ParameterLimitId,'Parameter.CustomerLimit'
	,@NewValues,@OldValues
	
	update Parameter.CustomerLimit set
	CreditLimit=@CreditLimit,
	LimitPerTicket=@LimitPerTicket,
	MaxStakeGame=@MaxStakeGame,
	MaxStakeFactor=@MaxStakeFactor,
	MaxStakeGamePercent=@MaxStakeGamePercent,
	LimitPerLiveTicket=@LimitPerLiveTicket,
	StakeDay=@StakeDay,
	StakeWeek=@StakeWeek,
	StakeMonth=@StakeMonth,
	MinCombiBranch=@MinCombiBranch,
	MinCombiInternet=@MinCombiInternet,
	MinCombiMachine=@MinCombiMachine,
	StakeDailyLimit=@StakeDailyLimit ,
	StakeWeeklyLimit=@StakeWeeklyLimit ,
	StakeMonthlyLimit=@StakeMonthlyLimit ,
	DepositDailyLimit=@DepositDailyLimit ,
	DepositWeeklyLimit=@DepositWeeklyLimit ,
	DepositMonthlyLimit=@DepositMonthlyLimit ,
	LossDailyLimit=@LossDailyLimit ,
	LossWeeklyLimit=@LossWeeklyLimit ,
	LossMonthlyLimit=@LossMonthlyLimit,
	LimitPerVirtualTicket=@LimitPerVirtualTicket,
	UpdateDate=GETDATE()
	where ParameterLimitId=@ParameterLimitId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
