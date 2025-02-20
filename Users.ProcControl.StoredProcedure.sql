USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcControl]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcControl]
	@Username nvarchar(50),
	@RoleId int
AS
BEGIN

--exec [Log].[ProcTransactionLogUID] 3,0,@Username,null,null,null,null



SELECT     Users.Controls.ControlId, Users.Controls.Title, Users.Controls.ControlTypeId, Users.Controls.ParentControlId, Users.Controls.Icon, 
                      Users.Controls.Description, Users.RoleControls.RoleControlId, Users.RoleControls.RoleId, Users.RoleControls.IsUpdate, 
                      Users.RoleControls.IsDelete, Users.RoleControls.IsSelect, Users.RoleControls.IsInsert
FROM         Users.Controls left   JOIN
                      Users.RoleControls ON Users.Controls.ControlId = Users.RoleControls.ControlId and Users.RoleControls.RoleId = @RoleId



END


GO
