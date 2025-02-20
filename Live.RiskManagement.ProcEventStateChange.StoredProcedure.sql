USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcEventStateChange]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[RiskManagement.ProcEventStateChange]
@MatchId bigint,
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


select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@langId

exec [Log].ProcConcatOldValues  'EventSetting','[Live]','MatchId',@MatchId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 2,@ActivityCode,@Username,@MatchId,'Live.EventSetting'
	,@NewValues,@OldValues


	update Live.EventSetting set
	StateId=@ActivityCode
	where Live.EventSetting.MatchId=@MatchId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@langId

	


	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
