USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcMessageRead]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[ProcMessageRead] 
@UserId int
AS
BEGIN
SET NOCOUNT ON;
 



 declare @Username nvarchar(50)
 
 select @Username=Users.Users.UserName from Users.Users where Users.Users.UserId=@UserId

select   Users.[Message].UserMessageId,FromUserId,Users.Users.Name+' '+Users.Users.Surname as FromName,
Users.[Message].[Subject],
Users.[Message].CreateDate as CreateDate,Users.[Message].[Message],Users.[Message].IsFavorite
FROM         Users.[Message] INNER JOIN
Users.Users ON Users.[Message].FromUserId=Users.Users.UserId
WHERE     Users.[Message].ToUserId=@UserId and  DATEADD(DAY,1,Users.[Message].CreateDate)>=GETDATE()
order by Users.[Message].CreateDate desc

   
update Users.[Message] set IsRead=1,IsFlag=0 where Users.[Message].ToUserId=@UserId


 
END




GO
