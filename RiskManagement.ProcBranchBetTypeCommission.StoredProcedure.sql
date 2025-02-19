USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchBetTypeCommission]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcBranchBetTypeCommission]
@BranchId int,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int


AS




BEGIN
SET NOCOUNT ON;


select 0 as totalrow, BranchBetTypeCommisionId,BranchId,RiskManagement.BranchBetTypeCommision.BetTypeId,CommissionRate,
Parameter.BetType.BetType
from RiskManagement.BranchBetTypeCommision 
INNER JOIN Parameter.BetType ON Parameter.BetType.BetTypeId=RiskManagement.BranchBetTypeCommision.BetTypeId
where RiskManagement.BranchBetTypeCommision.BranchId=@BranchId


END


GO
