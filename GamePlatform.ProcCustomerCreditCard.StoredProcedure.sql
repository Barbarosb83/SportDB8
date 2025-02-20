USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerCreditCard]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcCustomerCreditCard] 
@CustomerId bigint
AS

BEGIN
SET NOCOUNT ON;

SELECT Customer.CreditCard.CreditCardId
,Customer.CreditCard.CardNumber
,Customer.CreditCard.CVCNo
,Customer.CreditCard.ExpriedDate
,Customer.CreditCard.IsApproved
,customer.CreditCard.ApprovedComment 
,Parameter.Bank.BankId
,Parameter.Bank.Bank
from Customer.CreditCard  INNER JOIN Parameter.Bank ON
Customer.CreditCard.ParameterBankId=Parameter.Bank.BankId
where Customer.CreditCard.CustomerId=@CustomerId




END




GO
