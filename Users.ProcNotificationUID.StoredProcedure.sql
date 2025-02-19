USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcNotificationUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcNotificationUID] 
@UserId int,
@NotyFormId int,
@ActivityCode int


AS


declare @resultcode int=1


BEGIN 
	SET NOCOUNT ON;
 
 if(@ActivityCode=1)
	begin
	
 		 
		 UPDATE Users.Notifications
			   SET IsNotyRead = 1
		 WHERE ToUserId=@UserId and NotificationFormId=@NotyFormId
		 
		 
  		
	end
select @resultcode
 
END


GO
