USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Users].[ProcMessageIsFavorite]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Users].[ProcMessageIsFavorite] 
@UserMessageId int
AS
BEGIN
SET NOCOUNT ON;
 

update Users.[Message] set IsFavorite=1 where Users.[Message].UserMessageId=@UserMessageId
   
select 1 as codes,'' messagess

 
END


GO
