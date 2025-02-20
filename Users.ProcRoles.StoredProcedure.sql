USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcRoles]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcRoles] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(200),
@orderby nvarchar(100)
AS
BEGIN
SET NOCOUNT ON;
exec [Log].[ProcTransactionLogUID] 4,0,@Username,null,null,null,null

declare @sqlcommand nvarchar(max)

 --prod şunu ekle and Users.Roles.IsVisible=1 

set @sqlcommand=   'declare @total int '+
' select @total=COUNT(*) from  '+
'Users.Roles  where Users.Roles.IsDeleted=0 and Users.Roles.IsVisible=1 and '+@where+' ; '+
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY  '+@orderby+ ') AS RowNum,  '+
'Users.Roles.RoleId,Users.Roles.RoleName,Users.Roles.Description '+
'from Users.Roles '+
'where Users.Roles.IsDeleted=0  and '+@where +
'  )  '+
'			 SELECT *,@total as totalrow '+
'  FROM OrdersRN'+
' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(20))+')*('+cast(@PageSize + 1 as nvarchar(10))+')) AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


exec (@sqlcommand)
END


GO
