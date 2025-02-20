USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcEmailUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CMS].[ProcEmailUID]
@EmailTemplateId int,
@HTML nvarchar(max),
@MailSubject nvarchar(max),
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
		exec [Log].ProcConcatOldValues  'EmailTemplate','General','EmailTemplateId',@EmailTemplateId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  34,@ActivityCode,@Username,@EmailTemplateId,'General.EmailTemplate'
	,@NewValues,@OldValues
	

	
UPDATE [General].[EmailTemplate]
   SET [HTML] = @HTML
      ,[MailSubject] = @MailSubject
 WHERE EmailTemplateId=@EmailTemplateId



	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=2
	begin

	--	exec [Log].[ProcTransactionLogUID]  34,@ActivityCode,@Username,@PageId,'CMS.Page'
	--,@NewValues,null
	
	
	--INSERT INTO [General].[EmailTemplate]
	--		   ([EmailTemplateId]
	--		   ,[TemplateName]
	--		   ,[Purpose]
	--		   ,[LanguageId]
	--		   ,[HTML]
	--		   ,[MailSubject])
	--	 VALUES
	--		   (<EmailTemplateId, int,>
	--		   ,<TemplateName, nvarchar(50),>
	--		   ,<Purpose, nvarchar(50),>
	--		   ,<LanguageId, int,>
	--		   ,<HTML, nvarchar(max),>
	--		   ,<MailSubject, nvarchar(max),>)



	--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId

	select @resultcode as resultcode,@resultmessage as resultmessage
	end
else if @ActivityCode=3
	begin
	--	exec [Log].ProcConcatOldValues  'Page','CMS','PageId',@PageId,@OldValues output
	
	--	exec [Log].[ProcTransactionLogUID]  34,@ActivityCode,@Username,@PageId,'CMS.Page'
	--,@NewValues,@OldValues
	


	--DELETE FROM [CMS].[Page]
	--	   WHERE PageId=@PageId



	--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	select @resultcode as resultcode,@resultmessage as resultmessage
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
