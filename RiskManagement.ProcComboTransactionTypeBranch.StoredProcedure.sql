USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboTransactionTypeBranch]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcComboTransactionTypeBranch]



AS




BEGIN
SET NOCOUNT ON;


select Parameter.TransactionTypeBranch.BranchTransactionTypeId
,Parameter.TransactionTypeBranch.TransactionType from Parameter.TransactionTypeBranch

END


GO
