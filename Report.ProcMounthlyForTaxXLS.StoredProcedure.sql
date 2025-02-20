USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcMounthlyForTaxXLS]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Report].[ProcMounthlyForTaxXLS] 
 @BranchId bigint,
 @StartDate datetime,
 @EndDate datetime
AS

BEGIN
SET NOCOUNT ON;
 
 declare @temptable table (CustomerName nvarchar(250),CustomerId bigint,Amount money,Tax money,PayOutDate datetime)

 insert @temptable
	select CustomerName+' '+CustomerSurname,Customer.CustomerId,Customer.slip.Amount,Customer.tax.TaxAmount,Customer.slip.EvaluateDate
	from Customer.Customer with (nolock) INNER JOIN Customer.Slip with (nolock) On Customer.CustomerId=Customer.Slip.CustomerId INNER JOIN Customer.Tax with (nolock)
	On Customer.Tax.CustomerId=Customer.Slip.CustomerId and Customer.Tax.SlipId=Customer.Slip.SlipId
	where BranchId=@BranchId and cast(Customer.slip.EvaluateDate as date)>=@StartDate and cast(Customer.slip.EvaluateDate as date)<=@EndDate and SlipStateId in (3,7)
 
  insert @temptable
	select CustomerName+' '+CustomerSurname,Customer.CustomerId,Archive.slip.Amount,Customer.tax.TaxAmount,Archive.slip.EvaluateDate
	from Customer.Customer with (nolock) INNER JOIN Archive.Slip with (nolock) On Customer.CustomerId=Archive.Slip.CustomerId INNER JOIN Customer.Tax with (nolock)
	On Customer.Tax.CustomerId=Archive.Slip.CustomerId and Customer.Tax.SlipId=Archive.Slip.SlipId
	where BranchId=@BranchId and cast(Archive.slip.EvaluateDate as date)>=@StartDate and cast(Archive.slip.EvaluateDate as date)<=@EndDate and SlipStateId in (3,7)

 insert @temptable
	select CustomerName+' '+CustomerSurname,Customer.CustomerId,Customer.SlipSystem.Amount,Customer.tax.TaxAmount,Customer.SlipSystem.EvaluateDate
	from Customer.Customer with (nolock) INNER JOIN Customer.SlipSystem with (nolock) On Customer.CustomerId=Customer.SlipSystem.CustomerId INNER JOIN Customer.Tax with (nolock)
	On Customer.Tax.CustomerId=Customer.SlipSystem.CustomerId and Customer.Tax.SlipId=Customer.SlipSystem.SystemSlipId
	where BranchId=@BranchId and cast(Customer.SlipSystem.EvaluateDate as date)>=@StartDate and cast(Customer.SlipSystem.EvaluateDate as date)<=@EndDate and SlipStateId in (3,7)
 
 

 select * from @temptable


END



GO
