USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcSummarySportBettingFill2]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Report].[ProcSummarySportBettingFill2] 
AS

BEGIN
SET NOCOUNT ON;


declare @StartDate date
declare @EndDate date

declare @sayac int=datepart(dayofyear, getdate())

WHILE (@sayac) > 0
  BEGIN

	set @StartDate=DATEADD(DAY,-1*@sayac,GETDATE())


set @EndDate=DATEADD(DAY,1,@StartDate)
set @sayac=@sayac-1

IF EXISTS (select  Report.SummarySportBetting.SummarySportBettingId from  Report.SummarySportBetting where  Report.SummarySportBetting.ReportDate=@StartDate)
		delete from Report.SummarySportBetting where ReportDate=@StartDate

declare @ReportDate date
declare @SlipCount int
declare @SlipAmount money
declare @OpenSlipCount int
declare @OpenSlipAmount money
declare @OpenSlipPayOut money
declare @WonSlipCount int
declare @WonSlipAmount money
declare @WonSlipPayOut money
declare @LostSlipCount int
declare @LostSlipAmount money
declare @CancelSlipCount int
declare @CancelSlipAmount money
declare @TurnOver money
declare @TurnOverRate float
declare @SystemCurrencyId int

declare @TempSummaryBet table (
SlipCount int,
SlipAmount money,
OpenSlipCount int,
OpenSlipAmount money,
OpenSlipPayOut money,
WonSlipCount int,
WonSlipAmount money,
WonSlipPayOut money,
LostSlipCount int,
LostSlipAmount money,
CancelSlipCount int,
CancelSlipAmount money,
CustomerId bigint
)

select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 

insert @TempSummaryBet (SlipCount,SlipAmount,CustomerId)
select COUNT(Customer.Slip.SlipId),ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0),Customer.Customer.CustomerId
From Customer.Slip with (nolock) inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) 
and cast(Customer.Slip.CreateDate as date)>=cast(@StartDate as date) 
and cast(Customer.Slip.CreateDate as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId

insert @TempSummaryBet (OpenSlipCount,OpenSlipAmount,OpenSlipPayOut,CustomerId)
select COUNT(Customer.Slip.SlipId),ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0),Customer.Customer.CustomerId
From Customer.Slip with (nolock) inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId=1 
and cast(Customer.Slip.CreateDate as date)>=cast(@StartDate as date) 
and cast(Customer.Slip.CreateDate as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId

insert @TempSummaryBet (WonSlipCount,WonSlipAmount,WonSlipPayOut,CustomerId)
select COUNT(Customer.Slip.SlipId),ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0),Customer.Customer.CustomerId
From Customer.Slip with (nolock) inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId in (3,5) 
and cast(Customer.Slip.EvaluateDate as date)>=cast(@StartDate as date) 
and cast(Customer.Slip.EvaluateDate as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId

insert @TempSummaryBet (LostSlipCount,LostSlipAmount,CustomerId)
select COUNT(Customer.Slip.SlipId),ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0),Customer.Customer.CustomerId
From Customer.Slip with (nolock) inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId=4 
and cast(Customer.Slip.EvaluateDate as date)>=cast(@StartDate as date) 
and cast(Customer.Slip.EvaluateDate as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId

insert @TempSummaryBet (CancelSlipCount,CancelSlipAmount,CustomerId)
select COUNT(Customer.Slip.SlipId),ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0),Customer.Customer.CustomerId
From Customer.Slip with (nolock) inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId=2 
and cast(Customer.Slip.EvaluateDate as date)>=cast(@StartDate as date) 
and cast(Customer.Slip.EvaluateDate as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId


IF EXISTS (select  Report.SummarySportBetting.SummarySportBettingId from  Report.SummarySportBetting where  Report.SummarySportBetting.ReportDate=@StartDate)
		delete from Report.SummarySportBetting where ReportDate=@StartDate

insert Report.SummarySportBetting
select @StartDate,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(SlipAmount,0))
,SUM(ISNULL(OpenSlipCount,0))
,SUM(ISNULL(OpenSlipAmount,0))
,SUM(ISNULL(OpenSlipPayOut,0))
,SUM(ISNULL(WonSlipCount,0))
,SUM(ISNULL(WonSlipAmount,0))
,SUM(ISNULL(WonSlipPayOut,0))
,SUM(ISNULL(LostSlipCount,0))
,SUM(ISNULL(LostSlipAmount,0))
,SUM(ISNULL(CancelSlipCount,0))
,SUM(ISNULL(CancelSlipAmount,0))
,CustomerId
from @TempSummaryBet
GROUP BY CustomerId


if(@@ROWCOUNT=0)
begin
insert Report.SummaryBonusSportBetting
select @StartDate,0,0,0,0,0,0,0,0,0,0,0,0,0

end


delete from @TempSummaryBet

end


END



GO
