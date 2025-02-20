USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBankAccount]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcCustomerBankAccount] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;

SELECT Customer.Account.CustomerAccountId
,Customer.Account.AccountNo
,Customer.Account.BranchCode
,Customer.Account.CustomerId
,Customer.Account.IBAN 
,Parameter.Bank.BankId
,Parameter.Bank.Bank
,Parameter.AccountType.AccountType
,Parameter.AccountType.AccountTypeId
from Customer.Account with (nolock)  INNER JOIN Parameter.Bank with (nolock) ON
Customer.Account.ParameterBankId=Parameter.Bank.BankId INNER JOIN
Parameter.AccountType ON Customer.Account.AccountTypeId=Parameter.AccountType.AccountTypeId
where Customer.Account.CustomerId=@CustomerId




END




GO
