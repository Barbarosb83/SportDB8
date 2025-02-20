USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcAdminStadiumCustomerList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
 
CREATE PROCEDURE [Stadium].[ProcAdminStadiumCustomerList] 
@StadiumId bigint,
@LangId int,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(200)
AS

BEGIN
SET NOCOUNT ON;





declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)
declare @sqlcommand3 nvarchar(max)



--declare @total int 

--select @total=COUNT(Customer.Customer.Username) 
--from Stadium.Customers with (nolock)
-- INNER join Customer.Customer with (nolock)
-- On Stadium.Customers.CustomerId=Customer.Customer.CustomerId 
-- INNER JOIN Customer.Slip with (nolock)
-- On Stadium.Customers.SlipId=Customer.Slip.SlipId where Stadium.Customers.StadiumId=@StadiumId ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Stadium.Customers.StadiumCustomerId) AS RowNum,
-- Stadium.Customers.StadiumCustomerId,Customer.Customer.Username,Customer.CustomerId,Customer.slip.SlipId,Customer.slip.TotalOddValue
-- ,Stadium.Customers.CardChangeCount,Stadium.Customers.IsWon,Stadium.Customers.CreateDate
--FROM    Stadium.Customers with (nolock)
-- INNER join Customer.Customer with (nolock)
-- On Stadium.Customers.CustomerId=Customer.Customer.CustomerId 
-- INNER JOIN Customer.Slip with (nolock)
-- On Stadium.Customers.SlipId=Customer.Slip.SlipId 
--WHERE  Stadium.Customers.StadiumId=@StadiumId
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 



set @sqlcommand='declare @total int '+
'select @total=COUNT(Customer.Customer.Username)  '+
' From Stadium.Customers with (nolock)
 INNER join Customer.Customer with (nolock)
 On Stadium.Customers.CustomerId=Customer.Customer.CustomerId 
 INNER JOIN Stadium.Slip with (nolock)
 On Stadium.Customers.SlipId=Stadium.Slip.SlipId ' +
                      ' WHERE Stadium.Customers.StadiumId='+cast(@StadiumId as nvarchar(10))+' and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'Stadium.Customers.StadiumCustomerId,Customer.Customer.Username,Customer.CustomerId,Stadium.slip.SlipId,Stadium.slip.TotalOddValue
 ,Stadium.Customers.CardChangeCount,Stadium.Customers.IsWon,Stadium.Customers.CreateDate
From Stadium.Customers with (nolock)
 INNER join Customer.Customer with (nolock)
 On Stadium.Customers.CustomerId=Customer.Customer.CustomerId 
 INNER JOIN Stadium.Slip with (nolock)
 On Stadium.Customers.SlipId=Stadium.Slip.SlipId  '+
                      'WHERE Stadium.Customers.StadiumId='+cast(@StadiumId as nvarchar(10))+' and '+@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '



 

exec (@sqlcommand)




END


GO
