USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSportLanguageUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSportLanguageUID]
@ParameterSportId int,
@SportId int,
@LanguageId int,
@SportName nvarchar(250),
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


if @ActivityCode=1
	begin
		exec [Log].ProcConcatOldValues     'Parameter.Sport','[Language]','ParameterSportId',@ParameterSportId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  13,@ActivityCode,@Username,@ParameterSportId,'Language.[Parameter.Sport]'
	,@NewValues,@OldValues
	
	update Language.[Parameter.Sport] set
	SportName=@SportName

	where ParameterSportId=@ParameterSportId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin

	exec [Log].[ProcTransactionLogUID]  13,@ActivityCode,@Username,@ParameterSportId,'Language.[Parameter.Sport]'
	,@NewValues,null
	
	insert Language.[Parameter.Sport](SportId,LanguageId,SportName)
	values(@SportId,@LanguageId,@SportName)
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
