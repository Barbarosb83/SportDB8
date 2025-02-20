USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcGetUsersEmailbyControlId]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 


CREATE PROCEDURE [Users].[ProcGetUsersEmailbyControlId] 
@ControlId int
AS
BEGIN
SET NOCOUNT ON;
 
SELECT  DISTINCT   Users.Users.UserName, Users.Users.Name,Users.Users.Surname,Users.Users.Email,Users.GsmNo,Users.PhoneNumber
FROM         Users.Controls left   JOIN
                      Users.RoleControls ON Users.Controls.ControlId = Users.RoleControls.ControlId inner join
			Users.UserRoles on Users.UserRoles.RoleId=Users.RoleControls.RoleId inner join
			Users.Users on Users.UserId=Users.UserRoles.UserId
Where Users.UserId= 1435 and Users.RoleControls.IsUpdate=1 and Users.Users.IsDeleted=0



END





GO
