USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerFraud]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerFraud] 
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
declare @temptable table (IpAdress nvarchar(50),CustomerCount int)
declare @temptable2 table (IpAdress nvarchar(50),CustomerCount int,LastLoginDate datetime)

insert @temptable
select Customer.Ip.IpAddress,COUNT(DISTINCT Customer.Ip.CustomerId) from Customer.Ip with (nolock)
--where COUNT(DISTINCT Customer.Ip.CustomerId)>1
GROUP BY Customer.Ip.IpAddress
HAVING COUNT(Customer.Ip.IpAddress)>1


insert @temptable2
select top 10 IpAdress,CustomerCount,(select top 1 Customer.Ip.LoginDate from Customer.Ip with (nolock) where Customer.Ip.IpAddress=IpAdress order by  Customer.Ip.LoginDate desc)
from @temptable
where CustomerCount>1




declare @total int 
select @total=COUNT(IpAdress)  
FROM         @temptable2
WHERE   CustomerCount>1 and IpAdress<>'::1'   ;
WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY LastLoginDate desc) AS RowNum, 
    IpAdress,CustomerCount,LastLoginDate
from @temptable2
WHERE     CustomerCount>1 and IpAdress<>'::1'
)  
SELECT *,@total as totalrow 
  FROM OrdersRN 
  WHERE RowNum BETWEEN (@PageNum-1 )*(@PageSize )+1 AND (@PageNum * @PageSize )





--set @sqlcommand='declare @total int '+
--'select @total=COUNT(Customer.[Transaction].TransactionId) '+
--'FROM         Parameter.TransactionType INNER JOIN
--                      Customer.[Transaction] ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
--                      Parameter.TransactionSource ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
--                      Parameter.Currency ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId '+
--'WHERE     (Customer.[Transaction].CustomerId = '+cast(@CustomerId as nvarchar(10))+' )    and  Language.[Parameter.TransactionType].LanguageId='+cast(@LangId as nvarchar(2)) + '   ;' +
--'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.[Transaction].TransactionId DESC) AS RowNum,  '+
--'Customer.[Transaction].TransactionDate, Customer.[Transaction].TransactionTypeId, Customer.[Transaction].TransactionComment,case when Parameter.[TransactionType].Direction=1 THEN Customer.[Transaction].Amount ELSE -1*Customer.[Transaction].Amount end as Amount, 
--                      Customer.[Transaction].CurrencyId, Parameter.Currency.Currency, Customer.[Transaction].TransactionId, Customer.[Transaction].CustomerId, 
--                      Language.[Parameter.TransactionType].TransactionType,case when Parameter.[TransactionType].Direction=1 THEN 1 ELSE 3 end as statucolor '+
--'FROM         Parameter.TransactionType INNER JOIN
--                      Customer.[Transaction] ON Parameter.TransactionType.TransactionTypeId = Customer.[Transaction].TransactionTypeId INNER JOIN
--                      Parameter.TransactionSource ON Customer.[Transaction].TransactionSourceId = Parameter.TransactionSource.TransactionSourceId INNER JOIN
--                      Parameter.Currency ON Customer.[Transaction].CurrencyId = Parameter.Currency.CurrencyId INNER JOIN
--                      Language.[Parameter.TransactionType] ON Parameter.TransactionType.TransactionTypeId = Language.[Parameter.TransactionType].TransactionTypeId '+
--'WHERE     (Customer.[Transaction].CustomerId = '+cast(@CustomerId as nvarchar(10))+')    and  Language.[Parameter.TransactionType].LanguageId='+cast(@LangId as nvarchar(2)) + ''+
-- ') '+  
--'SELECT *,@total as totalrow '+
--  'FROM OrdersRN '+
-- ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand)

END


GO
