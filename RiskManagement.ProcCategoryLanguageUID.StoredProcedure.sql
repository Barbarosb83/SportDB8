USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCategoryLanguageUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCategoryLanguageUID]
@ParameterCategoryId int,
@CategoryId int,
@LanguageId int,
@CategoryName nvarchar(250),
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
		exec [Log].ProcConcatOldValues     'Parameter.Category','[Language]','ParameterCategoryId',@ParameterCategoryId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  23,@ActivityCode,@Username,@ParameterCategoryId,'Language.[Parameter.Category]'
	,@NewValues,@OldValues
	
	update Language.[Parameter.Category] set
	CategoryName=@CategoryName

	where [Parameter.Category].ParameterCategoryId=@ParameterCategoryId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin

		exec [Log].[ProcTransactionLogUID]  23,@ActivityCode,@Username,@ParameterCategoryId,'Language.[Parameter.Category]'
	,@NewValues,null
	
	insert Language.[Parameter.Category](CategoryId,LanguageId,CategoryName)
	values(@CategoryId,@LanguageId,@CategoryName)
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
