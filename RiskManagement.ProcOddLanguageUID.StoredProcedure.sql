USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddLanguageUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcOddLanguageUID]
@ParameterOddId int,
@OddsId int,
@LanguageId int,
@OutComes nvarchar(250),
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
		exec [Log].ProcConcatOldValues     'Parameter.Odds','[Language]','ParameterOddId',@ParameterOddId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  33,@ActivityCode,@Username,@ParameterOddId,'Language.[Parameter.Odds]'
	,@NewValues,@OldValues
	
	update Language.[Parameter.Odds] set
	OutComes=@OutComes

	where ParameterOddId=@ParameterOddId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin

	exec [Log].[ProcTransactionLogUID]  33,@ActivityCode,@Username,@ParameterOddId,'Language.[Parameter.Odds]'
	,@NewValues,null
	
	insert Language.[Parameter.Odds](OddsId,LanguageId,OutComes)
	values(@OddsId,@LanguageId,@OutComes)
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
