USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchBetTypeCommissionOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcBranchBetTypeCommissionOne]
@BranchBetTypeCommissionId int,
@Username nvarchar(50),
@LangId int


AS




BEGIN
SET NOCOUNT ON;


select 0 as totalrow, BranchBetTypeCommisionId,BranchId,BetTypeId,CommissionRate
from RiskManagement.BranchBetTypeCommision 
where RiskManagement.BranchBetTypeCommision.BranchBetTypeCommisionId=@BranchBetTypeCommissionId

END


GO
