USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTransactionTypeCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcTransactionTypeCombo] 
@username nvarchar(max),
@LangId int


AS


 Select Parameter.TransactionType.TransactionTypeId,Parameter.TransactionType.TransactionType
 from Parameter.TransactionType
 where Parameter.TransactionType.TransactionTypeId in (1,2)


GO
