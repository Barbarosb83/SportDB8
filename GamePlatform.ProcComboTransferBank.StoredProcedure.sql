USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcComboTransferBank]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcComboTransferBank] 
@LanguageId int
AS

BEGIN
SET NOCOUNT ON;

SELECT     Parameter.Bank.BankId, Parameter.Bank.Bank
FROM         Parameter.Bank INNER JOIN
                      Parameter.BankAccount ON Parameter.Bank.BankId = Parameter.BankAccount.BankId

END


GO
