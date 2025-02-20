USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcUsersMulti]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcUsersMulti] 
		 @PageSize  int,
		 @PageNum int,
	@Username nvarchar(50),
	@where nvarchar(max),
	@orderby nvarchar(max)
AS
BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)

  SELECT    0 as totalrow, '' as UserName,
  'All Branch' AS NameSurname
 , '' as Email, 
                     CAST( 0 as int) as  UnitCode, '' as UnitName, '' as PositionCode,'' as PositionName, '' as RoleName, CAST( 0 as int) as RoleId, 
                      CAST( 0 as int) as UserId, '' as Name, '' as Surname, '' as Password, '' as GsmNo, CAST( 0 as int) as TimeZoneId, 
                      '' as TimeZone, CAST( 0 as int) as LanguageId, '' as Language, CAST( 0 as int) as CurrencyId, 
                      '' as Currency,CAST( 0 as int) as BranchId,'' as BrancName
UNION ALL
 SELECT    0 as totalrow, Users.Users.UserName,
  RTRIM(ISNULL(Users.Users.Name, '')) + ' ' + RTRIM(ISNULL(Users.Users.Surname, ''))+'('+Parameter.Branch.BrancName+')' AS NameSurname
 , Users.Users.Email, 
                      Users.Users.UnitCode, Users.Users.UnitName, Users.Users.PositionCode, Users.Users.PositionName, Users.Roles.RoleName, Users.Roles.RoleId, 
                      Users.Users.UserId, Users.Users.Name, Users.Users.Surname, Users.Users.Password, Users.Users.GsmNo, Parameter.TimeZone.TimeZoneId, 
                      Parameter.TimeZone.TimeZone, Language.Language.LanguageId, Language.Language.Language, Parameter.Currency.CurrencyId, 
                      Parameter.Currency.Currency,Parameter.Branch.BranchId,Parameter.Branch.BrancName
 from Users.Users INNER JOIN
                      Parameter.TimeZone ON Users.Users.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Language.Language ON Users.Users.LanguageId = Language.Language.LanguageId INNER JOIN
                      Parameter.Currency ON Users.Users.CurrencyId = Parameter.Currency.CurrencyId LEFT OUTER JOIN
                      Users.UserRoles ON Users.Users.UserId = Users.UserRoles.UserId LEFT OUTER JOIN
                      Users.Roles ON Users.UserRoles.RoleId = Users.Roles.RoleId INNER JOIN
                      Parameter.Branch ON Parameter.Branch.BranchId=Users.Users.UnitCode
where (Users.Roles.RoleId not in (1)) and Users.Users.IsDeleted=0 
 

--set @sqlcommand=   'declare @total int '+
--' select @total=COUNT(*)  '+
--'FROM         Users.Users left outer JOIN
--                      Users.UserRoles ON Users.Users.UserId = Users.UserRoles.UserId left outer  JOIN
--                      Users.Roles ON Users.UserRoles.RoleId = Users.Roles.RoleId
--Where (Users.Roles.RoleId not in (1,2,3)) and Users.Users.IsDeleted=0 and '+@where+' ; '+
--'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY  '+@orderby+ ') AS RowNum,  '+
--'Users.Users.UserName, rtrim(isnull(Users.Users.Name,''''))+'' ''+rtrim(isnull(Users.Users.Surname,'''')) as NameSurname, Users.Users.Email, Users.Users.UnitCode, Users.Users.UnitName, Users.Users.PositionCode, 
--                      Users.Users.PositionName, Users.Roles.RoleName,Users.Roles.RoleId,Users.UserId,Users.Users.Name,Users.Users.Surname,Users.Users.Password,Users.Users.GsmNo '+
--'FROM         Users.Users left outer JOIN
--                      Users.UserRoles ON Users.Users.UserId = Users.UserRoles.UserId left outer  JOIN
--                      Users.Roles ON Users.UserRoles.RoleId = Users.Roles.RoleId '+
--'where (Users.Roles.RoleId not in (1)) and Users.Users.IsDeleted=0  and '+@where +
--'  )  '+
--'			 SELECT *,@total as totalrow '+
--'  FROM OrdersRN'+
--' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(20))+')*('+cast(@PageSize  as nvarchar(10))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


exec (@sqlcommand)
END



GO
