USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcMessageInbox]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcMessageInbox] 
@UserId int
AS
BEGIN
SET NOCOUNT ON;
 
 
 declare @Username nvarchar(50)
 
 select @Username=Users.Users.UserName from Users.Users where Users.Users.UserId=@UserId

select   UserMessageId,FromUserId,Users.Users.Name+' '+Users.Users.Surname as FromName,Users.[Message].[Subject], dbo.UserTimeZoneDate(@Username,Users.[Message].CreateDate,0) as CreateDate
,Users.[Message].IsRead,Users.[Message].IsFavorite
FROM         Users.[Message] INNER JOIN
Users.Users ON Users.[Message].FromUserId=Users.Users.UserId
WHERE     Users.[Message].IsDeleted=0 and Users.[Message].ToUserId=@UserId
Order By Users.[Message].CreateDate desc
   


 
END


GO
