USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Parameter].[ProcParameterBankAcountOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Parameter].[ProcParameterBankAcountOne]
@BankAcountId int
AS

BEGIN
SET NOCOUNT ON;

select Parameter.BankAccount.AccountNo
,Parameter.BankAccount.BankAccountId
,Parameter.BankAccount.BankId
,Parameter.BankAccount.BranchCode
,Parameter.BankAccount.CreateDate
,Parameter.BankAccount.IBAN
,Parameter.BankAccount.IsActive
,Parameter.BankAccount.Name
,Parameter.BankAccount.Surname 
,Parameter.Bank.Bank
from Parameter.BankAccount INNER JOIN
Parameter.Bank ON Parameter.Bank.BankId=Parameter.BankAccount.BankId
where Parameter.BankAccount.BankAccountId=@BankAcountId



END


GO
