USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcPendingTaskBranchDepositRequest]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Dashboard].[ProcPendingTaskBranchDepositRequest] 
@BranchId int
AS

BEGIN
SET NOCOUNT ON;



select ISNULL(COUNT(  RiskManagement.BranchDepositRequest.BranchDepositId),0) 
FROM    RiskManagement.BranchDepositRequest with (nolock)
WHERE   RiskManagement.BranchDepositRequest.IsApproved is null and BranchId in 
(select BranchId from Parameter.Branch where ParentBranchId=@BranchId)


END



GO
