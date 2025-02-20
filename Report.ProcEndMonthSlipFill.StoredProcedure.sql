USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcEndMonthSlipFill]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [Report].[ProcEndMonthSlipFill] 
AS

BEGIN
SET NOCOUNT ON;


INSERT INTO [Report].[EndMonthSlip]
           ([SlipId]
           ,[CustomerId]
           ,[Amount]
           ,[BranchId]
           ,[CreateDate])
		   select SlipId,Customer.Slip.CustomerId,Amount*TotalOddValue,BranchId,GETDATE() from Customer.Slip 
INNER JOIN Customer.Customer
On Customer.Slip.CustomerId=Customer.CustomerId
where SlipStateId in (2,3,5) and SlipTypeId<3 and IsPayOut=0 


INSERT INTO [Report].[EndMonthSlip]
           ([SlipId]
           ,[CustomerId]
           ,[Amount]
           ,[BranchId]
           ,[CreateDate])
select SlipId,Customer.CustomerId,Amount*TotalOddValue,BranchId,GETDATE() from Archive.Slip 
INNER JOIN Customer.Customer
On Archive.Slip.CustomerId=Customer.CustomerId
where SlipStateId in (2,3,5) and SlipTypeId<3 and IsPayOut=0


		   
INSERT INTO [Report].[EndMonthSlip]
           ([SlipId]
           ,[CustomerId]
           ,[Amount]
           ,[BranchId]
           ,[CreateDate])
select SystemSlipId,Customer.CustomerId,MaxGain,BranchId,GETDATE() from Customer.SlipSystem 
INNER JOIN Customer.Customer
On Customer.SlipSystem.CustomerId=Customer.CustomerId
where SlipStateId in (2,3,5) and  IsPayOut=0

END
GO
