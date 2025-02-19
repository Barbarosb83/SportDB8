USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcComboDepositType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcComboDepositType]
@LangId int


AS




BEGIN
SET NOCOUNT ON;
SELECT TransactionTypeId
      ,TransactionType
  FROM [Parameter].TransactionType where Direction=1 and TransactionTypeId not in (1,3,5,7,8,13,17,19,21,23,25,27,29,32,34,35,36,38,40,42,44,46,51,52,54,59,63,64) and IsActive=1

END



GO
