USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchValueCommissionOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcBranchValueCommissionOne]
@BranchValueCommissionId int,
@Username nvarchar(50),
@LangId int


AS




BEGIN
SET NOCOUNT ON;


select 0 as totalrow, RiskManagement.BranchValueCommission.BranchValueCommissionId,RiskManagement.BranchValueCommission.Value1
,RiskManagement.BranchValueCommission.Value2
,RiskManagement.BranchValueCommission.CommissionRate
,RiskManagement.BranchValueCommission.BetTypeId
,Parameter.BetType.BetType
from RiskManagement.BranchValueCommission INNER JOIN
Parameter.BetType on Parameter.BetType.BetTypeId=RiskManagement.BranchValueCommission.BetTypeId
where RiskManagement.BranchValueCommission.BranchValueCommissionId=@BranchValueCommissionId


END


GO
