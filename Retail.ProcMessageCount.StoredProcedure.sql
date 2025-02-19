USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcMessageCount]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[ProcMessageCount] 
@UserId int
AS
BEGIN
SET NOCOUNT ON;
 

 
select COUNT(Users.[Message].UserMessageId) as MessageCount
FROM         Users.[Message] INNER JOIN
Users.Users ON Users.[Message].FromUserId=Users.Users.UserId
WHERE     Users.[Message].ToUserId=@UserId and IsRead=0
   


   



 
END




GO
