USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerCreditCardRequest]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcCustomerCreditCardRequest]
@PageSize  INT,
@PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)


AS




BEGIN
SET NOCOUNT ON;

declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)


--SELECT   0 As totalrow,Customer.CreditCard.CreditCardId, Customer.CreditCard.CustomerId, Customer.CreditCard.CardNumber, 
--                      Customer.CreditCard.CVCNo, Customer.CreditCard.ExpriedDate,
--                      Customer.CreditCard.ApprovedComment, Customer.CreditCard.ApprovedDate
--                     ,Parameter.Bank.Bank, 
--                      Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname AS CustomerName, 
--                      Users.Users.Name + ' ' + Users.Users.Surname AS UserName,customer.creditcard.ApprovedUserId,
--					  Customer.CreditCard.IsApproved
--FROM         Customer.CreditCard INNER JOIN
--                      Parameter.Bank ON Customer.CreditCard.ParameterBankId = Parameter.Bank.BankId INNER JOIN
--                      Customer.Customer ON Customer.CreditCard.CustomerId = Customer.Customer.CustomerId LEFT OUTER JOIN
--                      Users.Users ON Customer.CreditCard.ApprovedUserId = Users.Users.UserId





set @sqlcommand='declare @total int '+
'select @total=COUNT(Customer.CreditCard.CreditCardId) '+
'FROM       Customer.CreditCard INNER JOIN
                      Parameter.Bank ON Customer.CreditCard.ParameterBankId = Parameter.Bank.BankId INNER JOIN
                      Customer.Customer ON Customer.CreditCard.CustomerId = Customer.Customer.CustomerId LEFT OUTER JOIN
                      Users.Users ON Customer.CreditCard.ApprovedUserId = Users.Users.UserId '+
'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '
set @sqlcommand2= '	Customer.CreditCard.CreditCardId, Customer.CreditCard.CustomerId, Customer.CreditCard.CardNumber, 
                      Customer.CreditCard.CVCNo, Customer.CreditCard.ExpriedDate,
                      Customer.CreditCard.ApprovedComment, Customer.CreditCard.ApprovedDate
                     ,Parameter.Bank.Bank, 
                      Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname AS CustomerName, 
                      Users.Users.Name + '' '' + Users.Users.Surname AS UserName,customer.creditcard.ApprovedUserId,
					  Customer.CreditCard.IsApproved '+
'FROM       Customer.CreditCard INNER JOIN
                      Parameter.Bank ON Customer.CreditCard.ParameterBankId = Parameter.Bank.BankId INNER JOIN
                      Customer.Customer ON Customer.CreditCard.CustomerId = Customer.Customer.CustomerId LEFT OUTER JOIN
                      Users.Users ON Customer.CreditCard.ApprovedUserId = Users.Users.UserId '+
'WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand+@sqlcommand2)                   

END




GO
