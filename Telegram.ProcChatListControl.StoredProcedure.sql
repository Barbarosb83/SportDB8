USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Telegram].[ProcChatListControl]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Telegram].[ProcChatListControl]
@TelegramChatId bigint,
@ChatUser nvarchar(150)
AS

BEGIN

declare @result int=0


	if exists (Select Telegram.Chat.ChatId from Telegram.Chat where TelegramId=@TelegramChatId and IsActive=1)
		set @result=1
	else
		begin
			if not exists (Select Telegram.Chat.ChatId from Telegram.Chat where TelegramId=@TelegramChatId)
				insert Telegram.Chat(TelegramId,TelegramUser,IsActive,CreateDate)
				values (@TelegramChatId,@ChatUser,0,GETDATE())		

		end


		select @result
END



GO
