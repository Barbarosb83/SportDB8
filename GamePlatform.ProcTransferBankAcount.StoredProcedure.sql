USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTransferBankAcount]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcTransferBankAcount] 
@BankId int
AS

BEGIN
SET NOCOUNT ON;

SELECT  TOP 1   Parameter.BankAccount.IBAN, Name+' '+Surname as AcountName
FROM    Parameter.BankAccount 
where IsActive=1 and BankId=@BankId
ORDER BY NEWID()



END


GO
