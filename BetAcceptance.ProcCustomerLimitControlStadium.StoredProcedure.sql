USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [BetAcceptance].[ProcCustomerLimitControlStadium]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:	
-- =============================================
CREATE PROCEDURE [BetAcceptance].[ProcCustomerLimitControlStadium] 
@CustomerId bigint,
@StadiumId bigint


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
declare @IsStadiumOk bit=1



if exists (Select Stadium.Customers.StadiumCustomerId from Stadium.Customers where CustomerId=@CustomerId and StadiumId=@StadiumId)
		set @IsStadiumOk=0



select top 1 @systemCurrencyId=General.Setting.SystemCurrencyId from General.Setting 

select top 1 @BranchCurrencyId=Parameter.Branch.CurrencyId,@BranchBalance=Balance from Parameter.Branch where Parameter.Branch.BranchId=(select top 1 Customer.Customer.BranchId from Customer.Customer where Customer.CustomerId=@CustomerId)

declare @LostLimitDay money=0

select @LostLimitDay=ISNULL(SUM(Customer.Slip.Amount),0) from Customer.Slip with (nolock) where Customer.Slip.CustomerId=@CustomerId and SlipStateId=4  and Customer.Slip.SlipStatu=1 and cast(CreateDate as DATE)=CAST(GETDATE() as Date)

Select @StakeDLimit=ISNULL(SUM(Customer.Slip.Amount),0) from Customer.Slip with (nolock) where Customer.Slip.CustomerId=@CustomerId  and Customer.Slip.SlipStatu=1 and cast(CreateDate as DATE)=CAST(GETDATE() as Date)

select @StakeWLimit=ISNULL(SUM(Customer.Slip.Amount),0) from Customer.Slip with (nolock) where Customer.Slip.CustomerId=@CustomerId and Customer.Slip.SlipStatu=1 and cast(CreateDate as DATE)<CAST(GETDATE() as Date) and cast(CreateDate as DATE)>=CAST(DATEADD(DAY,-7,GETDATE()) as Date)

select @StakeWLimit=@StakeWLimit+ISNULL(SUM(Archive.Slip.Amount),0) from Archive.Slip with (nolock) where Archive.Slip.CustomerId=@CustomerId and Archive.Slip.SlipStatu=1 and cast(CreateDate as DATE)<CAST(GETDATE() as Date) and cast(CreateDate as DATE)>=CAST(DATEADD(DAY,-7,GETDATE()) as Date)

select @StakeMLimit=ISNULL(SUM(Customer.Slip.Amount),0) from Customer.Slip with (nolock) where Customer.Slip.CustomerId=@CustomerId  and Customer.Slip.SlipStatu=1 and cast(CreateDate as DATE)<CAST(GETDATE() as Date) and cast(CreateDate as DATE)>=CAST(DATEADD(MONTH,-1,GETDATE()) as Date)

select @StakeMLimit=@StakeMLimit+ISNULL(SUM(Archive.Slip.Amount),0) from Archive.Slip with (nolock) where Archive.Slip.CustomerId=@CustomerId  and Archive.Slip.SlipStatu=1 and cast(CreateDate as DATE)<CAST(GETDATE() as Date) and cast(CreateDate as DATE)>=CAST(DATEADD(MONTH,-1,GETDATE()) as Date)


Select @StakeDayLimit=dbo.FuncCurrencyConverter(StakeDay,@systemCurrencyId,Customer.Customer.CurrencyId)-@StakeDLimit
,@StakeMonthLimit=dbo.FuncCurrencyConverter(StakeMonth,@systemCurrencyId,Customer.Customer.CurrencyId)-@StakeMLimit
,@StakeWeekLimit= dbo.FuncCurrencyConverter(StakeWeek,@systemCurrencyId,Customer.Customer.CurrencyId)-@StakeWLimit,@CustomerCurrencyId=Customer.Customer.CurrencyId
,@IsBranchCustomer=IsBranchCustomer,@CustomerIsActive=IsLockedOut,@LostLimitDay=dbo.FuncCurrencyConverter(ISNULL(LossDay,0),@systemCurrencyId,Customer.Customer.CurrencyId)-@LostLimitDay
FROM         Customer.Customer with (nolock) INNER JOIN
                      Customer.StakeLimit with (nolock) ON Customer.Customer.CustomerId = Customer.StakeLimit.CustomerId where Customer.StakeLimit.CustomerId=@CustomerId


select @MaxWinningLimit=dbo.FuncCurrencyConverter(MaxWinningLimit,@BranchCurrencyId,@CustomerCurrencyId),@MaxSlipCount=MaxCopySlip,@MinTicketLimit=dbo.FuncCurrencyConverter(MinTicketLimit,@BranchCurrencyId,@CustomerCurrencyId),@MaxEventForTicket=MaxEventForTicket 
from Parameter.Branch where BranchId=(select top 1 Customer.Customer.BranchId from Customer.Customer where Customer.CustomerId=@CustomerId)

--Tüm limitler müşterinin para birimine dönüştürülüyor.

--select @CustomerTransMoney= SUM(Customer.[Transaction].Amount)
--		 from customer.[Transaction]  
--		  where TransactionTypeId in (1,11,13,15,17,19,21,23,25,27,29,30,32,46,55,57,59,2,10,12,14,16,18,20,22,24,26,28,31,62,56,58,60) and TransactionDate>=DATEADD(Day,-7,GETDATE()) and CustomerId=@CustomerId
	



if(@IsBranchCustomer=0)
select  case when @StakeDayLimit<0 or @CustomerIsActive=1 then 0 else @StakeDayLimit end  as StakeDayLimit,case when @StakeWeekLimit<0 then 0 else @StakeWeekLimit end  as StakeWeekLimit, case when @StakeMonthLimit<0 then 0 else @StakeMonthLimit end as StakeMonthLimit,
dbo.FuncCurrencyConverter(Customer.StakeLimit.LimitPerTicket,@systemCurrencyId,Customer.Customer.CurrencyId) as LimitPerTicket,
dbo.FuncCurrencyConverter(Customer.StakeLimit.LimitPerLiveTicket,@systemCurrencyId,Customer.Customer.CurrencyId) as LimitPerLiveTicket,
Customer.StakeLimit.MinCombiBranch,
Customer.StakeLimit.MinCombiInternet
,Customer.StakeLimit.MinCombiMachine,
Customer.Customer.IsActive,@MaxWinningLimit as MaxWinningLimit,@MaxSlipCount as MaxSlipCopy,
Customer.Balance+ISNULL(Customer.Bonus,0) as Balance,Customer.StakeLimit.PendingTime,@MinTicketLimit as MinTicketLimit,@MaxEventForTicket as MaxEventForTicket,@CustomerTransMoney as TransactionMoney
,case when @LostLimitDay<0.3 then 0 else @LostLimitDay end  as LossLimitDay,@IsStadiumOk as IsStadiumOk
FROM         Customer.Customer with (nolock) INNER JOIN
                      Customer.StakeLimit with (nolock) ON Customer.Customer.CustomerId = Customer.StakeLimit.CustomerId
where Customer.StakeLimit.CustomerId=@CustomerId

else
select  cast(90000000 as money)  as StakeDayLimit,cast(90000000 as money)  as StakeWeekLimit, cast(90000000 as money) as StakeMonthLimit,
dbo.FuncCurrencyConverter(Customer.StakeLimit.LimitPerTicket,@systemCurrencyId,Customer.Customer.CurrencyId) as LimitPerTicket,
dbo.FuncCurrencyConverter(Customer.StakeLimit.LimitPerLiveTicket,@systemCurrencyId,Customer.Customer.CurrencyId) as LimitPerLiveTicket,
Customer.StakeLimit.MinCombiBranch,
Customer.StakeLimit.MinCombiInternet
,Customer.StakeLimit.MinCombiMachine,
Customer.Customer.IsActive,@MaxWinningLimit as MaxWinningLimit,99999 as MaxSlipCopy,
@BranchBalance as Balance,Customer.StakeLimit.PendingTime,@MinTicketLimit as MinTicketLimit,@MaxEventForTicket as MaxEventForTicket,@CustomerTransMoney as TransactionMoney
,cast(90000000 as money) as LossLimitDay,@IsStadiumOk as IsStadiumOk
FROM         Customer.Customer with (nolock) INNER JOIN
                      Customer.StakeLimit with (nolock) ON Customer.Customer.CustomerId = Customer.StakeLimit.CustomerId
where Customer.StakeLimit.CustomerId=@CustomerId




GO
