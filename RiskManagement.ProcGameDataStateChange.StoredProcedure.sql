USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataStateChange]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameDataStateChange]
@MatchId int,
@username nvarchar(max),
@langId int,
@ActivityCode int,
@NewValues nvarchar(max)


AS

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @settingId int


BEGIN
SET NOCOUNT ON;

select @settingId=Match.Setting.SettingId from Match.Setting
where Match.Setting.MatchId=@MatchId

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock)  where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@langId

declare @FixtureId int

select @FixtureId=Match.Fixture.FixtureId from Match.Fixture  with (nolock) 
where Match.Fixture.MatchId=@MatchId


exec [Log].ProcConcatOldValues  'Setting','[Match]','SettingId',@settingId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 2,@ActivityCode,@Username,@settingId,'Match.Setting'
	,@NewValues,@OldValues


	update Match.Setting set
	StateId=@ActivityCode
	where SettingId=@settingId
	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes  with (nolock) where ErrorCodeId=103 and Log.ErrorCodes.LangId=@langId

	


	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
