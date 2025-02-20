USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcMenu]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Users].[ProcMenu] 
@Username nvarchar(50) 
AS
BEGIN
SET NOCOUNT ON;
 

 

SELECT     Users.Controls.ControlId,Users.Controls.Name, Users.Controls.Title, Users.Controls.ParentControlId, Users.Controls.Icon, Users.Users.UserName
FROM         Users.UserRoles INNER JOIN
                      Users.RoleControls ON Users.UserRoles.RoleId = Users.RoleControls.RoleId INNER JOIN
                      Users.Users ON Users.UserRoles.UserId = Users.Users.UserId  INNER JOIN
                     Users.Controls ON Users.RoleControls.ControlId = Users.Controls.ControlId INNER JOIN
                      Users.ControlTypes ON Users.Controls.ControlTypeId = Users.ControlTypes.ControlTypeId
WHERE     (Users.Controls.ControlTypeId = 1 ) and Users.Users.Username=@username and  Users.Controls.ControlId not in (131) 
Order By Users.Controls.SeqNumber
END


GO
