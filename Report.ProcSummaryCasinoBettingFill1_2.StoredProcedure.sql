USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcSummaryCasinoBettingFill1_2]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Report].[ProcSummaryCasinoBettingFill1_2] 
AS

BEGIN
SET NOCOUNT ON;


declare @StartDate date
declare @EndDate date

select top 1 @StartDate =ISNULL(Report.SummaryCasinoBetting2.ReportDate,DATEADD(DAY,-1,GETDATE())) from Report.SummaryCasinoBetting2 
order by  Report.SummaryCasinoBetting2.ReportDate desc


	set @StartDate=GETDATE()


set @EndDate=DATEADD(DAY,1,@StartDate)


IF EXISTS (select  Report.SummaryCasinoBetting2.SummaryCasinoBettingId from  Report.SummaryCasinoBetting2 where  Report.SummaryCasinoBetting2.ReportDate=@StartDate)
		delete from Report.SummaryCasinoBetting2 where ReportDate=@StartDate

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
OrgSlipAmount money,
OrgOpenSlipAmount money,
OrgOpenSlipPayOut money,
OrgWonSlipAmount money,
OrgWonSlipPayOut money,
OrgLostSlipAmount money,
OrgCancelSlipAmount money
)

select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 

insert @TempSummaryBet (SlipCount,SlipAmount,OrgSlipAmount,CustomerId)
select COUNT(Customer.[Transaction].TransactionId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@SystemCurrencyId) ,0)
,ISNULL(SUM(Customer.[Transaction].Amount) ,0)
,Customer.Customer.CustomerId
From Customer.[Transaction] INNER JOIN Customer.Customer ON Customer.[Transaction].CustomerId=Customer.Customer.CustomerId
Where Customer.[Transaction].TransactionTypeId  in (39,43) 
and cast(DATEADD(MINUTE,180,Customer.[Transaction].TransactionDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(MINUTE,180,Customer.[Transaction].TransactionDate) as date)<cast(@EndDate as date)
GROUP BY Customer.[Transaction].CurrencyId,Customer.Customer.CustomerId





insert @TempSummaryBet (WonSlipCount,WonSlipAmount,OrgWonSlipAmount,CustomerId)
select COUNT(Customer.[Transaction].TransactionId)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.[Transaction].Amount),Customer.[Transaction].CurrencyId,@SystemCurrencyId) ,0)
,ISNULL(SUM(Customer.[Transaction].Amount) ,0)
,Customer.Customer.CustomerId
From Customer.[Transaction] INNER JOIN Customer.Customer ON Customer.[Transaction].CustomerId=Customer.Customer.CustomerId
Where Customer.[Transaction].TransactionTypeId  in (38,42) 
and cast(DATEADD(MINUTE,180,Customer.[Transaction].TransactionDate) as date)>=cast(@StartDate as date) 
and cast(DATEADD(MINUTE,180,Customer.[Transaction].TransactionDate) as date)<cast(@EndDate as date)
GROUP BY Customer.[Transaction].CurrencyId,Customer.Customer.CustomerId

insert @TempSummaryBet (LostSlipCount,LostSlipAmount,OrgLostSlipAmount,CustomerId)
select COUNT(SlipCount)-COUNT(WonSlipCount), ISNULL(SUM(ISNULL(SlipAmount,0)),0)-ISNULL(SUM(WonSlipAmount),0)
,ISNULL(SUM(ISNULL(OrgSlipAmount,0)),0)-ISNULL(SUM(OrgWonSlipAmount),0)
, CustomerId
From @TempSummaryBet 
GROUP BY  CustomerId

--insert @TempSummaryBet (CancelSlipCount,CancelSlipAmount,CustomerId)
--select COUNT(Customer.Slip.SlipId),ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Slip.Amount),Customer.Customer.CurrencyId,@SystemCurrencyId) ,0),Customer.Customer.CustomerId
--From Customer.Slip inner join Customer.Customer on Customer.Slip.CustomerId=Customer.Customer.CustomerId
--Where Customer.Slip.SlipStatu not in (2,4) and Customer.Slip.SlipStateId=2 
--and cast(Customer.Slip.EvaluateDate as date)>=cast(@StartDate as date) 
--and cast(Customer.Slip.EvaluateDate as date)<cast(@EndDate as date)
--GROUP BY Customer.Customer.CurrencyId,Customer.Customer.CustomerId


IF EXISTS (select  Report.SummaryCasinoBetting2.SummaryCasinoBettingId from  Report.SummaryCasinoBetting2 where  Report.SummaryCasinoBetting2.ReportDate=@StartDate)
		delete from Report.SummaryCasinoBetting2 where ReportDate=@StartDate

insert Report.SummaryCasinoBetting2
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
,0
,SUM(ISNULL(OrgSlipAmount,0))
,0
,0
,SUM(ISNULL(OrgWonSlipAmount,0))
,0
,SUM(ISNULL(OrgLostSlipAmount,0))
,0
from @TempSummaryBet
GROUP BY CustomerId


IF  (select  COUNT(Report.SummaryCasinoBetting2.SummaryCasinoBettingId) from  Report.SummaryCasinoBetting2 where  Report.SummaryCasinoBetting2.ReportDate=@StartDate)=0
begin
insert Report.SummaryCasinoBetting2 
select @StartDate,0,0,0,0,0,0,0,0,0,0,0,0,1000,0
,0
,0
,0
,0
,0
,0
,0

end




END






GO
