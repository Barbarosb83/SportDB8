USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddTypeLanguageUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcOddTypeLanguageUID]
@ParameterOddTypeId int,
@OddsTypeId int,
@LanguageId int,
@OddsType nvarchar(250),
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
		exec [Log].ProcConcatOldValues     'Parameter.OddsType','[Language]','ParameterOddsTypeId',@ParameterOddTypeId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  11,@ActivityCode,@Username,@ParameterOddTypeId,'Language.[Parameter.OddsType]'
	,@NewValues,@OldValues
	
	update Language.[Parameter.OddsType] set
	OddsType=@OddsType,ShortOddType=@OddsType

	where ParameterOddsTypeId=@ParameterOddTypeId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin

	exec [Log].[ProcTransactionLogUID]  11,@ActivityCode,@Username,@ParameterOddTypeId,'Language.[Parameter.OddsType]'
	,@NewValues,null
	
	insert Language.[Parameter.OddsType](OddsTypeId,LanguageId,OddsType)
	values(@OddsTypeId,@LanguageId,@OddsType)
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
