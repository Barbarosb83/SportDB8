USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [RiskManagement].[ProcBranchOne]
@BranchId int


AS




BEGIN
SET NOCOUNT ON;



Select Parameter.Branch.BranchId,Parameter.Branch.BrancName,Parameter.Branch.Balance
,Parameter.Branch.CommisionRate
,Parameter.Branch.CreateDate
,Parameter.Branch.IsActive,Parameter.Branch.CurrencyId,
Parameter.Branch.BranchCommisionTypeId,
Parameter.Branch.IsBonusDeducting,Parameter.Branch.MaxCopySlip,Parameter.Branch.MaxWinningLimit,
Parameter.Branch.MinTicketLimit,
Parameter.Branch.MaxEventForTicket
,Parameter.Branch.ParentBranchId
,Parameter.Branch.IsWebPos
from Parameter.Branch
where Parameter.Branch.BranchId=@BranchId

END



GO
