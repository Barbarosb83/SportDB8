USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcUsers]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- =============================================
-- Author:		Yusuf AVCI
-- Create date: 01.06.2014
-- Description:	Kullanıcıları listeler.
-- =============================================
CREATE PROCEDURE [Retail].[ProcUsers] 
		 @PageSize  int,
		 @PageNum int,
	@Username nvarchar(50),
	@where nvarchar(max),
	@orderby nvarchar(max),
	@BranchId int
AS
BEGIN
SET NOCOUNT ON;

 
declare @sqlcommand nvarchar(max)

 
-- SELECT    0 as totalrow, Users.Users.UserName, RTRIM(ISNULL(Users.Users.Name, '')) + ' ' + RTRIM(ISNULL(Users.Users.Surname, '')) AS NameSurname, Users.Users.Email, 
--                      Users.Users.UnitCode, Users.Users.UnitName, Users.Users.PositionCode, Users.Users.PositionName, Users.Roles.RoleName, Users.Roles.RoleId, 
--                      Users.Users.UserId, Users.Users.Name, Users.Users.Surname, Users.Users.Password, Users.Users.GsmNo, Parameter.TimeZone.TimeZoneId, 
--                      Parameter.TimeZone.TimeZone, Language.Language.LanguageId, Language.Language.Language, Parameter.Currency.CurrencyId, 
--                      Parameter.Currency.Currency,Parameter.Branch.BranchId,Parameter.Branch.BrancName,Users.IsLockedOut
-- from Users.Users INNER JOIN
--                      Parameter.TimeZone ON Users.Users.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
--                      Language.Language ON Users.Users.LanguageId = Language.Language.LanguageId INNER JOIN
--                      Parameter.Currency ON Users.Users.CurrencyId = Parameter.Currency.CurrencyId LEFT OUTER JOIN
--                      Users.UserRoles ON Users.Users.UserId = Users.UserRoles.UserId LEFT OUTER JOIN
--                      Users.Roles ON Users.UserRoles.RoleId = Users.Roles.RoleId INNER JOIN
--                      Parameter.Branch ON Parameter.Branch.BranchId=Users.Users.UnitCode
--where (Users.Roles.RoleId not in (1)) and Users.Users.IsDeleted=0  and Users.Users.UnitCode=@BranchId
 declare @RoleId int

 select @RoleId= Users.UserRoles.RoleId from Users.Users INNER JOIN Users.UserRoles ON Users.Users.UserId=Users.UserRoles.UserId where UserName=@Username
 

 if(@RoleId<>158)
 begin
set @sqlcommand='declare @total int '+
'select @total=COUNT(Users.Users.UserId) '+
'from Users.Users INNER JOIN
                      Parameter.TimeZone ON Users.Users.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Language.Language ON Users.Users.LanguageId = Language.Language.LanguageId INNER JOIN
                      Parameter.Currency ON Users.Users.CurrencyId = Parameter.Currency.CurrencyId LEFT OUTER JOIN
                      Users.UserRoles ON Users.Users.UserId = Users.UserRoles.UserId LEFT OUTER JOIN
                      Users.Roles ON Users.UserRoles.RoleId = Users.Roles.RoleId INNER JOIN
                      Parameter.Branch ON Parameter.Branch.BranchId=Users.Users.UnitCode '+
' WHERE  (Users.Roles.RoleId not in (1)) and Users.Users.IsDeleted=0  and Users.Users.UnitCode='+cast(@BranchId as nvarchar(20))+'  '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	Users.Users.UserName, RTRIM(ISNULL(Users.Users.Name, '''')) + '' '' + RTRIM(ISNULL(Users.Users.Surname, '''')) AS NameSurname, Users.Users.Email, 
                      Users.Users.UnitCode, Users.Users.UnitName, Users.Users.PositionCode, Users.Users.PositionName, Users.Roles.RoleName, Users.Roles.RoleId, 
                      Users.Users.UserId, Users.Users.Name, Users.Users.Surname, Users.Users.Password, Users.Users.GsmNo, Parameter.TimeZone.TimeZoneId, 
                      Parameter.TimeZone.TimeZone, Language.Language.LanguageId, Language.Language.Language, Parameter.Currency.CurrencyId, 
                      Parameter.Currency.Currency,Parameter.Branch.BranchId,Parameter.Branch.BrancName,Users.IsLockedOut '+
'from Users.Users INNER JOIN
                      Parameter.TimeZone ON Users.Users.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Language.Language ON Users.Users.LanguageId = Language.Language.LanguageId INNER JOIN
                      Parameter.Currency ON Users.Users.CurrencyId = Parameter.Currency.CurrencyId LEFT OUTER JOIN
                      Users.UserRoles ON Users.Users.UserId = Users.UserRoles.UserId LEFT OUTER JOIN
                      Users.Roles ON Users.UserRoles.RoleId = Users.Roles.RoleId INNER JOIN
                      Parameter.Branch ON Parameter.Branch.BranchId=Users.Users.UnitCode and Parameter.Branch.IsTerminal=0 '+
' WHERE  (Users.Roles.RoleId not in (1)) and Users.Users.IsDeleted=0  and Users.Users.UnitCode in (select BranchId from Parameter.Branch where (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId in (select BranchId from Parameter.Branch  where (BranchId='+cast(@BranchId as nvarchar(7))+ ' or ParentBranchId='+cast(@BranchId as nvarchar(7))+ ') ))) ' +@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '
 end
 else
	begin
	set @sqlcommand='declare @total int '+
'select @total=COUNT(Users.Users.UserId) '+
'from Users.Users INNER JOIN
                      Parameter.TimeZone ON Users.Users.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Language.Language ON Users.Users.LanguageId = Language.Language.LanguageId INNER JOIN
                      Parameter.Currency ON Users.Users.CurrencyId = Parameter.Currency.CurrencyId LEFT OUTER JOIN
                      Users.UserRoles ON Users.Users.UserId = Users.UserRoles.UserId LEFT OUTER JOIN
                      Users.Roles ON Users.UserRoles.RoleId = Users.Roles.RoleId INNER JOIN
                      Parameter.Branch ON Parameter.Branch.BranchId=Users.Users.UnitCode '+
' WHERE  Users.Users.UserName='''+@Username+' ''' +@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	Users.Users.UserName, RTRIM(ISNULL(Users.Users.Name, '''')) + '' '' + RTRIM(ISNULL(Users.Users.Surname, '''')) AS NameSurname, Users.Users.Email, 
                      Users.Users.UnitCode, Users.Users.UnitName, Users.Users.PositionCode, Users.Users.PositionName, Users.Roles.RoleName, Users.Roles.RoleId, 
                      Users.Users.UserId, Users.Users.Name, Users.Users.Surname, Users.Users.Password, Users.Users.GsmNo, Parameter.TimeZone.TimeZoneId, 
                      Parameter.TimeZone.TimeZone, Language.Language.LanguageId, Language.Language.Language, Parameter.Currency.CurrencyId, 
                      Parameter.Currency.Currency,Parameter.Branch.BranchId,Parameter.Branch.BrancName,Users.IsLockedOut '+
'from Users.Users INNER JOIN
                      Parameter.TimeZone ON Users.Users.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Language.Language ON Users.Users.LanguageId = Language.Language.LanguageId INNER JOIN
                      Parameter.Currency ON Users.Users.CurrencyId = Parameter.Currency.CurrencyId LEFT OUTER JOIN
                      Users.UserRoles ON Users.Users.UserId = Users.UserRoles.UserId LEFT OUTER JOIN
                      Users.Roles ON Users.UserRoles.RoleId = Users.Roles.RoleId INNER JOIN
                      Parameter.Branch ON Parameter.Branch.BranchId=Users.Users.UnitCode '+
' WHERE  Users.Users.UserName='''+@Username+' '''  +@where +
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '

	end

exec (@sqlcommand)
END




GO
