USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcUsersOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Yusuf AVCI
-- Create date: 01.06.2014
-- Description:	Kullanıcıları listeler.
-- =============================================
CREATE PROCEDURE [Users].[ProcUsersOne] 
@UserId int

AS
BEGIN
SET NOCOUNT ON;

 SELECT   Users.Users.UserName, RTRIM(ISNULL(Users.Users.Name, '')) + ' ' + RTRIM(ISNULL(Users.Users.Surname, '')) AS NameSurname, Users.Users.Email, 
                      Users.Users.UnitCode, Users.Users.UnitName, Users.Users.PositionCode, Users.Users.PositionName, Users.Roles.RoleName, Users.Roles.RoleId, 
                      Users.Users.UserId, Users.Users.Name, Users.Users.Surname, Users.Users.Password,case when (Select Parameter.Branch.IsTerminal from Parameter.Branch where BranchId=Users.Users.UnitCode)=1 then '1' else '0' end as GsmNo, Parameter.TimeZone.TimeZoneId, 
                      Parameter.TimeZone.TimeZone, Language.Language.LanguageId, Language.Language.Language, Parameter.Currency.CurrencyId, 
                      Parameter.Currency.Currency,Parameter.Branch.ParentBranchId as BranchId,Parameter.Branch.BrancName,Users.Users.IsLockedOut,Users.Users.FailedPasswordAttemptCount
 from Users.Users INNER JOIN
                      Parameter.TimeZone ON Users.Users.TimeZoneId = Parameter.TimeZone.TimeZoneId INNER JOIN
                      Language.Language ON Users.Users.LanguageId = Language.Language.LanguageId INNER JOIN
                      Parameter.Currency ON Users.Users.CurrencyId = Parameter.Currency.CurrencyId LEFT OUTER JOIN
                      Users.UserRoles ON Users.Users.UserId = Users.UserRoles.UserId LEFT OUTER JOIN
                      Users.Roles ON Users.UserRoles.RoleId = Users.Roles.RoleId INNER JOIN
                      Parameter.Branch ON Parameter.Branch.BranchId=Users.Users.UnitCode
where (Users.UserId=@UserId) 


END


GO
