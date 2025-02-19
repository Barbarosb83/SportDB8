USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboBranch]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcComboBranch]



AS




BEGIN
SET NOCOUNT ON;


select Parameter.Branch.BranchId,Parameter.Branch.BrancName as BranchName from Parameter.Branch where IsTerminal=0 order by BranchName

END


GO
