USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcSummarySportBettingFill_2]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Report].[ProcSummarySportBettingFill_2] 
AS

BEGIN
SET NOCOUNT ON;


declare @StartDate date
declare @EndDate date
 
	set @StartDate=DATEADD(DAY,-1,GETDATE())



if(@StartDate>=GETDATE())
	set @StartDate=GETDATE()


set @EndDate=DATEADD(DAY,1,@StartDate)


IF EXISTS (select  Report.SummarySportBetting2.SummarySportBettingId from  Report.SummarySportBetting2 where  Report.SummarySportBetting2.ReportDate=@StartDate)
		delete from Report.SummarySportBetting2 where ReportDate=@StartDate

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
CustomerId bigint,
SourceId int,
TaxCount int,
Tax money,
PayOutCount money,
PayOutAmount money,
OrgSlipAmount money,
OrgOpenSlipAmount money,
OrgOpenSlipPayOut money,
OrgWonSlipAmount money,
OrgWonSlipPayOut money,
OrgLostSlipAmount money,
OrgCancelSlipAmount money,
OrgTax money,
OrgPayOutAmount money,
CashoutSlipCount int,
CashOutSlipAmount money,
OrgCashOutSlipAmount money,
OnlineDeposit money,
OnlineWithDraw money
)

select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 
declare @addhour int=1

insert @TempSummaryBet (SlipCount,SlipAmount,OrgSlipAmount,CustomerId,SourceId)
select COUNT(Customer.Slip.SlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0),SUM(Customer.Slip.Amount)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
From Customer.Slip inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.CreateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.CreateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId

insert @TempSummaryBet (OpenSlipCount,OpenSlipAmount,OpenSlipPayOut,OrgOpenSlipAmount,OrgOpenSlipPayOut,CustomerId,SourceId)
select COUNT(Customer.Slip.SlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Customer.Slip.Amount)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
From Customer.Slip inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId=1  and Customer.Slip.SlipTypeId<>3
and cast(DATEADD(HOUR,@addhour,Customer.Slip.CreateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.CreateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId

insert @TempSummaryBet (WonSlipCount,WonSlipAmount,WonSlipPayOut,OrgWonSlipAmount,OrgWonSlipPayOut,CustomerId,SourceId)
select COUNT(Customer.Slip.SlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Customer.Slip.Amount)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
From Customer.Slip inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId in (3,5)  and TotalOddValue>1   and Customer.Slip.SlipTypeId<>3
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId

insert @TempSummaryBet (WonSlipCount,WonSlipAmount,WonSlipPayOut,OrgWonSlipAmount,OrgWonSlipPayOut,CustomerId,SourceId)
select COUNT(Archive.Slip.SlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Archive.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Archive.Slip.Amount)
,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
,Customer.Customer.CustomerId
,Archive.Slip.SourceId
From Archive.Slip inner join Customer.Customer on Archive.Slip.CustomerId=Customer.Customer.CustomerId
Where Archive.Slip.SlipStatu not in (2,4) and Archive.Slip.SlipStateId in (3,5)  and TotalOddValue>1   and Archive.Slip.SlipTypeId<>3
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Archive.Slip.SourceId

insert @TempSummaryBet (CashoutSlipCount,CashOutSlipAmount,OrgCashOutSlipAmount,CustomerId,SourceId)
select COUNT(Customer.Slip.SlipId)
, SUM(dbo.FuncCurrencyConverter(Customer.SlipCashOut.CashOutValue,Customer.Slip.CurrencyId,@SystemCurrencyId))
,SUM(Customer.SlipCashOut.CashOutValue)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId 
  INNER JOIN Customer.SlipCashOut ON Customer.SlipCashOut.SlipId=Customer.Slip.SlipId
Where Customer.Slip.SlipStatu not in (2,4)  and Customer.Slip.SlipStateId in (7) and Customer.Slip.SlipTypeId<>3
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)<cast(@EndDate as date)
 GROUP BY  Customer.Slip.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId

  insert @TempSummaryBet (CashoutSlipCount,CashOutSlipAmount,OrgCashOutSlipAmount,CustomerId,SourceId)
select COUNT(Archive.Slip.SlipId)
, SUM(dbo.FuncCurrencyConverter(Customer.SlipCashOut.CashOutValue,Archive.Slip.CurrencyId,@SystemCurrencyId))
,SUM(Customer.SlipCashOut.CashOutValue)
,Customer.Customer.CustomerId
,Archive.Slip.SourceId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId 
  INNER JOIN Customer.SlipCashOut ON Customer.SlipCashOut.SlipId=Archive.Slip.SlipId
Where Archive.Slip.SlipStatu not in (2,4)  and Archive.Slip.SlipStateId in (7) and Archive.Slip.SlipTypeId<>3
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)<cast(@EndDate as date)
 GROUP BY  Archive.Slip.CurrencyId,Customer.Customer.CustomerId,Archive.Slip.SourceId

insert @TempSummaryBet (PayOutCount,PayOutAmount,OrgPayOutAmount,CustomerId,SourceId)
select COUNT(Customer.Slip.SlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
From Customer.Slip inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId in (3,5)  and Customer.Slip.IsPayOut=1
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId

insert @TempSummaryBet (PayOutCount,PayOutAmount,OrgPayOutAmount,CustomerId,SourceId)
select COUNT(Archive.Slip.SlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
,Customer.Customer.CustomerId
,Archive.Slip.SourceId
From Archive.Slip inner join Customer.Customer on Archive.Slip.CustomerId=Customer.Customer.CustomerId
Where Archive.Slip.SlipStatu not in (2,4) and Archive.Slip.SlipStateId in (3,5)  and Archive.Slip.IsPayOut=1
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Archive.Slip.SourceId

insert @TempSummaryBet (TaxCount,Tax,OrgTax,CustomerId,SourceId)
select COUNT(Customer.Tax.SlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Tax.[TaxAmount]),Customer.Tax.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Customer.Tax.[TaxAmount])
,Customer.Tax.CustomerId
,Customer.Tax.SourceId
From Customer.Tax 
Where Customer.Tax.TaxStatusId in (1,3)
and  cast(DATEADD(HOUR,@addhour,Customer.Tax.[CreateDate]) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Tax.[CreateDate]) as date)<cast(@EndDate as date)
GROUP BY Customer.Tax.CurrencyId,Customer.Tax.CustomerId,Customer.Tax.SourceId


insert @TempSummaryBet (LostSlipCount,LostSlipAmount,OrgLostSlipAmount,CustomerId,SourceId)
select COUNT(Customer.Slip.SlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Customer.Slip.Amount)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
From Customer.Slip inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId=4  and Customer.Slip.SlipTypeId<>3
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId

insert @TempSummaryBet (LostSlipCount,LostSlipAmount,OrgLostSlipAmount,CustomerId,SourceId)
select COUNT(Archive.Slip.SlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Archive.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Archive.Slip.Amount)
,Customer.Customer.CustomerId
,Archive.Slip.SourceId
From Archive.Slip inner join Customer.Customer on Archive.Slip.CustomerId=Customer.Customer.CustomerId
Where Archive.Slip.SlipStatu not in (2,4) and Archive.Slip.SlipStateId=4  and Archive.Slip.SlipTypeId<>3
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Archive.Slip.SourceId

insert @TempSummaryBet (CancelSlipCount,CancelSlipAmount,OrgCancelSlipAmount,CustomerId,SourceId)
select COUNT(Customer.Slip.SlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Customer.Slip.Amount)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
From Customer.Slip inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and (Customer.Slip.SlipStateId=2  or (Customer.Slip.SlipStateId=3 and Customer.Slip.TotalOddValue=1))
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId

insert @TempSummaryBet (CancelSlipCount,CancelSlipAmount,OrgCancelSlipAmount,CustomerId,SourceId)
select COUNT(Archive.Slip.SlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Archive.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Archive.Slip.Amount)
,Customer.Customer.CustomerId
,Archive.Slip.SourceId
From Archive.Slip inner join Customer.Customer on Archive.Slip.CustomerId=Customer.Customer.CustomerId
Where Archive.Slip.SlipStatu not in (2,4) and (Archive.Slip.SlipStateId=2  or (Archive.Slip.SlipStateId=3 and Archive.Slip.TotalOddValue=1))
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Archive.Slip.SourceId

insert @TempSummaryBet (CancelSlipCount,CancelSlipAmount,OrgCancelSlipAmount,CustomerId,SourceId)
select 0
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Tax.[TaxAmount]),Customer.Tax.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Customer.Tax.[TaxAmount])
,Customer.Tax.CustomerId
,Customer.Tax.SourceId
From Customer.Tax 
Where Customer.Tax.TaxStatusId in (2)
 and  cast(DATEADD(HOUR,@addhour,Customer.Tax.[CreateDate]) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Tax.[CreateDate]) as date)<cast(@EndDate as date)
GROUP BY Customer.Tax.CurrencyId,Customer.Tax.CustomerId,Customer.Tax.SourceId

insert @TempSummaryBet (SlipCount,SlipAmount,OrgSlipAmount,CustomerId,SourceId)
select 0
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Tax.[TaxAmount]),Customer.Tax.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Customer.Tax.[TaxAmount])
,Customer.Tax.CustomerId
,Customer.Tax.SourceId
From Customer.Tax 
Where Customer.Tax.TaxStatusId in (2)
 and  cast(DATEADD(HOUR,@addhour,Customer.Tax.[CreateDate]) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Tax.[CreateDate]) as date)<cast(@EndDate as date)
GROUP BY Customer.Tax.CurrencyId,Customer.Tax.CustomerId,Customer.Tax.SourceId


insert @TempSummaryBet (OpenSlipCount,OpenSlipAmount,OpenSlipPayOut,OrgOpenSlipAmount,OrgOpenSlipPayOut,CustomerId,SourceId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.SlipSystem.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.SlipSystem.Amount*Customer.SlipSystem.TotalOddValue),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Customer.SlipSystem.Amount)
,SUM(Customer.SlipSystem.Amount*Customer.SlipSystem.TotalOddValue)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
From Customer.SlipSystem inner join Customer.Customer on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where Customer.SlipSystem.SlipStatuId not in (2,4) and Customer.SlipSystem.SlipStateId=1   
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.CreateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.CreateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId

insert @TempSummaryBet (WonSlipCount,WonSlipAmount,WonSlipPayOut,OrgWonSlipAmount,OrgWonSlipPayOut,CustomerId,SourceId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,ISNULL((Select dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) from Customer.Slip where  Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as  CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select dbo.FuncCurrencyConverter(SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as  CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Customer.Slip.Amount) from Customer.Slip where  Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip where Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
From Customer.SlipSystem inner join Customer.Customer on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where Customer.SlipSystem.SlipStatuId not in (2,4) and Customer.SlipSystem.SlipStateId in (3,5)  
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId

insert @TempSummaryBet (WonSlipCount,WonSlipAmount,WonSlipPayOut,OrgWonSlipAmount,OrgWonSlipPayOut,CustomerId,SourceId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,ISNULL((Select dbo.FuncCurrencyConverter(SUM(Archive.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) from Archive.Slip where  Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as  CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select dbo.FuncCurrencyConverter(SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) from Archive.Slip where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as  CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Archive.Slip.Amount) from Archive.Slip where  Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip where Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
From Customer.SlipSystem inner join Customer.Customer on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where Customer.SlipSystem.SlipStatuId not in (2,4) and Customer.SlipSystem.SlipStateId in (3,5)  
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId

insert @TempSummaryBet (LostSlipCount,LostSlipAmount,OrgLostSlipAmount,CustomerId,SourceId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.SlipSystem.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0)
,SUM(Customer.SlipSystem.Amount)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
From Customer.SlipSystem inner join Customer.Customer on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where Customer.SlipSystem.SlipStatuId not in (2,4) and Customer.SlipSystem.SlipStateId=4 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId


IF EXISTS (select  Report.SummarySportBetting2.SummarySportBettingId from  Report.SummarySportBetting2 where  Report.SummarySportBetting2.ReportDate=@StartDate)
		delete from Report.SummarySportBetting2 where ReportDate=@StartDate

insert Report.SummarySportBetting2
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
,SourceId
,SUM(ISNULL(TaxCount,0))
,SUM(ISNULL(Tax,0))
,SUM(ISNULL(PayOutCount,0))
,SUM(ISNULL(PayOutAmount,0))
,SUM(ISNULL(OrgSlipAmount,0))
,SUM(ISNULL(OrgOpenSlipAmount,0))
,SUM(ISNULL(OrgOpenSlipPayOut,0))
,SUM(ISNULL(OrgWonSlipAmount,0))
,SUM(ISNULL(OrgWonSlipPayOut,0))
,SUM(ISNULL(OrgLostSlipAmount,0))
,SUM(ISNULL(OrgCancelSlipAmount,0))
,SUM(ISNULL(OrgTax,0))
,SUM(ISNULL(OrgPayOutAmount,0))
,SUM(ISNULL(CashoutSlipCount,0))
,SUM(ISNULL(CashOutSlipAmount,0))
,SUM(ISNULL(OrgCashOutSlipAmount,0))
,1,0,0
from @TempSummaryBet
GROUP BY CustomerId,SourceId


if(@@ROWCOUNT=0)
begin
INSERT INTO [Report].[SummarySportBetting]
           ([ReportDate]
           ,[SlipCount]
           ,[SlipAmount]
           ,[OpenSlipCount]
           ,[OpenSlipAmount]
           ,[OpenSlipPayOut]
           ,[WonSlipCount]
           ,[WonSlipAmount]
           ,[WonSlipPayOut]
           ,[LostSlipCount]
           ,[LostSlipAmount]
           ,[CancelSlipCount]
           ,[CancelSlipAmount]
           ,[CustomerId]
           ,[SourceId]
           ,[TaxCount]
           ,[Tax]
           ,[PayOutCount]
           ,[PayOutAmount],CashoutSlipCount,CashoutSlipAmount,OrgCashoutSlipAmount)
     VALUES (@StartDate,0,0,0,0,0,0,0,0,0,0,0,0,1000,0,0,0,0,0,0,0,0)

end




END



  



GO
