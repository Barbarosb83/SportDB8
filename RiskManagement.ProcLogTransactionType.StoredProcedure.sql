USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcLogTransactionType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [RiskManagement].[ProcLogTransactionType] 


AS


 Select Log.TransactionType.TransactionTypeId,Log.TransactionType.TransactionType
 from Log.TransactionType



GO
