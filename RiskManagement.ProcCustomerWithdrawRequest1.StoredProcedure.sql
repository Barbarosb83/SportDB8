USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerWithdrawRequest1]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcCustomerWithdrawRequest1]
@PageSize  INT,
@PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)


AS




BEGIN
SET NOCOUNT ON;

declare @sqlcommand nvarchar(max)

--declare @total int 


--select @total=COUNT(RiskManagement.WithdrawRequest.WithdrawRequestId) 
--FROM         RiskManagement.WithdrawRequest INNER JOIN 
--                      Customer.Customer ON RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId INNER JOIN 
--                      Parameter.Currency ON RiskManagement.WithdrawRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN 
--                      Parameter.TransactionType ON RiskManagement.WithdrawRequest.TransactionType = Parameter.TransactionType.TransactionTypeId LEFT OUTER JOIN 
--                      Parameter.Bank ON RiskManagement.WithdrawRequest.BankId = Parameter.Bank.BankId LEFT OUTER JOIN 
--                      Users.Users ON RiskManagement.WithdrawRequest.Approved1UserId = Users.Users.UserId 
--WHERE (1 = 1) ;
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY RiskManagement.WithdrawRequest.WithdrawRequestId) AS RowNum, 
--	RiskManagement.WithdrawRequest.WithdrawRequestId, Customer.Customer.CustomerId, 
--                      Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname AS Customer, dbo.UserTimeZoneDate('Administrator', RiskManagement.WithdrawRequest.RequestDate,0) as RequestDate, 
--                      RiskManagement.WithdrawRequest.Amount, RiskManagement.WithdrawRequest.CurrencyId, Parameter.Currency.Currency, Customer.Customer.Balance, 
--                      Parameter.Currency.Sybol, Parameter.TransactionType.TransactionTypeId, Parameter.TransactionType.TransactionType, 
--                      RiskManagement.WithdrawRequest.IsApproved1, Customer.Customer.Username, Users.Users.UserId, Users.Users.UserName AS UserName1, Users.Users.Name, 
--                      Users.Users.Surname,dbo.UserTimeZoneDate('Administrator',  RiskManagement.WithdrawRequest.Approved1Date,0) as ApprovedDate, RiskManagement.WithdrawRequest.TransactionCode, 
--                      RiskManagement.WithdrawRequest.AccountId, RiskManagement.WithdrawRequest.BankId, RiskManagement.WithdrawRequest.CustomerNote, 
--                      Parameter.Bank.Bank,case when (select COUNT(Customer.[Transaction].TransactionId) from Customer.[Transaction] where Customer.[Transaction].CustomerId=Customer.Customer.CustomerId and Customer.[Transaction].TransactionTypeId=35 
--					  and Customer.[Transaction].TransactionDate<=ISNULL((select top 1 RiskManagement.WithdrawRequest.Approved1Date from RiskManagement.WithdrawRequest where RiskManagement.WithdrawRequest.CustomerId=Customer.Customer.CustomerId and RiskManagement.WithdrawRequest.TransactionType=31 order by RiskManagement.WithdrawRequest.Approved1Date desc),GETDATE()) )>0 
--					  then 'Yes' else 'No' end as IsBonus,case when (select COUNT(Customer.[Transaction].TransactionId) from Customer.[Transaction] where Customer.[Transaction].CustomerId=Customer.Customer.CustomerId and Customer.[Transaction].TransactionTypeId=35 
--					  and Customer.[Transaction].TransactionDate<=ISNULL((select top 1 RiskManagement.WithdrawRequest.ApprovedDate from RiskManagement.WithdrawRequest where RiskManagement.WithdrawRequest.CustomerId=Customer.Customer.CustomerId and RiskManagement.WithdrawRequest.TransactionType=31 order by RiskManagement.WithdrawRequest.Approved1Date desc),GETDATE()) )>0 
--					  then 1 else 3 end as StatuColor,RiskManagement.WithdrawRequest.Approved1Comment,Customer.Customer.ZipCode as CustomerSSN
--FROM         RiskManagement.WithdrawRequest INNER JOIN
--                      Customer.Customer ON RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId INNER JOIN
--                      Parameter.Currency ON RiskManagement.WithdrawRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Parameter.TransactionType ON RiskManagement.WithdrawRequest.TransactionType = Parameter.TransactionType.TransactionTypeId LEFT OUTER JOIN
--                      Parameter.Bank ON RiskManagement.WithdrawRequest.BankId = Parameter.Bank.BankId LEFT OUTER JOIN
--                      Users.Users ON RiskManagement.WithdrawRequest.Approved1UserId = Users.Users.UserId 
--WHERE (1 = 1) 
-- )   
--SELECT * ,@total as totalrow
--  FROM OrdersRN 


set @sqlcommand='declare @total int '+
'select @total=COUNT(RiskManagement.WithdrawRequest.WithdrawRequestId) '+
'FROM         RiskManagement.WithdrawRequest INNER JOIN '+
                      'Customer.Customer ON RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId INNER JOIN '+
                      'Parameter.Currency ON RiskManagement.WithdrawRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN '+
                      'Parameter.TransactionType ON RiskManagement.WithdrawRequest.TransactionType = Parameter.TransactionType.TransactionTypeId LEFT OUTER JOIN '+
                      'Parameter.Bank ON RiskManagement.WithdrawRequest.BankId = Parameter.Bank.BankId LEFT OUTER JOIN '+
                      'Users.Users ON RiskManagement.WithdrawRequest.Approved1UserId = Users.Users.UserId '+
'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	RiskManagement.WithdrawRequest.WithdrawRequestId, Customer.Customer.CustomerId, '+
                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname AS Customer, dbo.UserTimeZoneDate('''+@Username+''', RiskManagement.WithdrawRequest.RequestDate,0) as RequestDate, '+
                      'RiskManagement.WithdrawRequest.Amount, RiskManagement.WithdrawRequest.CurrencyId, Parameter.Currency.Currency, Customer.Customer.Balance, '+
                      'Parameter.Currency.Sybol, Parameter.TransactionType.TransactionTypeId, Parameter.TransactionType.TransactionType, '+
                      'RiskManagement.WithdrawRequest.IsApproved, Customer.Customer.Username, Users.Users.UserId, Users.Users.UserName AS UserName1, Users.Users.Name, '+
                      'Users.Users.Surname,dbo.UserTimeZoneDate('''+@Username+''',  RiskManagement.WithdrawRequest.Approved1Date,0) as ApprovedDate, RiskManagement.WithdrawRequest.TransactionCode, '+
                      'RiskManagement.WithdrawRequest.AccountId, RiskManagement.WithdrawRequest.BankId, RiskManagement.WithdrawRequest.CustomerNote, '+
                      'Parameter.Bank.Bank,case when (select COUNT(Customer.[Transaction].TransactionId) from Customer.[Transaction] where Customer.[Transaction].CustomerId=Customer.Customer.CustomerId and Customer.[Transaction].TransactionTypeId=35 '+
					  'and Customer.[Transaction].TransactionDate<=ISNULL((select top 1 RiskManagement.WithdrawRequest.ApprovedDate from RiskManagement.WithdrawRequest where RiskManagement.WithdrawRequest.CustomerId=Customer.Customer.CustomerId and RiskManagement.WithdrawRequest.TransactionType=31 order by RiskManagement.WithdrawRequest.ApprovedDate desc),GETDATE()) )>0 '+
					  'then ''Yes'' else ''No'' end as IsBonus,case when (select COUNT(Customer.[Transaction].TransactionId) from Customer.[Transaction] where Customer.[Transaction].CustomerId=Customer.Customer.CustomerId and Customer.[Transaction].TransactionTypeId=35 '+
					  'and Customer.[Transaction].TransactionDate<=ISNULL((select top 1 RiskManagement.WithdrawRequest.ApprovedDate from RiskManagement.WithdrawRequest where RiskManagement.WithdrawRequest.CustomerId=Customer.Customer.CustomerId and RiskManagement.WithdrawRequest.TransactionType=31 order by RiskManagement.WithdrawRequest.ApprovedDate desc),GETDATE()) )>0 '+
					  'then 1 else 3 end as StatuColor,RiskManagement.WithdrawRequest.Approved1Comment,Customer.Customer.ZipCode as CustomerSSN '+
'FROM         RiskManagement.WithdrawRequest INNER JOIN
                      Customer.Customer ON RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId INNER JOIN
                      Parameter.Currency ON RiskManagement.WithdrawRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Parameter.TransactionType ON RiskManagement.WithdrawRequest.TransactionType = Parameter.TransactionType.TransactionTypeId LEFT OUTER JOIN
                      Parameter.Bank ON RiskManagement.WithdrawRequest.BankId = Parameter.Bank.BankId LEFT OUTER JOIN
                      Users.Users ON RiskManagement.WithdrawRequest.Approved1UserId = Users.Users.UserId '+
'WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand)                   

END




GO
