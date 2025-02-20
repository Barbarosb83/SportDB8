USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcCustomerLimitControl]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:	
-- =============================================
CREATE PROCEDURE [BetAcceptance].[ProcCustomerLimitControl] 
@CustomerId bigint


AS

declare @StakeDayLimit money
declare @StakeWeekLimit money
declare @StakeMonthLimit money
declare @LimitPerTicket money

declare @StakeDLimit money=0
declare @StakeWLimit money=0
declare @StakeMLimit money=0
declare @MaxWinningLimit money=0
declare @MaxSlipCount int=0
declare @CustomerCurrencyId int
declare @systemCurrencyId int
declare @BranchCurrencyId int
declare @MinTicketLimit money=0
declare @MaxEventForTicket int
declare @IsBranchCustomer bit
declare @BranchBalance money
declare @CustomerTransMoney money=9999999
declare @CustomerIsActive bit=0
declare @BranchId int
declare @CustomerCurrency int
declare @IsActive bit
declare @CustomerBalance money
declare @LostLimitDay money=0
declare @TempLockOut bit=0
declare @PendingTime int
--select @LostLimitDay=ISNULL(SUM(Customer.Slip.Amount),0) from Customer.Slip with (nolock) where Customer.Slip.CustomerId=@CustomerId and SlipStateId=4  and Customer.Slip.SlipStatu=1 and cast(CreateDate as DATE)=CAST(GETDATE() as Date)



Select @StakeDayLimit=StakeDay --dbo.FuncCurrencyConverter(StakeDay,@systemCurrencyId,Customer.Customer.CurrencyId)
,@StakeMonthLimit=StakeMonth --dbo.FuncCurrencyConverter(StakeMonth,@systemCurrencyId,Customer.Customer.CurrencyId)
,@StakeWeekLimit=StakeWeek --dbo.FuncCurrencyConverter(StakeWeek,@systemCurrencyId,Customer.Customer.CurrencyId),@CustomerCurrencyId=Customer.Customer.CurrencyId
,@CustomerIsActive=IsLockedOut,@LostLimitDay=ISNULL(LossDay,0) --dbo.FuncCurrencyConverter(ISNULL(LossDay,0),@systemCurrencyId,Customer.Customer.CurrencyId)-@LostLimitDay
,@IsBranchCustomer=IsBranchCustomer,@BranchId=Customer.Customer.BranchId,@CustomerCurrency= Customer.Customer.CurrencyId,@IsActive=Customer.Customer.IsActive,@CustomerBalance=Customer.Balance+ISNULL(Customer.Bonus,0)
,@TempLockOut=IsTempLock,@PendingTime=PendingTime
FROM         Customer.Customer with (nolock) INNER JOIN
                      Customer.StakeLimit with (nolock) ON Customer.Customer.CustomerId = Customer.StakeLimit.CustomerId where Customer.StakeLimit.CustomerId=@CustomerId

select top 1 @systemCurrencyId=General.Setting.SystemCurrencyId from General.Setting with (nolock)


--if (@IsBranchCustomer=0)
--	if (@PendingTime>10 and @PendingTime<15)
--		waitfor delay '00:00:05.000'
--	else if(@PendingTime>=15)
--		waitfor delay '00:00:10.000'
--	else
--	waitfor delay '00:00:03.000'

--select top 1 @BranchCurrencyId=Parameter.Branch.CurrencyId,@BranchBalance=Balance from Parameter.Branch where Parameter.Branch.BranchId=(select top 1 Customer.Customer.BranchId from Customer.Customer where Customer.CustomerId=@CustomerId)
 if @TempLockOut=1
  set @IsActive=0

if(@IsBranchCustomer=0 and @BranchId=32643)
begin

Select @StakeDayLimit=@StakeDayLimit-ISNULL(SUM(Customer.Slip.Amount),0) from Customer.Slip with (nolock) where Customer.Slip.CustomerId=@CustomerId  and Customer.Slip.SlipStatu=1 and cast(CreateDate as DATE)=CAST(GETDATE() as Date)

select @StakeWeekLimit=@StakeWeekLimit-ISNULL(SUM(Customer.Slip.Amount),0) from Customer.Slip with (nolock) where Customer.Slip.CustomerId=@CustomerId and Customer.Slip.SlipStatu=1 and cast(CreateDate as DATE)<CAST(GETDATE() as Date) and cast(CreateDate as DATE)>=CAST(DATEADD(DAY,-7,GETDATE()) as Date)

select @StakeWeekLimit=@StakeWeekLimit-ISNULL(SUM(Archive.Slip.Amount),0) from Archive.Slip with (nolock) where Archive.Slip.CustomerId=@CustomerId and Archive.Slip.SlipStatu=1 and cast(CreateDate as DATE)<CAST(GETDATE() as Date) and cast(CreateDate as DATE)>=CAST(DATEADD(DAY,-7,GETDATE()) as Date)

select @StakeMonthLimit=@StakeMonthLimit-ISNULL(SUM(Customer.Slip.Amount),0) from Customer.Slip with (nolock) where Customer.Slip.CustomerId=@CustomerId  and Customer.Slip.SlipStatu=1 and cast(CreateDate as DATE)<CAST(GETDATE() as Date) and cast(CreateDate as DATE)>=CAST(DATEADD(MONTH,-1,GETDATE()) as Date)

select @StakeMonthLimit=@StakeMonthLimit-ISNULL(SUM(Archive.Slip.Amount),0) from Archive.Slip with (nolock) where Archive.Slip.CustomerId=@CustomerId  and Archive.Slip.SlipStatu=1 and cast(CreateDate as DATE)<CAST(GETDATE() as Date) and cast(CreateDate as DATE)>=CAST(DATEADD(MONTH,-1,GETDATE()) as Date)
end




select top 1 @BranchBalance=Balance
, @MaxWinningLimit=MaxWinningLimit --dbo.FuncCurrencyConverter(MaxWinningLimit,Parameter.Branch.CurrencyId,@CustomerCurrencyId)
,@MaxSlipCount=MaxCopySlip
,@MinTicketLimit=MinTicketLimit --dbo.FuncCurrencyConverter(MinTicketLimit,Parameter.Branch.CurrencyId,@CustomerCurrencyId)
,@MaxEventForTicket=MaxEventForTicket 
from Parameter.Branch with (nolock) where BranchId=@BranchId

--Tüm limitler müşterinin para birimine dönüştürülüyor.

--select @CustomerTransMoney= SUM(Customer.[Transaction].Amount)
--		 from customer.[Transaction]  
--		  where TransactionTypeId in (1,11,13,15,17,19,21,23,25,27,29,30,32,46,55,57,59,2,10,12,14,16,18,20,22,24,26,28,31,62,56,58,60) and TransactionDate>=DATEADD(Day,-7,GETDATE()) and CustomerId=@CustomerId
	



if(@IsBranchCustomer=0)
select  case when @StakeDayLimit<0 or @CustomerIsActive=1 then 0 else @StakeDayLimit end  as StakeDayLimit,case when @StakeWeekLimit<0 then 0 else @StakeWeekLimit end  as StakeWeekLimit, case when @StakeMonthLimit<0 then 0 else @StakeMonthLimit end as StakeMonthLimit,
--dbo.FuncCurrencyConverter(Customer.StakeLimit.LimitPerTicket,@systemCurrencyId,@CustomerCurrency) as LimitPerTicket,
 Customer.StakeLimit.LimitPerTicket as LimitPerTicket,
--dbo.FuncCurrencyConverter(Customer.StakeLimit.LimitPerLiveTicket,@systemCurrencyId,@CustomerCurrency) as LimitPerLiveTicket,
Customer.StakeLimit.LimitPerLiveTicket as LimitPerLiveTicket,
Customer.StakeLimit.MinCombiBranch,
Customer.StakeLimit.MinCombiInternet
,Customer.StakeLimit.MinCombiMachine,
@IsActive as IsActive,@MaxWinningLimit as MaxWinningLimit,@MaxSlipCount as MaxSlipCopy,
@CustomerBalance as Balance,Customer.StakeLimit.PendingTime,@MinTicketLimit as MinTicketLimit,@MaxEventForTicket as MaxEventForTicket,@CustomerTransMoney as TransactionMoney
,case when @LostLimitDay<0.3 then cast(0 as money) else cast(90000 as money) end  as LossLimitDay
FROM       
                      Customer.StakeLimit with (nolock) 
where Customer.StakeLimit.CustomerId=@CustomerId

else
select  cast(90000000 as money)  as StakeDayLimit,cast(90000000 as money)  as StakeWeekLimit, cast(90000000 as money) as StakeMonthLimit,
--dbo.FuncCurrencyConverter(Customer.StakeLimit.LimitPerTicket,@systemCurrencyId,@CustomerCurrency) as LimitPerTicket,
Customer.StakeLimit.LimitPerTicket as LimitPerTicket,
--dbo.FuncCurrencyConverter(Customer.StakeLimit.LimitPerLiveTicket,@systemCurrencyId,@CustomerCurrency) as LimitPerLiveTicket,
Customer.StakeLimit.LimitPerLiveTicket as LimitPerLiveTicket,
Customer.StakeLimit.MinCombiBranch,
Customer.StakeLimit.MinCombiInternet
,Customer.StakeLimit.MinCombiMachine,
@IsActive as IsActive,@MaxWinningLimit as MaxWinningLimit,99999 as MaxSlipCopy,
@BranchBalance as Balance,Customer.StakeLimit.PendingTime,@MinTicketLimit as MinTicketLimit,@MaxEventForTicket as MaxEventForTicket,@CustomerTransMoney as TransactionMoney
,cast(90000000 as money) as LossLimitDay
FROM         
                      Customer.StakeLimit with (nolock)  
where Customer.StakeLimit.CustomerId=@CustomerId




GO
