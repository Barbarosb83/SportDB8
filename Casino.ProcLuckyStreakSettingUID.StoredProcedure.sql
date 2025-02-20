USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Casino].[ProcLuckyStreakSettingUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Casino].[ProcLuckyStreakSettingUID]
@accesstoken nvarchar(max),
@refreshtoken nvarchar(max),
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)


AS




BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


if(@ActivityCode=1)
	begin
		
		update Casino.[LuckyStreak.Setting] set
		Casino.[LuckyStreak.Setting].AccessToken=@accesstoken
		,Casino.[LuckyStreak.Setting].RefreshToken=@refreshtoken
		
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

		
	End
	
	select @resultcode as resultcode,@resultmessage as resultmessage

END


GO
