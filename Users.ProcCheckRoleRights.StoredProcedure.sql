USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcCheckRoleRights]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcCheckRoleRights]
	@RoleId int,
	@ControlId int
AS
BEGIN

--exec [Log].[ProcTransactionLogUID] 3,0,@Username,null,null,null,null

SELECT [RoleControlId]
      ,[RoleId]
      ,[ControlId]
      ,[IsUpdate]
      ,[IsDelete]
      ,[IsSelect]
      ,[IsInsert]
  FROM [Users].[RoleControls]
 Where [RoleId]=@RoleId and [ControlId]=@ControlId


END


GO
