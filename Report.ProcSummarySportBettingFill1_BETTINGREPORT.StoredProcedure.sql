USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcSummarySportBettingFill1_BETTINGREPORT]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Report].[ProcSummarySportBettingFill1_BETTINGREPORT] 
AS

BEGIN
SET NOCOUNT ON;


declare @StartDate date
declare @EndDate date

	set @StartDate=GETDATE()

	
set @EndDate=DATEADD(DAY,1,@StartDate)
if exists (SELECT [ID]  FROM [BettingReport].[Report].[SummarySportBettingCreate] where DATEADD(MINUTE,5,CreateDate)<GETDATE())
begin
	update [BettingReport].[Report].[SummarySportBettingCreate] set CreateDate=GETDATE()
IF EXISTS (select  [BettingReport].Report.SummarySportBetting.SummarySportBettingId from  [BettingReport].Report.SummarySportBetting with (nolock) where  [BettingReport].Report.SummarySportBetting.ReportDate=@StartDate)
		delete from [BettingReport].Report.SummarySportBetting where ReportDate=@StartDate

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
OnlineWithDraw money,
BranchId bigint,
Bonus money,
WonSlipAll money
)

select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 
declare @addhour int=2

insert @TempSummaryBet (SlipCount,SlipAmount,OrgSlipAmount,CustomerId,SourceId,BranchId)
select COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount),SUM(Customer.Slip.Amount)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
,Customer.Customer.BranchId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId not in (8)
and cast(DATEADD(HOUR,@addhour,Customer.Slip.CreateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.CreateDate) as date)<cast(@EndDate as date) and SlipTypeId<4
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (OpenSlipCount,OpenSlipAmount,OpenSlipPayOut,OrgOpenSlipAmount,OrgOpenSlipPayOut,CustomerId,SourceId,BranchId)
select COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,SUM(Customer.Slip.Amount)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
,Customer.Customer.BranchId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId=1   and Customer.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,@addhour,Customer.Slip.CreateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.CreateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (WonSlipCount,WonSlipAmount,WonSlipPayOut,OrgWonSlipAmount,OrgWonSlipPayOut,CustomerId,SourceId,BranchId)
select COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,SUM(Customer.Slip.Amount)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
,Customer.Customer.BranchId
From Customer.Slip  with (nolock) inner join Customer.Customer  with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId in (3,5)  and TotalOddValue>1    and Customer.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (WonSlipCount,WonSlipAmount,WonSlipPayOut,OrgWonSlipAmount,OrgWonSlipPayOut,CustomerId,SourceId,BranchId)
select COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount)
,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
,SUM(Archive.Slip.Amount)
,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
,Customer.Customer.CustomerId
,Archive.Slip.SourceId
,Customer.Customer.BranchId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId
Where Archive.Slip.SlipStatu not in (2,4) and Archive.Slip.SlipStateId in (3,5)  and TotalOddValue>1   and Archive.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Archive.Slip.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (CashoutSlipCount,CashOutSlipAmount,OrgCashOutSlipAmount,CustomerId,SourceId,BranchId)
select COUNT(Customer.Slip.SlipId)
, SUM(Customer.SlipCashOut.CashOutValue)
,SUM(Customer.SlipCashOut.CashOutValue)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
,Customer.Customer.BranchId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId 
  INNER JOIN Customer.SlipCashOut ON Customer.SlipCashOut.SlipId=Customer.Slip.SlipId
Where Customer.Slip.SlipStatu not in (2,4) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)<cast(@EndDate as date)
 GROUP BY  Customer.Slip.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId,Customer.Customer.BranchId

  insert @TempSummaryBet (CashoutSlipCount,CashOutSlipAmount,OrgCashOutSlipAmount,CustomerId,SourceId,BranchId)
select COUNT(Archive.Slip.SlipId)
,SUM(Customer.SlipCashOut.CashOutValue)
,SUM(Customer.SlipCashOut.CashOutValue)
,Customer.Customer.CustomerId
,Archive.Slip.SourceId
,Customer.Customer.BranchId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId 
  INNER JOIN Customer.SlipCashOut ON Customer.SlipCashOut.SlipId=Archive.Slip.SlipId
Where Archive.Slip.SlipStatu not in (2,4)   
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)<cast(@EndDate as date)
 GROUP BY  Archive.Slip.CurrencyId,Customer.Customer.CustomerId,Archive.Slip.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (PayOutCount,PayOutAmount,OrgPayOutAmount,CustomerId,SourceId,BranchId)
select COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,SUM(Customer.Slip.Amount*Customer.Slip.TotalOddValue)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
,Customer.Customer.BranchId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId in (3,5)  and Customer.Slip.IsPayOut=1  and Customer.Slip.SlipTypeId<4
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId,Customer.Customer.BranchId


insert @TempSummaryBet (PayOutCount,PayOutAmount,OrgPayOutAmount,CustomerId,SourceId,BranchId)
select COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
,SUM(Archive.Slip.Amount*Archive.Slip.TotalOddValue)
,Customer.Customer.CustomerId
,Archive.Slip.SourceId
,Customer.Customer.BranchId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId
Where Archive.Slip.SlipStatu not in (2,4) and Archive.Slip.SlipStateId in (3,5)  and Archive.Slip.IsPayOut=1 and Archive.Slip.SlipTypeId<4
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Archive.Slip.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (TaxCount,Tax,OrgTax,CustomerId,SourceId,BranchId)
select COUNT(Customer.Tax.SlipId)
,SUM(Customer.Tax.[TaxAmount])
,SUM(Customer.Tax.[TaxAmount])
,Customer.Tax.CustomerId
,Customer.Tax.SourceId
,Customer.Customer.BranchId
From Customer.Tax with (nolock) INNER JOIN Customer.Customer with (nolock) On Customer.Customer.CustomerId=Customer.Tax.CustomerId
Where Customer.Tax.TaxStatusId in (1,3)
and  cast(DATEADD(HOUR,@addhour,Customer.Tax.[CreateDate]) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Tax.[CreateDate]) as date)<cast(@EndDate as date)
GROUP BY Customer.Tax.CurrencyId,Customer.Tax.CustomerId,Customer.Tax.SourceId,Customer.Customer.BranchId


insert @TempSummaryBet (LostSlipCount,LostSlipAmount,OrgLostSlipAmount,CustomerId,SourceId,BranchId)
select COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,SUM(Customer.Slip.Amount)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
,Customer.Customer.BranchId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId=4   and Customer.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (LostSlipCount,LostSlipAmount,OrgLostSlipAmount,CustomerId,SourceId,BranchId)
select COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount)
,SUM(Archive.Slip.Amount)
,Customer.Customer.CustomerId
,Archive.Slip.SourceId
,Customer.Customer.BranchId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId
Where Archive.Slip.SlipStatu not in (2,4) and Archive.Slip.SlipStateId=4  and Archive.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Archive.Slip.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (CancelSlipCount,CancelSlipAmount,OrgCancelSlipAmount,CustomerId,SourceId,BranchId)
select COUNT(Customer.Slip.SlipId)
,SUM(Customer.Slip.Amount)
,SUM(Customer.Slip.Amount)
,Customer.Customer.CustomerId
,Customer.Slip.SourceId
,Customer.Customer.BranchId
From Customer.Slip with (nolock) inner join Customer.Customer with (nolock) on Customer.Slip.CustomerId=Customer.Customer.CustomerId
Where Customer.Slip.SlipStatu not in (2,4) and (Customer.Slip.SlipStateId=2  or (Customer.Slip.SlipStateId=3 and Customer.Slip.TotalOddValue=1)) and Customer.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.Slip.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (CancelSlipCount,CancelSlipAmount,OrgCancelSlipAmount,CustomerId,SourceId,BranchId)
select COUNT(Archive.Slip.SlipId)
,SUM(Archive.Slip.Amount)
,SUM(Archive.Slip.Amount)
,Customer.Customer.CustomerId
,Archive.Slip.SourceId
,Customer.Customer.BranchId
From Archive.Slip with (nolock) inner join Customer.Customer with (nolock) on Archive.Slip.CustomerId=Customer.Customer.CustomerId
Where Archive.Slip.SlipStatu not in (2,4) and (Archive.Slip.SlipStateId=2  or (Archive.Slip.SlipStateId=3 and Archive.Slip.TotalOddValue=1)) and Archive.Slip.SlipTypeId<3
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Archive.Slip.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Archive.Slip.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (CancelSlipCount,CancelSlipAmount,OrgCancelSlipAmount,CustomerId,SourceId,BranchId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,SUM(Customer.SlipSystem.Amount)
,SUM(Customer.SlipSystem.Amount)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
,Customer.Customer.BranchId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where   (Customer.SlipSystem.SlipStateId=2  or (Customer.SlipSystem.SlipStateId=3 and Customer.SlipSystem.TotalOddValue=1))  
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (CancelSlipCount,CancelSlipAmount,OrgCancelSlipAmount,CustomerId,SourceId,BranchId)
select 0
,SUM(Customer.Tax.[TaxAmount])
,SUM(Customer.Tax.[TaxAmount])
,Customer.Tax.CustomerId
,Customer.Tax.SourceId
,Customer.Customer.BranchId
From Customer.Tax with (nolock) INNER JOIN Customer.Customer with (nolock) On Customer.Customer.CustomerId=Customer.Tax.CustomerId
Where Customer.Tax.TaxStatusId in (2)
 and  cast(DATEADD(HOUR,@addhour,Customer.Tax.[CreateDate]) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Tax.[CreateDate]) as date)<cast(@EndDate as date)
GROUP BY Customer.Tax.CurrencyId,Customer.Tax.CustomerId,Customer.Tax.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (SlipCount,SlipAmount,OrgSlipAmount,CustomerId,SourceId,BranchId)
select 0
,SUM(Customer.Tax.[TaxAmount])
,SUM(Customer.Tax.[TaxAmount])
,Customer.Tax.CustomerId
,Customer.Tax.SourceId
,Customer.Customer.BranchId
From Customer.Tax with (nolock) INNER JOIN Customer.Customer with (nolock) On Customer.Customer.CustomerId=Customer.Tax.CustomerId
 
Where Customer.Tax.TaxStatusId in (2)
 and  cast(DATEADD(HOUR,@addhour,Customer.Tax.[CreateDate]) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.Tax.[CreateDate]) as date)<cast(@EndDate as date)
GROUP BY Customer.Tax.CurrencyId,Customer.Tax.CustomerId,Customer.Tax.SourceId,Customer.Customer.BranchId


insert @TempSummaryBet (OpenSlipCount,OpenSlipAmount,OpenSlipPayOut,OrgOpenSlipAmount,OrgOpenSlipPayOut,CustomerId,SourceId,BranchId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,SUM(Customer.SlipSystem.Amount)
,SUM(Customer.SlipSystem.Amount*Customer.SlipSystem.TotalOddValue)
,SUM(Customer.SlipSystem.Amount)
,SUM(Customer.SlipSystem.Amount*Customer.SlipSystem.TotalOddValue)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
,Customer.Customer.BranchId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where Customer.SlipSystem.SlipStatuId not in (2,4) and Customer.SlipSystem.SlipStateId=1  and (Select COUNT(*) from Customer.Slip with (nolock) where Customer.Slip.SlipTypeId=3 and Customer.Slip.SlipId =(Select Min (Customer.SlipSystemSlip.SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=SlipSystemSlip))>0 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.CreateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.CreateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId,Customer.Customer.BranchId

insert @TempSummaryBet (WonSlipCount,WonSlipAmount,WonSlipPayOut,OrgWonSlipAmount,OrgWonSlipPayOut,CustomerId,SourceId,BranchId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,ISNULL((Select SUM(Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.slip.SlipTypeId=3 and  Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.slip.SlipTypeId=3 and Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.slip.SlipTypeId=3 and  Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.slip.SlipTypeId=3 and Customer.Slip.SlipStateId in (3,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
,Customer.Customer.BranchId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where Customer.SlipSystem.SlipStatuId not in (2,4) and Customer.SlipSystem.SlipStateId in (3,5)  and Customer.slipSystem.NewSlipTypeId=3
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,Customer.Customer.BranchId

insert @TempSummaryBet (WonSlipCount,WonSlipAmount,WonSlipPayOut,OrgWonSlipAmount,OrgWonSlipPayOut,CustomerId,SourceId,BranchId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,ISNULL((Select SUM(Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.slip.SlipTypeId=3 and   Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.slip.SlipTypeId=3 and   Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.slip.SlipTypeId=3 and   Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.slip.SlipTypeId=3 and   Archive.Slip.SlipStateId in (3,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip as CS with (nolock) where CS.SystemSlipId=Customer.SlipSystem.SystemSlipId)),0)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
,Customer.Customer.BranchId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where Customer.SlipSystem.SlipStatuId not in (2,4) and Customer.SlipSystem.SlipStateId in (3,5)  and Customer.slipSystem.NewSlipTypeId=3
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,Customer.Customer.BranchId

insert @TempSummaryBet (LostSlipCount,LostSlipAmount,OrgLostSlipAmount,CustomerId,SourceId,BranchId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,SUM(Customer.SlipSystem.Amount)
,SUM(Customer.SlipSystem.Amount)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
,Customer.Customer.BranchId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where Customer.SlipSystem.SlipStatuId not in (2,4) and Customer.SlipSystem.SlipStateId=4 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId,Customer.Customer.BranchId

--Yeni System

insert @TempSummaryBet (SlipCount,SlipAmount,OrgSlipAmount,CustomerId,SourceId,BranchId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,SUM(Customer.SlipSystem.Amount)
,SUM(Customer.SlipSystem.Amount)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
,Customer.Customer.BranchId
From Customer.SlipSystem with (nolock) inner join Customer.Customer  with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where Customer.SlipSystem.SlipStatuId not in (2,4) and  Customer.slipSystem.NewSlipTypeId in (4,5)
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.CreateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.CreateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,Customer.Customer.BranchId

insert @TempSummaryBet (WonSlipCount,WonSlipAmount,WonSlipPayOut,OrgWonSlipAmount,OrgWonSlipPayOut,CustomerId,SourceId,BranchId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,SUM(Customer.SlipSystem.Amount)
,SUM(Customer.SlipSystem.MaxGain)
,SUM(Customer.SlipSystem.Amount)
,SUM(Customer.SlipSystem.MaxGain)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
,Customer.Customer.BranchId
From Customer.SlipSystem with (nolock) inner join Customer.Customer  with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where Customer.SlipSystem.SlipStatuId not in (2,4) and Customer.SlipSystem.SlipStateId in (3,5)  and Customer.slipSystem.NewSlipTypeId in (4,5)
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,Customer.Customer.BranchId

insert @TempSummaryBet (PayOutCount,PayOutAmount,OrgPayOutAmount,CustomerId,SourceId,BranchId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,SUM(Customer.SlipSystem.MaxGain)
,SUM(Customer.SlipSystem.MaxGain)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
,Customer.Customer.BranchId
From Customer.SlipSystem with (nolock) inner join Customer.Customer  with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where Customer.SlipSystem.SlipStatuId not in (2,4) and Customer.SlipSystem.SlipStateId in (3,5)  and Customer.slipSystem.NewSlipTypeId in (4,5) and Customer.slipSystem.IsPayOut=1
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId,Customer.Customer.BranchId

insert @TempSummaryBet (OpenSlipCount,OpenSlipAmount,OpenSlipPayOut,OrgOpenSlipAmount,OrgOpenSlipPayOut,CustomerId,SourceId,BranchId)
select COUNT(Customer.SlipSystem.SystemSlipId)
,SUM(Customer.SlipSystem.Amount)
,SUM(Customer.SlipSystem.MaxGain)
,SUM(Customer.SlipSystem.Amount)
,SUM(Customer.SlipSystem.MaxGain)
,Customer.Customer.CustomerId
,Customer.SlipSystem.SourceId
,Customer.Customer.BranchId
From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
Where Customer.SlipSystem.SlipStatuId not in (2,4) and Customer.SlipSystem.SlipStateId=1 and Customer.slipSystem.NewSlipTypeId in (4,5)   --and (Select COUNT(*) from Customer.Slip with (nolock) where Customer.Slip.SlipTypeId=3 and Customer.Slip.SlipId =(Select Min (Customer.SlipSystemSlip.SlipId) from Customer.SlipSystemSlip where Customer.SlipSystemSlip.SystemSlipId=SlipSystemSlip))>0 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.CreateDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.CreateDate) as date)<cast(@EndDate as date)
GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId,Customer.Customer.BranchId


insert @TempSummaryBet (OnlineDeposit,CustomerId,SourceId,BranchId)
select SUM(Customer.[Transaction].Amount)
,Customer.Customer.CustomerId
,1
,Customer.Customer.BranchId
From Customer.[Transaction] with (nolock) inner join Customer.Customer  with (nolock) on Customer.[Transaction].CustomerId=Customer.Customer.CustomerId
Where Customer.[Transaction].TransactionTypeId in (11,46,67,68,69,70,71,72)
and cast(DATEADD(HOUR,@addhour,Customer.[Transaction].TransactionDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.[Transaction].TransactionDate) as date)<cast(@EndDate as date)
GROUP BY  Customer.Customer.CustomerId ,Customer.Customer.BranchId


insert @TempSummaryBet (OnlineWithDraw,CustomerId,SourceId,BranchId)
select SUM(Customer.[Transaction].Amount)
,Customer.Customer.CustomerId
,1
,Customer.Customer.BranchId
From Customer.[Transaction] with (nolock) inner join Customer.Customer  with (nolock) on Customer.[Transaction].CustomerId=Customer.Customer.CustomerId
Where Customer.[Transaction].TransactionTypeId in (66,73,12)
and cast(DATEADD(HOUR,@addhour,Customer.[Transaction].TransactionDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.[Transaction].TransactionDate) as date)<cast(@EndDate as date)
GROUP BY  Customer.Customer.CustomerId ,Customer.Customer.BranchId

insert @TempSummaryBet (Bonus,CustomerId,SourceId,BranchId)
select SUM(Customer.[Transaction].Amount)
,Customer.Customer.CustomerId
,1
,Customer.Customer.BranchId
From Customer.[Transaction] with (nolock) inner join Customer.Customer  with (nolock) on Customer.[Transaction].CustomerId=Customer.Customer.CustomerId
Where Customer.[Transaction].TransactionTypeId in (35) 
and cast(DATEADD(HOUR,@addhour,Customer.[Transaction].TransactionDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.[Transaction].TransactionDate) as date)<cast(@EndDate as date)
GROUP BY  Customer.Customer.CustomerId ,Customer.Customer.BranchId


insert @TempSummaryBet (WonSlipAll,CustomerId,SourceId,BranchId)
select SUM(Customer.[Transaction].Amount)
,Customer.Customer.CustomerId
,1
,Customer.Customer.BranchId
From Customer.[Transaction] with (nolock) inner join Customer.Customer  with (nolock) on Customer.[Transaction].CustomerId=Customer.Customer.CustomerId
Where Customer.[Transaction].TransactionTypeId in (3,63)
and cast(DATEADD(HOUR,@addhour,Customer.[Transaction].TransactionDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(HOUR,@addhour,Customer.[Transaction].TransactionDate) as date)<cast(@EndDate as date)
GROUP BY  Customer.Customer.CustomerId ,Customer.Customer.BranchId

--insert @TempSummaryBet (WonSlipCount,WonSlipAmount,WonSlipPayOut,OrgWonSlipAmount,OrgWonSlipPayOut,CustomerId,SourceId)
--select COUNT(Customer.SlipSystem.SystemSlipId)
--,SUM(Customer.SlipSystem.Amount)
--,SUM(Customer.SlipSystem.MaxGain)
--,SUM(Customer.SlipSystem.Amount)
--,SUM(Customer.SlipSystem.MaxGain)
--,Customer.Customer.CustomerId
--,Customer.SlipSystem.SourceId
--From Customer.SlipSystem with (nolock) inner join Customer.Customer with (nolock) on Customer.SlipSystem.CustomerId=Customer.Customer.CustomerId
--Where Customer.SlipSystem.SlipStatuId not in (2,4) and Customer.SlipSystem.SlipStateId in (3,5)  and (Select COUNT(*) from Archive.Slip with (nolock) where Archive.Slip.SlipTypeId in (4,5) and Archive.Slip.SlipId =(Select Min (Customer.SlipSystemSlip.SlipId) from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId))>0
--and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)>=cast(@StartDate as date) 
--and cast(DATEADD(HOUR,@addhour,Customer.SlipSystem.EvaluateDate) as date)<cast(@EndDate as date)
--GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId,Customer.SlipSystem.SourceId,Customer.SlipSystem.SystemSlipId

IF EXISTS (select  [BettingReport].Report.SummarySportBetting.SummarySportBettingId from  [BettingReport].Report.SummarySportBetting where  [BettingReport].Report.SummarySportBetting.ReportDate=@StartDate)
		delete from [BettingReport].Report.SummarySportBetting where ReportDate=@StartDate

insert [BettingReport].Report.SummarySportBetting
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
,1
,SUM(ISNULL(OnlineDeposit,0))
,SUM(ISNULL(OnlineWithDraw,0)),BranchId,SUM(ISNULL(Bonus,0)),SUM(ISNULL(WonSlipAll,0))
from @TempSummaryBet
GROUP BY CustomerId,SourceId,BranchId



if(@@ROWCOUNT=0)
begin
insert [BettingReport].Report.SummarySportBetting (ReportDate,CustomerId)
select @StartDate,1000

end



end

END




GO
