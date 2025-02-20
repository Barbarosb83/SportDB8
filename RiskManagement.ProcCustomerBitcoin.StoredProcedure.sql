USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerBitcoin]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerBitcoin] 
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
declare @UserCurrencyId int

declare @RoleId int
declare @Multip float=0
declare @MultipDate nvarchar(20) 

select top 1  @RoleId=Users.UserRoles.RoleId, @UserCurrencyId=Users.Users.CurrencyId,@Multip=Multiplier,@MultipDate=MultipDate
from Users.Users INNER JOIN Users.UserRoles ON Users.UserRoles.UserId=Users.Users.UserId 
where Users.Users.UserName=@Username


--declare @total int 
--select @total=COUNT(Customer.BitcoinTransaction.BitcoinTransactionId)  
--from Customer.BitcoinTransaction INNER JOIN 
--Customer.Customer ON Customer.Customer.CustomerId=Customer.BitcoinTransaction.CustomerId  ;
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.BitcoinTransaction.BitcoinTransactionId) AS RowNum,
--   BitcoinTransactionId,Customer.CustomerId,CustomerName+' '+CustomerSurname+ ' ( '+ Username + ' )' as Customer,Amount
--   ,dbo.FuncCurrencyConverterDate(Amount,25,@UserCurrencyId,Customer.BitcoinTransaction.CreatedDate) as ConvertedAmount
--,Customer.BitcoinTransaction.CreatedDate
--from Customer.BitcoinTransaction INNER JOIN Customer.Customer ON Customer.CustomerId=Customer.BitcoinTransaction.CustomerId
--)  
--SELECT *,@total as totalrow 
--  FROM OrdersRN 


 
set @sqlcommand='declare @total int '+
'select @total=COUNT(Customer.BitcoinTransaction.BitcoinTransactionId) '+
'from Customer.BitcoinTransaction INNER JOIN 
Customer.Customer ON Customer.Customer.CustomerId=Customer.BitcoinTransaction.CustomerId '+
'WHERE     Amount>0 and '+@where+ '   ;' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum,  '+
'  BitcoinTransactionId,Customer.CustomerId,CustomerName+'' ''+CustomerSurname+ '' ( ''+ Username + '' )'' as Customer,Amount
   ,dbo.FuncCurrencyConverterDate(Amount,25,'+cast(@UserCurrencyId as nvarchar(10))+',Customer.BitcoinTransaction.CreatedDate) as ConvertedAmount
,Customer.BitcoinTransaction.CreatedDate,Customer.BitcoinTransaction.InvoiceId '
set @sqlcommand2=' from Customer.BitcoinTransaction INNER JOIN 
Customer.Customer ON Customer.Customer.CustomerId=Customer.BitcoinTransaction.CustomerId '+
'WHERE    Amount>0 and '+@where+ +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '
 
 

execute (@sqlcommand+@sqlcommand2)

END


GO
