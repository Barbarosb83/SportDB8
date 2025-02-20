USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerTransOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCustomerTransOne] 
@CustomerId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;




select   top 1 Customer.[Transaction].TransactionId,Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, Customer.[Transaction].TransactionComment, Customer.[Transaction].Amount, 
                      Customer.[Transaction].CurrencyId, Parameter.Currency.Sybol as Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
                      Language.[Parameter.TransactionType].TransactionType,
					  case when Parameter.[TransactionType].Direction=1 THEN case when Customer.[Transaction].TransactionTypeId<>4 then 1 ELSE 3 end Else 3 end as statucolor, case when Customer.[Transaction].TransactionTypeId=4 or Customer.[Transaction].TransactionTypeId=48  then Substring(TransactionComment, Charindex('-', TransactionComment)+1, LEN(TransactionComment)) 
                      else TransactionComment end as SlipId,
					  Customer.Balance
FROM         Parameter.TransactionType INNER JOIN
                      Customer.[Transaction] ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
                      Parameter.TransactionSource ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
                      Parameter.Currency ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId INNER JOIN
					  Customer.Customer ON Customer.Customer.CustomerId=Customer.[Transaction].CustomerId
WHERE     (Customer.[Transaction].CustomerId = @CustomerId) and Customer.[Transaction].TransactionTypeId in (1,2)   and  Language.[Parameter.TransactionType].LanguageId=@LangId 
 order by Customer.[Transaction].TransactionId desc -- and  Parameter.TransactionType.TransactionTypeId =@TypeId     








END




GO
