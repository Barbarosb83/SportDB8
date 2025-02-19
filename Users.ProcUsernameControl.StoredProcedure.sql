USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcUsernameControl]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcUsernameControl]

@Username nvarchar(50)
AS
BEGIN

declare @result int=1
--exec [Log].[ProcTransactionLogUID] 3,0,@Username,null,null,null,null


if(SELECT     COUNT(*)
FROM         Users.Users
WHERE     (Users.UserName= @Username))>0
	set @result=0
	
	
	return @result


END


GO
