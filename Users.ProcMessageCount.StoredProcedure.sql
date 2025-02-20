USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcMessageCount]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcMessageCount] 
@UserId int
AS
BEGIN
SET NOCOUNT ON;

declare @UnreadCount int
declare @StarCount int

select  @UnreadCount=ISNULL(COUNT( UserMessageId),0)
FROM         Users.[Message]
WHERE     Users.[Message].IsRead=0 and Users.[Message].ToUserId=@UserId and IsDeleted=0

select  @StarCount=ISNULL(COUNT( UserMessageId),0)
FROM         Users.[Message]
WHERE     Users.[Message].IsFavorite=1 and Users.[Message].ToUserId=@UserId and IsDeleted=0

   
select ISNULL(@UnreadCount,0) as UnreadCount,ISNULL(@StarCount,0) as StarCount

 
END


GO
