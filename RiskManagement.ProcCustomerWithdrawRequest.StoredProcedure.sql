USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerWithdrawRequest]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [RiskManagement].[ProcCustomerWithdrawRequest]
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

--declare @total int
--select @total= COUNT(RiskManagement.WithdrawRequest.WithdrawRequestId) 
--FROM            RiskManagement.WithdrawRequest INNER JOIN
--                         Customer.Customer ON RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId INNER JOIN
--                         Parameter.Currency ON RiskManagement.WithdrawRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                         Parameter.TransactionType ON RiskManagement.WithdrawRequest.TransactionType = Parameter.TransactionType.TransactionTypeId INNER JOIN
--                         Users.Users ON RiskManagement.WithdrawRequest.Approved1UserId = Users.Users.UserId LEFT OUTER JOIN
--                         Parameter.Bank ON RiskManagement.WithdrawRequest.BankId = Parameter.Bank.BankId LEFT OUTER JOIN
--                         Users.Users AS Users_1 ON RiskManagement.WithdrawRequest.ApprovedUserId = Users_1.UserId
--WHERE (1 = 1) AND (RiskManagement.WithdrawRequest.IsApproved1 IS NOT NULL) ;
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY RiskManagement.WithdrawRequest.WithdrawRequestId) AS RowNum, 
--	     RiskManagement.WithdrawRequest.WithdrawRequestId, Customer.Customer.CustomerId, Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname AS Customer, 
--                         dbo.UserTimeZoneDate(N'Administrator', RiskManagement.WithdrawRequest.RequestDate, 0) AS RequestDate, RiskManagement.WithdrawRequest.Amount, RiskManagement.WithdrawRequest.CurrencyId, 
--                         Parameter.Currency.Currency, Customer.Customer.Balance, Parameter.Currency.Sybol, Parameter.TransactionType.TransactionTypeId, Parameter.TransactionType.TransactionType, 
--                         RiskManagement.WithdrawRequest.IsApproved, Customer.Customer.Username, Users_1.UserId, Users_1.UserName AS UserName1, Users_1.Name, Users_1.Surname, dbo.UserTimeZoneDate(N'Administrator', 
--                         RiskManagement.WithdrawRequest.ApprovedDate, 0) AS ApprovedDate, RiskManagement.WithdrawRequest.TransactionCode, RiskManagement.WithdrawRequest.AccountId, 
--                         RiskManagement.WithdrawRequest.BankId, RiskManagement.WithdrawRequest.CustomerNote, Parameter.Bank.Bank, CASE WHEN
--                             (SELECT        COUNT(Customer.[Transaction].TransactionId)
--                               FROM            Customer.[Transaction]
--                               WHERE        Customer.[Transaction].CustomerId = Customer.Customer.CustomerId AND Customer.[Transaction].TransactionTypeId = 35 AND Customer.[Transaction].TransactionDate <= ISNULL
--                                                             ((SELECT        TOP 1 RiskManagement.WithdrawRequest.ApprovedDate
--                                                                 FROM            RiskManagement.WithdrawRequest
--                                                                 WHERE        RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId AND RiskManagement.WithdrawRequest.TransactionType = 31
--                                                                 ORDER BY RiskManagement.WithdrawRequest.ApprovedDate DESC), GETDATE())) > 0 THEN 'Yes' ELSE 'No' END AS IsBonus, CASE WHEN
--                             (SELECT        COUNT(Customer.[Transaction].TransactionId)
--                               FROM            Customer.[Transaction]
--                               WHERE        Customer.[Transaction].CustomerId = Customer.Customer.CustomerId AND Customer.[Transaction].TransactionTypeId = 35 AND Customer.[Transaction].TransactionDate <= ISNULL
--                                                             ((SELECT        TOP 1 RiskManagement.WithdrawRequest.ApprovedDate
--                                                                 FROM            RiskManagement.WithdrawRequest
--                                                                 WHERE        RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId AND RiskManagement.WithdrawRequest.TransactionType = 31
--                                                                 ORDER BY RiskManagement.WithdrawRequest.ApprovedDate DESC), GETDATE())) > 0 THEN 1 ELSE 3 END AS StatuColor
--																 , dbo.UserTimeZoneDate(N'Administrator', RiskManagement.WithdrawRequest.Approved1Date, 0) AS ApprovedDate1, RiskManagement.WithdrawRequest.Approved1Comment, Users.Users.Name+' '+Users.Users.Surname as Approved1User,IsApproved1,Customer.Customer.ZipCode as CustomerSSN
--FROM            RiskManagement.WithdrawRequest INNER JOIN
--                         Customer.Customer ON RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId INNER JOIN
--                         Parameter.Currency ON RiskManagement.WithdrawRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                         Parameter.TransactionType ON RiskManagement.WithdrawRequest.TransactionType = Parameter.TransactionType.TransactionTypeId INNER JOIN
--                         Users.Users ON RiskManagement.WithdrawRequest.Approved1UserId = Users.Users.UserId LEFT OUTER JOIN
--                         Parameter.Bank ON RiskManagement.WithdrawRequest.BankId = Parameter.Bank.BankId LEFT OUTER JOIN
--                         Users.Users AS Users_1 ON RiskManagement.WithdrawRequest.ApprovedUserId = Users_1.UserId
--WHERE        (1 = 1) AND (RiskManagement.WithdrawRequest.IsApproved1 IS NOT NULL)
-- )   
--SELECT * ,@total as totalrow
--  FROM OrdersRN 



set @sqlcommand='declare @total int '+
'select @total=COUNT(RiskManagement.WithdrawRequest.WithdrawRequestId) '+
'FROM            RiskManagement.WithdrawRequest with (nolock) INNER JOIN
                         Customer.Customer with (nolock) ON RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId INNER JOIN
                         Parameter.Currency with (nolock) ON RiskManagement.WithdrawRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                         Parameter.TransactionType with (nolock) ON RiskManagement.WithdrawRequest.TransactionType = Parameter.TransactionType.TransactionTypeId LEFT OUTER JOIN
                         Users.Users with (nolock) ON RiskManagement.WithdrawRequest.Approved1UserId = Users.Users.UserId LEFT OUTER JOIN
                         Parameter.Bank with (nolock) ON RiskManagement.WithdrawRequest.BankId = Parameter.Bank.BankId LEFT OUTER JOIN
                         Users.Users AS Users_1 with (nolock) ON RiskManagement.WithdrawRequest.ApprovedUserId = Users_1.UserId '+
'WHERE (1 = 1)   and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	RiskManagement.WithdrawRequest.WithdrawRequestId, Customer.Customer.CustomerId, '+
                      'Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname AS Customer, dbo.UserTimeZoneDate('''+@Username+''', RiskManagement.WithdrawRequest.RequestDate,0) as RequestDate, '+
                      'RiskManagement.WithdrawRequest.Amount, RiskManagement.WithdrawRequest.CurrencyId, Parameter.Currency.Currency, Customer.Customer.Balance, '+
                      'Parameter.Currency.Sybol, Parameter.TransactionType.TransactionTypeId, Parameter.TransactionType.TransactionType, '+
                      'RiskManagement.WithdrawRequest.IsApproved, Customer.Customer.Username, Users_1.UserId, Users_1.UserName AS UserName1, Users_1.Name, Users_1.Surname '+
                      ',dbo.UserTimeZoneDate('''+@Username+''',  RiskManagement.WithdrawRequest.ApprovedDate,0) as ApprovedDate, RiskManagement.WithdrawRequest.TransactionCode, '+
                      'RiskManagement.WithdrawRequest.AccountId, RiskManagement.WithdrawRequest.BankId, RiskManagement.WithdrawRequest.CustomerNote, '+
                      'Parameter.Bank.Bank,case when (select COUNT(Customer.[Bonus].CustomerBonusId) from Customer.[Bonus] where Customer.[Bonus].CustomerId=Customer.Customer.CustomerId  '+
					  'and Customer.[Bonus].CreateDate<=ISNULL((select top 1 RiskManagement.WithdrawRequest.ApprovedDate from RiskManagement.WithdrawRequest where RiskManagement.WithdrawRequest.CustomerId=Customer.Customer.CustomerId and RiskManagement.WithdrawRequest.TransactionType=31 order by RiskManagement.WithdrawRequest.ApprovedDate desc),GETDATE()) )>0 '+
					  'then ''Yes'' else ''No'' end as IsBonus,case when RiskManagement.WithdrawRequest.Amount<=2000'+
					  'then 1 else 3 end as StatuColor '+
					  ' , dbo.UserTimeZoneDate('''+@Username+''', RiskManagement.WithdrawRequest.Approved1Date, 0) AS ApprovedDate1, RiskManagement.WithdrawRequest.Approved1Comment, Users.Users.Name+'' ''+Users.Users.Surname as Approved1User,IsApproved1,Customer.Customer.IdNumber as CustomerSSN'
set @sqlcommand2=' FROM            RiskManagement.WithdrawRequest with (nolock) INNER JOIN
                         Customer.Customer with (nolock) ON RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId INNER JOIN
                         Parameter.Currency with (nolock) ON RiskManagement.WithdrawRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                         Parameter.TransactionType with (nolock) ON RiskManagement.WithdrawRequest.TransactionType = Parameter.TransactionType.TransactionTypeId LEFT OUTER JOIN
                         Users.Users with (nolock) ON RiskManagement.WithdrawRequest.Approved1UserId = Users.Users.UserId LEFT OUTER JOIN
                         Parameter.Bank with (nolock) ON RiskManagement.WithdrawRequest.BankId = Parameter.Bank.BankId LEFT OUTER JOIN
                         Users.Users AS Users_1 with (nolock) ON RiskManagement.WithdrawRequest.ApprovedUserId = Users_1.UserId '+
'WHERE (1 = 1)   and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


exec (@sqlcommand+@sqlcommand2)                   

END



GO
