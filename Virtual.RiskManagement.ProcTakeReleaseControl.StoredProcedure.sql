USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[RiskManagement.ProcTakeReleaseControl]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[RiskManagement.ProcTakeReleaseControl]
@MatchId bigint,
@username nvarchar(max),
@UserId int,
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

exec [Log].ProcConcatOldValues  'Event','[Virtual]','EventId',@settingId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 2,@ActivityCode,@Username,@settingId,'Virtual.Event'
	,@NewValues,@OldValues


if (@ActivityCode=1)
begin

	update Virtual.Event set Manager=@UserId
		where Virtual.Event.EventId=@MatchId
end
else 
begin
	update Virtual.Event set Manager=null
		where Virtual.Event.EventId=@MatchId
end
	
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@langId

	


	select @resultcode as resultcode,@resultmessage as resultmessage




END


GO
