USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcMessageSentbox]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcMessageSentbox] 
@UserId int
AS
BEGIN
SET NOCOUNT ON;
 

select   UserMessageId,ToUserId,Users.Users.Name+' '+Users.Users.Surname as FromName,Users.[Message].[Subject],Users.[Message].CreateDate
,Users.[Message].IsRead,Users.[Message].IsFavorite
FROM         Users.[Message] INNER JOIN
Users.Users ON Users.[Message].ToUserId=Users.Users.UserId
WHERE     Users.[Message].IsDeleted=0 and Users.[Message].FromUserId=@UserId
Order By Users.[Message].CreateDate desc
   


 
END


GO
