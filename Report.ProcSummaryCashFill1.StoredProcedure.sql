USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcSummaryCashFill1]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Report].[ProcSummaryCashFill1] 
AS

BEGIN
SET NOCOUNT ON;


declare @StartDate date
declare @EndDate date
declare @SystemCurrencyId int

	set @StartDate=GETDATE()


set @EndDate=DATEADD(DAY,1,@StartDate)

select top 1 @SystemCurrencyId=SystemCurrencyId from General.Setting 

IF EXISTS (select  Report.SummaryCash.SummaryCashId from  Report.SummaryCash where  Report.SummaryCash.ReportDate=@StartDate)
		delete from Report.SummaryCash where ReportDate=@StartDate

insert Report.SummaryCash 
select @StartDate
,Customer.[Transaction].TransactionTypeId
,ISNULL( SUM(Customer.[Transaction].Amount) ,0)
,Customer.[Transaction].CustomerId
FROM Customer.[Transaction]
where   DATEADD(MINUTE,60,Customer.[Transaction].TransactionDate)>=@StartDate 
and DATEADD(MINUTE,60,Customer.[Transaction].TransactionDate)<@EndDate 
GROUP BY cast(Customer.[Transaction].TransactionDate as date)
,Customer.[Transaction].TransactionTypeId
,Customer.[Transaction].CustomerId

if(@@ROWCOUNT=0)
begin
insert Report.SummaryCash (ReportDate)
select @StartDate

end

END


GO
