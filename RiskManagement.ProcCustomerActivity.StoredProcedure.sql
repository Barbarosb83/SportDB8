USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerActivity]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcCustomerActivity] 
@CustomerId bigint,
@LangId int,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100)
AS

BEGIN
SET NOCOUNT ON;
declare @sqlcommand nvarchar(max)
declare @UserCurrencyId int

select @UserCurrencyId=Users.Users.CurrencyId from Users.Users where Users.Users.UserName=@Username




--declare @total int 
--select @total=COUNT(Customer.Activity.CustomerActivityId)  
--FROM            Customer.Activity INNER JOIN
--                         Parameter.Activity AS Activity_1 ON Customer.Activity.ActivtyId = Activity_1.LoginActivityId
--						 where Customer.Activity.CustomerId=@CustomerId   ;
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Activity.CustomerActivityId) AS RowNum, 
-- Customer.Activity.CustomerActivityId, Customer.Activity.CustomerId, Customer.Activity.CreateDate, Customer.Activity.Browserr, Customer.Activity.IpAddress, Customer.Activity.ActivtyId, 
--                         Activity_1.ActivityType
--FROM            Customer.Activity INNER JOIN
--                         Parameter.Activity AS Activity_1 ON Customer.Activity.ActivtyId = Activity_1.LoginActivityId
--						 where Customer.Activity.CustomerId=@CustomerId

--)  
--SELECT *,@total as totalrow 
--  FROM OrdersRN 
--  WHERE RowNum BETWEEN (@PageNum-1 )*(@PageSize )+1 AND (@PageNum * @PageSize )



  


set @sqlcommand='declare @total int '+
'select @total=COUNT(Customer.Activity.CustomerActivityId)  '+
' FROM            Customer.Activity INNER JOIN
                         Parameter.Activity AS Activity_1 ON Customer.Activity.ActivtyId = Activity_1.LoginActivityId '+
' where (Customer.Activity.CustomerId= '+cast(@CustomerId as nvarchar(10))+' )   and '+@where+ '   ;' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Activity.CreateDate desc) AS RowNum,  '+
' Customer.Activity.CustomerActivityId, Customer.Activity.CustomerId, Customer.Activity.CreateDate, Customer.Activity.Browserr, Customer.Activity.IpAddress, Customer.Activity.ActivtyId, 
                         Activity_1.ActivityType '+
'FROM            Customer.Activity INNER JOIN
                         Parameter.Activity AS Activity_1 ON Customer.Activity.ActivtyId = Activity_1.LoginActivityId '+
'where (Customer.Activity.CustomerId= '+cast(@CustomerId as nvarchar(10))+')  and '+@where+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand)

END



GO
