USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcSummaryTaxFill]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Report].[ProcSummaryTaxFill] 
AS

BEGIN
SET NOCOUNT ON;


declare @StartDate date
declare @EndDate date

select top 1 @StartDate =ISNULL(Report.SummaryTax.ReportDate,DATEADD(DAY,-1,GETDATE())) from Report.SummaryTax 
order by  Report.SummaryTax.ReportDate desc

if(@StartDate is null)
	set @StartDate=DATEADD(DAY,1,GETDATE())

	set @StartDate=DATEADD(DAY,-1,@StartDate)

if(@StartDate>=GETDATE())
	set @StartDate=GETDATE()


set @EndDate=DATEADD(DAY,1,@StartDate)


IF EXISTS (select  Report.SummaryTax.ReportTaxId from  Report.SummaryTax where  Report.SummaryTax.ReportDate=@StartDate)
		delete from Report.SummaryTax where ReportDate=@StartDate

declare @ReportDate date

declare @SystemCurrencyId int

declare @TempSummaryBet table (
SlipCount int,
TaxAmount money,
SlipAmount money,
TotalAmount money,
CustomerId bigint
)

select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 

insert @TempSummaryBet (SlipCount,TaxAmount,CustomerId,SlipAmount,TotalAmount)
select COUNT(Customer.Tax.TaxId),ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Tax.TaxAmount),Customer.Tax.CurrencyId,@SystemCurrencyId) ,0),Customer.Tax.CustomerId
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Tax.SlipAmount),Customer.Tax.CurrencyId,@SystemCurrencyId) ,0)
,ISNULL(dbo.FuncCurrencyConverter(SUM(Customer.Tax.TotalAmount),Customer.Tax.CurrencyId,@SystemCurrencyId) ,0)
From Customer.Tax
Where Customer.Tax.TaxStatusId=3
and cast(Customer.Tax.CreateDate as date)>=cast(@StartDate as date) 
and cast(Customer.Tax.CreateDate as date)<cast(@EndDate as date)
GROUP BY Customer.Tax.CurrencyId,Customer.Tax.CustomerId



IF EXISTS (select  Report.SummaryCasinoBetting.SummaryCasinoBettingId from  Report.SummaryCasinoBetting where  Report.SummaryCasinoBetting.ReportDate=@StartDate)
		delete from Report.SummaryCasinoBetting where ReportDate=@StartDate

insert [Report].[SummaryTax]
select @StartDate,CustomerId,SUM(ISNULL(SlipCount,0))
,SUM(ISNULL(TotalAmount,0))
,SUM(ISNULL(SlipAmount,0))
,SUM(ISNULL(TaxAmount,0))
from @TempSummaryBet
GROUP BY CustomerId


if(@@ROWCOUNT=0)
begin
insert [Report].[SummaryTax] (ReportDate,CustomerId,TaxAmount,SlipCount,SlipAmount,TotalAmount)
select @StartDate,1001,0,0,0,0

end




END




GO
