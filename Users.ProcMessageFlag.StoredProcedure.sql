USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcMessageFlag]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcMessageFlag] 
@UserId int
AS
BEGIN
SET NOCOUNT ON;
 

select   UserMessageId,FromUserId,Users.Users.Name+' '+Users.Users.Surname as FromName,[Subject],Users.Message.CreateDate
FROM         Users.Message INNER JOIN
Users.Users ON Users.Message.FromUserId=Users.Users.UserId
WHERE     Users.Message.IsFlag=1 and ToUserId=@UserId
   


 
END


GO
