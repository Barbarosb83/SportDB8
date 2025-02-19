USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcBranchTranTypeCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[ProcBranchTranTypeCombo] 

AS

BEGIN
SET NOCOUNT ON;

select 0 as BranchTransactionTypeId,'' as TransactionType
UNION ALL
select Parameter.TransactionTypeBranch.BranchTransactionTypeId,Language.[Parameter.TransactionTypeBranch].TransactionType from Parameter.TransactionTypeBranch INNER JOIN Language.[Parameter.TransactionTypeBranch]
On Parameter.TransactionTypeBranch.BranchTransactionTypeId=Language.[Parameter.TransactionTypeBranch].BranchTransactionTypeId and Language.[Parameter.TransactionTypeBranch].LanguageId=6


END





GO
