USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcMounthlyXLS]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Report].[ProcMounthlyXLS] 
 @BranchId bigint,
 @StartDate datetime,
 @EndDate datetime
AS

BEGIN
SET NOCOUNT ON;
 

	select ReportDate,'MKD' as Currency,SUM(WonSlipAmount) as PayIn,SUM(WonSlipPayOut) as PayOutWinning,SUM(Tax) as TAX,SUM(WonSlipPayOut)-SUM(Tax) as PayOut,SUM(WonSlipAmount)-SUM(WonSlipPayOut) as Neto 
	from BettingReport.Report.SummarySportBetting with (nolock) where BranchId=@BranchId and ReportDate>=@StartDate and ReportDate<=@EndDate
	GROUP by ReportDate


END



GO
