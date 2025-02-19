USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcRolesOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcRolesOne] 
@RoleId int,
@Username nvarchar(50) 
AS
BEGIN

--exec [Log].[ProcTransactionLogUID] 3,0,@Username,null,null,null,null


SELECT    Users.Roles.RoleName, Users.Roles.[Description]
FROM      Users.Roles
WHERE      Users.Roles.RoleId=@RoleId


END


GO
