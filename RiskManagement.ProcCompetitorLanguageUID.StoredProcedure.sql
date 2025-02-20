USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCompetitorLanguageUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCompetitorLanguageUID]
@ParameterCompetitorId bigint,
@CompetitorId bigint,
@LanguageId int,
@CompetitorName nvarchar(250),
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
		exec [Log].ProcConcatOldValues     'ParameterCompetitor','[Language]','ParameterCompetitorId',@ParameterCompetitorId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  15,@ActivityCode,@Username,@ParameterCompetitorId,'Language.[ParameterCompetitor]'
	,@NewValues,@OldValues
	
	update Language.[ParameterCompetitor] set
	CompetitorName=@CompetitorName

	where ParameterCompetitorId=@ParameterCompetitorId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin

	
	exec [Log].[ProcTransactionLogUID]  15,@ActivityCode,@Username,@ParameterCompetitorId,'Language.[ParameterCompetitor]'
	,@NewValues,null
	
	insert Language.[ParameterCompetitor](CompetitorId,LanguageId,CompetitorName)
	values(@CompetitorId,@LanguageId,@CompetitorName)
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
