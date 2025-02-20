USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcDailyXML2]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Report].[ProcDailyXML2] 
 @BranchId bigint,
 @StartDate datetime,
 @EndDate datetime
AS

BEGIN
SET NOCOUNT ON;
 

 select Customer.Customer.CustomerId,CustomerName,CustomerSurname,ZipCode as Manicipalitycode,'T9' as code,'9002' as subcode,0 as grossIncome,2 as ptpCode,'' as bankaccount
 ,Customer.Slip.CreateDate as PaymentDate 
 from Customer.Customer with (nolock) INNER JOIN Customer.Slip with (nolock) On Customer.Customer.CustomerId=Customer.Slip.CustomerId 
 --and Customer.Slip.SlipStateId in (3,7) 
 --and Customer.Slip.IsPayOut=1 
 and cast(Customer.Slip.CreateDate as date)>=cast(@StartDate as date) 
 --and  cast(EvaluateDate as date)<=cast('20211112' as date) 
 and Customer.Customer.BranchId=@BranchId
 	


END



GO
