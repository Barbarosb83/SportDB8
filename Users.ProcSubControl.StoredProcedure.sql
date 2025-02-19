USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcSubControl]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcSubControl]
@ControlId int,
@Username nvarchar(50)
AS
BEGIN

--exec [Log].[ProcTransactionLogUID] 3,0,@Username,null,null,null,null


SELECT     Users.Controls.ControlId, Users.Controls.Name, Users.Controls.Title
FROM         Users.Controls
WHERE     ( Users.Controls.ControlTypeId = 2) AND ( Users.Controls.ParentControlId = @ControlId)
ORDER BY SeqNumber

END


GO
