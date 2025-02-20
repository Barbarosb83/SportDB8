USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcComboTransactionType]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcComboTransactionType] 
@LangId int
AS

BEGIN
SET NOCOUNT ON;

SELECT     Parameter.TransactionType.TransactionTypeId, Language.[Parameter.TransactionType].TransactionType
FROM         Parameter.TransactionType INNER JOIN
                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId
Where Language.[Parameter.TransactionType].LanguageId=@LangId  and Language.[Parameter.TransactionType].TransactionTypeId  in (1,2,63,35) 
and Parameter.TransactionType.IsActive=1



END


GO
