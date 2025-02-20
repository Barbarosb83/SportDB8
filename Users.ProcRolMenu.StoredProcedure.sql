USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcRolMenu]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcRolMenu]
@UserId int,
@Username nvarchar(50)
AS
BEGIN

exec [Log].[ProcTransactionLogUID] 3,0,@Username,null,null,null,null


SELECT     Users.Controls.Name, Users.Controls.Title, Users.Controls.ParentControlId, Users.Controls.Icon
FROM         Users.Users INNER JOIN
                      Users.UserRoles ON Users.Users.UserId = Users.UserRoles.UserId INNER JOIN
                      Users.RoleControls ON Users.UserRoles.RoleId = Users.RoleControls.RoleId INNER JOIN
                      Users.Controls ON Users.RoleControls.ControlId = Users.Controls.ControlId
WHERE     (Users.Controls.ControlTypeId = 1 or Users.Controls.ControlTypeId=3) and Users.Users.UserId=@UserId


END


GO
