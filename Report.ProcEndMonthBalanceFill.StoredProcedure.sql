USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Report].[ProcEndMonthBalanceFill]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [Report].[ProcEndMonthBalanceFill] 
AS

BEGIN
SET NOCOUNT ON;


INSERT INTO [Report].[EndMonthBalance]
           ([CustomerId]
           ,[BranchId]
           ,[Balance]
           ,[CreateDate])
		   select CustomerId,BranchId,Balance,GETDATE() 
		   from Customer.Customer where BranchId not in (32643,1 )


END
GO
