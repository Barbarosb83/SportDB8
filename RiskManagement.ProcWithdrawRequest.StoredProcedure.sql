USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcWithdrawRequest]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcWithdrawRequest]
@PageSize  INT,
@PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)


AS




BEGIN
SET NOCOUNT ON;

declare @sqlcommand nvarchar(max)


--SELECT     RiskManagement.WithdrawRequest.WithdrawRequestId, Customer.Customer.CustomerId, Customer.Customer.CustomerName +' '+ Customer.Customer.CustomerSurname as Customer,
--                      dbo.UserTimeZoneDate(@Username,RiskManagement.WithdrawRequest.RequestDate,0) as RequestDate, RiskManagement.WithdrawRequest.Amount, RiskManagement.WithdrawRequest.CurrencyId, 
--                      Parameter.Currency.Currency, Customer.Customer.Balance,Parameter.Currency.Sybol, [Parameter].[TransactionType].TransactionTypeId, 
--                      [Parameter].[TransactionType].TransactionType, RiskManagement.WithdrawRequest.IsApproved,  
--                      Customer.Customer.Username,  Users.Users.UserId, Users.Users.UserName AS UserName, Users.Users.Name, 
--                      Users.Users.Surname,dbo.UserTimeZoneDate(@Username,RiskManagement.WithdrawRequest.ApprovedDate,0) as ApprovedDate, RiskManagement.WithdrawRequest.TransactionCode, 
--                      RiskManagement.WithdrawRequest.AccountId
--FROM         RiskManagement.WithdrawRequest INNER JOIN
--                      Customer.Customer ON RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId INNER JOIN
--                      Parameter.Currency ON RiskManagement.WithdrawRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN                      
--                      [Parameter].[TransactionType] ON 
--                      RiskManagement.WithdrawRequest.TransactionType = [Parameter].[TransactionType].TransactionTypeId  LEFT OUTER JOIN
--                      Users.Users ON RiskManagement.WithdrawRequest.ApprovedUserId = Users.Users.UserId
                      


--declare @total int 
--select @total=COUNT(Customer.Ip.CustomerIpId)  
--FROM        Customer.Ip
--WHERE     (Customer.Ip.CustomerId = @CustomerId) ;
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Ip.LoginDate) AS RowNum, 
--    CustomerIpId,CustomerId,IpAddress,LoginDate
--FROM      Customer.Ip
--WHERE     (Customer.Ip.CustomerId = @CustomerId)

--)  
--SELECT *,@total as totalrow 
--  FROM OrdersRN 
--  WHERE RowNum BETWEEN (@PageNum-1 )*(@PageSize )+1 AND (@PageNum * @PageSize )





set @sqlcommand='declare @total int '+
'select @total=COUNT(RiskManagement.WithdrawRequest.WithdrawRequestId) '+
'FROM       RiskManagement.WithdrawRequest INNER JOIN
                      Customer.Customer ON RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId INNER JOIN
                      Parameter.Currency ON RiskManagement.WithdrawRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN                      
                      [Parameter].[TransactionType] ON 
                      RiskManagement.WithdrawRequest.TransactionType = [Parameter].[TransactionType].TransactionTypeId  LEFT OUTER JOIN
                      Users.Users ON RiskManagement.WithdrawRequest.ApprovedUserId = Users.Users.UserId '+
'WHERE    1=1 and '+@where+ ' ; ' +
' WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'  RiskManagement.WithdrawRequest.WithdrawRequestId, Customer.Customer.CustomerId, Customer.Customer.CustomerName +'' ''+ Customer.Customer.CustomerSurname as Customer,
                      dbo.UserTimeZoneDate('''+@Username+''',RiskManagement.WithdrawRequest.RequestDate,0) as RequestDate, RiskManagement.WithdrawRequest.Amount, RiskManagement.WithdrawRequest.CurrencyId, 
                      Parameter.Currency.Currency, Customer.Customer.Balance,Parameter.Currency.Sybol, [Parameter].[TransactionType].TransactionTypeId, 
                      [Parameter].[TransactionType].TransactionType, RiskManagement.WithdrawRequest.IsApproved,  
                      Customer.Customer.Username as CustomerUser,  Users.Users.UserId, Users.Users.UserName AS UserName, Users.Users.Name, 
                      Users.Users.Surname,dbo.UserTimeZoneDate('''+@Username+''',RiskManagement.WithdrawRequest.ApprovedDate,0) as ApprovedDate, RiskManagement.WithdrawRequest.TransactionCode, 
                      RiskManagement.WithdrawRequest.AccountId '+
'FROM        RiskManagement.WithdrawRequest INNER JOIN
                      Customer.Customer ON RiskManagement.WithdrawRequest.CustomerId = Customer.Customer.CustomerId INNER JOIN
                      Parameter.Currency ON RiskManagement.WithdrawRequest.CurrencyId = Parameter.Currency.CurrencyId INNER JOIN                      
                      [Parameter].[TransactionType] ON 
                      RiskManagement.WithdrawRequest.TransactionType = [Parameter].[TransactionType].TransactionTypeId  LEFT OUTER JOIN
                      Users.Users ON RiskManagement.WithdrawRequest.ApprovedUserId = Users.Users.UserId '+
'WHERE    1=1 and '+@where+ 
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


exec (@sqlcommand)                   

END


GO
