USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchTransaction]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcBranchTransaction]
 @BranchId int,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int


AS




BEGIN
SET NOCOUNT ON;

declare @sqlcommand nvarchar(max)


--SELECT     0 AS totalrow, RiskManagement.BranchTransaction.BranchTransactionId, RiskManagement.BranchTransaction.BranchId, 
--                      RiskManagement.BranchTransaction.CustomerId, RiskManagement.BranchTransaction.TransactionTypeId, RiskManagement.BranchTransaction.Amount, 
--                      RiskManagement.BranchTransaction.CurrencyId, RiskManagement.BranchTransaction.CreateDate, RiskManagement.BranchTransaction.UserId, 
--                      Parameter.TransactionTypeBranch.TransactionType, Parameter.Currency.Currency, 
--                      Customer.Customer.CustomerName + ' ' + Customer.Customer.CustomerSurname + '(' + Customer.Customer.Username + ')' AS Customer, 
--                      Users.Users.Name + ' ' + Users.Users.Surname + '(' + Users.Users.UserName + ')' AS UserName, Parameter.Branch.BrancName, 
--                      CASE WHEN Parameter.TransactionTypeBranch.Direction = 0 THEN 1 ELSE 3 END AS StatuColor
--FROM         RiskManagement.BranchTransaction INNER JOIN
--                      Parameter.Branch ON RiskManagement.BranchTransaction.BranchId = Parameter.Branch.BranchId INNER JOIN
--                      Parameter.TransactionTypeBranch ON 
--                      RiskManagement.BranchTransaction.TransactionTypeId = Parameter.TransactionTypeBranch.BranchTransactionTypeId INNER JOIN
--                      Parameter.Currency ON RiskManagement.BranchTransaction.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Users.Users ON RiskManagement.BranchTransaction.UserId = Users.Users.UserId LEFT OUTER JOIN
--                      Customer.Customer ON RiskManagement.BranchTransaction.CustomerId = Customer.Customer.CustomerId
--WHERE     (Parameter.Branch.BranchId = 2)




set @sqlcommand='declare @total int '+
'select @total=COUNT(RiskManagement.BranchTransaction.BranchTransactionId) '+
'FROM         RiskManagement.BranchTransaction INNER JOIN
                      Parameter.Branch ON RiskManagement.BranchTransaction.BranchId = Parameter.Branch.BranchId INNER JOIN
                      Parameter.TransactionTypeBranch ON 
                      RiskManagement.BranchTransaction.TransactionTypeId = Parameter.TransactionTypeBranch.BranchTransactionTypeId INNER JOIN
                      Parameter.Currency ON RiskManagement.BranchTransaction.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Users.Users ON RiskManagement.BranchTransaction.UserId = Users.Users.UserId LEFT OUTER JOIN
                      Customer.Customer ON RiskManagement.BranchTransaction.CustomerId = Customer.Customer.CustomerId '+
'WHERE  '+@where +' and    (Parameter.Branch.BranchId= '+cast(@BranchId as nvarchar(10))+' ) ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+ @orderby +') AS RowNum,  '+
' RiskManagement.BranchTransaction.BranchTransactionId, RiskManagement.BranchTransaction.BranchId, 
                      RiskManagement.BranchTransaction.CustomerId, RiskManagement.BranchTransaction.TransactionTypeId, RiskManagement.BranchTransaction.Amount, 
                      RiskManagement.BranchTransaction.CurrencyId, RiskManagement.BranchTransaction.CreateDate, RiskManagement.BranchTransaction.UserId, 
                      Parameter.TransactionTypeBranch.TransactionType, Parameter.Currency.Currency, 
                      Customer.Customer.CustomerName + '' '' + Customer.Customer.CustomerSurname + ''('' + Customer.Customer.Username + '')'' AS Customer, 
                      Users.Users.Name + '' '' + Users.Users.Surname + ''('' + Users.Users.UserName + '')'' AS UserName, Parameter.Branch.BrancName, 
                      CASE WHEN Parameter.TransactionTypeBranch.Direction = 0 THEN 1 ELSE 3 END AS StatuColor '+
'FROM         RiskManagement.BranchTransaction INNER JOIN
                      Parameter.Branch ON RiskManagement.BranchTransaction.BranchId = Parameter.Branch.BranchId INNER JOIN
                      Parameter.TransactionTypeBranch ON 
                      RiskManagement.BranchTransaction.TransactionTypeId = Parameter.TransactionTypeBranch.BranchTransactionTypeId INNER JOIN
                      Parameter.Currency ON RiskManagement.BranchTransaction.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Users.Users ON RiskManagement.BranchTransaction.UserId = Users.Users.UserId LEFT OUTER JOIN
                      Customer.Customer ON RiskManagement.BranchTransaction.CustomerId = Customer.Customer.CustomerId '+
'WHERE  '+@where +' and  (Parameter.Branch.BranchId= '+cast(@BranchId as nvarchar(10))+' ) '+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


exec (@sqlcommand)




END



GO
