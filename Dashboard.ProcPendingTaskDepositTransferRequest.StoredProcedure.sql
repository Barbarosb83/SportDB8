USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcPendingTaskDepositTransferRequest]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Dashboard].[ProcPendingTaskDepositTransferRequest] 

AS

BEGIN
SET NOCOUNT ON;



select ISNULL(COUNT( Customer.DepositTransfer.DepositTransferId),0) 
FROM    Customer.DepositTransfer  with (nolock)  
WHERE  Customer.DepositTransfer.DepositStatuId =1


END


GO
