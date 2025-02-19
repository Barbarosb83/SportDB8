USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcMessageSendRead]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcMessageSendRead] 
@UserMessageId int,
@UserId int
AS
BEGIN
SET NOCOUNT ON;
 

--update Users.[Message] set IsRead=1,IsFlag=0 where Users.[Message].UserMessageId=@UserMessageId


select   Users.[Message].UserMessageId,FromUserId,Users.Users.Name+' '+Users.Users.Surname as FromName,
Users.[Message].[Subject],
Users.[Message].CreateDate,Users.[Message].[Message],Users.[Message].IsFavorite
FROM         Users.[Message] INNER JOIN
Users.Users ON Users.[Message].FromUserId=Users.Users.UserId
WHERE     Users.[Message].UserMessageId=@UserMessageId
   


 
END


GO
