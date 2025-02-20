USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcBranchDepositRequest]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcBranchDepositRequest]
@PageSize  INT,
@PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)


AS




BEGIN
SET NOCOUNT ON;

declare @sqlcommand nvarchar(max)


--SELECT   0 As totalrow,RiskManagement.BranchDepositRequest.BranchDepositId, RiskManagement.BranchDepositRequest.RequestUserId, 
--                      RiskManagement.BranchDepositRequest.BranchId, RiskManagement.BranchDepositRequest.RequestDate, RiskManagement.BranchDepositRequest.Amount, 
--                      RiskManagement.BranchDepositRequest.CurrencyId, RiskManagement.BranchDepositRequest.BranchNote, RiskManagement.BranchDepositRequest.IsApproved, 
--                      RiskManagement.BranchDepositRequest.ApprovedUserId, RiskManagement.BranchDepositRequest.ApprovedDate, Parameter.Branch.BrancName, 
--                      Parameter.Branch.Balance, Parameter.Branch.CommisionRate, Parameter.Branch.CurrencyId AS BranchCurrencyId, Parameter.Currency.Currency, 
--                      Users_1.Name + ' ' + Users_1.Surname + '(' + Users_1.UserName + ')' AS ApprovedUser, 
--                      Users.Users.Name + ' ' + Users.Users.Surname + '(' + Users.Users.UserName + ')' AS RequestUser,Parameter.TransactionTypeBranch.TransactionType
--FROM         RiskManagement.BranchDepositRequest INNER JOIN
--                      Parameter.Branch ON RiskManagement.BranchDepositRequest.BranchId = Parameter.Branch.BranchId INNER JOIN
--                      Parameter.Currency ON RiskManagement.BranchDepositRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Users.Users ON RiskManagement.BranchDepositRequest.RequestUserId = Users.Users.UserId LEFT OUTER JOIN
--                      Users.Users AS Users_1 ON RiskManagement.BranchDepositRequest.ApprovedUserId = Users_1.UserId INNER JOIN
--                      Parameter.TransactionTypeBranch ON Parameter.TransactionTypeBranch.BranchTransactionTypeId=RiskManagement.BranchDepositRequest.TransactionTypeId
--order by BranchDepositId desc




set @sqlcommand='declare @total int '+
'select @total=COUNT(RiskManagement.BranchDepositRequest.BranchDepositId) '+
'FROM         RiskManagement.BranchDepositRequest INNER JOIN
                      Parameter.Branch ON RiskManagement.BranchDepositRequest.BranchId = Parameter.Branch.BranchId INNER JOIN
                      Parameter.Currency ON RiskManagement.BranchDepositRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Users.Users ON RiskManagement.BranchDepositRequest.RequestUserId = Users.Users.UserId LEFT OUTER JOIN
                      Users.Users AS Users_1 ON RiskManagement.BranchDepositRequest.ApprovedUserId = Users_1.UserId INNER JOIN
                      Parameter.TransactionTypeBranch ON Parameter.TransactionTypeBranch.BranchTransactionTypeId=RiskManagement.BranchDepositRequest.TransactionTypeId '+
'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	RiskManagement.BranchDepositRequest.BranchDepositId, RiskManagement.BranchDepositRequest.RequestUserId, 
                      RiskManagement.BranchDepositRequest.BranchId, RiskManagement.BranchDepositRequest.RequestDate, RiskManagement.BranchDepositRequest.Amount, 
                      RiskManagement.BranchDepositRequest.CurrencyId, RiskManagement.BranchDepositRequest.BranchNote, RiskManagement.BranchDepositRequest.IsApproved, 
                      RiskManagement.BranchDepositRequest.ApprovedUserId, RiskManagement.BranchDepositRequest.ApprovedDate, Parameter.Branch.BrancName, 
                      Parameter.Branch.Balance, Parameter.Branch.CommisionRate, Parameter.Branch.CurrencyId AS BranchCurrencyId, Parameter.Currency.Currency, 
                      Users_1.Name + '' '' + Users_1.Surname + ''('' + Users_1.UserName + '')'' AS ApprovedUser, 
                      Users.Users.Name + '' '' + Users.Users.Surname + ''('' + Users.Users.UserName + '')'' AS RequestUser,Parameter.TransactionTypeBranch.TransactionType '+
'FROM         RiskManagement.BranchDepositRequest INNER JOIN
                      Parameter.Branch ON RiskManagement.BranchDepositRequest.BranchId = Parameter.Branch.BranchId INNER JOIN
                      Parameter.Currency ON RiskManagement.BranchDepositRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
                      Users.Users ON RiskManagement.BranchDepositRequest.RequestUserId = Users.Users.UserId LEFT OUTER JOIN
                      Users.Users AS Users_1 ON RiskManagement.BranchDepositRequest.ApprovedUserId = Users_1.UserId INNER JOIN
                      Parameter.TransactionTypeBranch ON Parameter.TransactionTypeBranch.BranchTransactionTypeId=RiskManagement.BranchDepositRequest.TransactionTypeId '+
'WHERE (1 = 1) and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand)                   

END


GO
