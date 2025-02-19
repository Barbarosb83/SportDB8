USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcPendingTaskWithDrawRequest]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Dashboard].[ProcPendingTaskWithDrawRequest] 

AS

BEGIN
SET NOCOUNT ON;



select ISNULL(COUNT( RiskManagement.WithdrawRequest.WithdrawRequestId),0) 
FROM    RiskManagement.WithdrawRequest   with (nolock) 
WHERE  RiskManagement.WithdrawRequest.IsApproved is null


END


GO
