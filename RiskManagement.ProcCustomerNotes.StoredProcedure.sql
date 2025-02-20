USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerNotes]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerNotes]
@CustomerId bigint, 
@PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(250),
@orderby nvarchar(100)


AS




BEGIN
SET NOCOUNT ON;

declare @sqlcommand nvarchar(max)

--declare @total int 
--select @total=COUNT(Customer.Notes.CustomerNotesId)  
--FROM        Customer.Notes
--WHERE     (Customer.Notes.CustomerId = @CustomerId) ;
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Notes.CreateDate desc) AS RowNum, 
--    Customer.Notes.CustomerNotesId,Customer.Notes.CustomerId,Customer.Notes.Notes
--    ,dbo.UserTimeZoneDate(@Username,Customer.Notes.CreateDate,0) as CreateDate,
--    Users.Name+' '+Users.Surname as CreateUser
--FROM      Customer.Notes INNER JOIN
--Users.Users ON Users.UserId=Customer.Notes.CreateUserId
--WHERE     (Customer.Notes.CustomerId = @CustomerId)

--)  
--SELECT *,@total as totalrow 
--  FROM OrdersRN 
--  WHERE RowNum BETWEEN (@PageNum-1 )*(@PageSize )+1 AND (@PageNum * @PageSize )





set @sqlcommand='declare @total int '+
'select @total=COUNT(Customer.Notes.CustomerNotesId) '+
'FROM        Customer.Notes '+
'WHERE     (Customer.Notes.CustomerId = '+cast(@CustomerId as nvarchar(10))+' ) and '+ @where +'  ;' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Customer.Notes.CustomerNotesId) AS RowNum,  '+
' Customer.Notes.CustomerNotesId,Customer.Notes.CustomerId,Customer.Notes.Notes,Customer.Notes.CreateDate, Users.Name+'' ''+Users.Surname as CreateUser '+
'FROM         Customer.Notes INNER JOIN Users.Users ON Users.UserId=Customer.Notes.CreateUserId '+
'WHERE     (Customer.Notes.CustomerId  = '+cast(@CustomerId as nvarchar(10))+') and '+ @where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


exec (@sqlcommand)                   

END


GO
