USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcPageUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [CMS].[ProcPageUID]
@PageId int,
@PageTitle nvarchar(150),
@LangId int,
@HtmlContent nvarchar(max),
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
		exec [Log].ProcConcatOldValues  'Page','CMS','PageId',@PageId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  34,@ActivityCode,@Username,@PageId,'CMS.Page'
	,@NewValues,@OldValues
	

	UPDATE [CMS].[Page]
	   SET [PageTitle] = @PageTitle
		  ,[LangId] = @LangId
		  ,[HtmlContent] = @HtmlContent
	 WHERE PageId=@PageId

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=2
	begin

		exec [Log].[ProcTransactionLogUID]  34,@ActivityCode,@Username,@PageId,'CMS.Page'
	,@NewValues,null
	
	INSERT INTO [CMS].[Page]
           ([PageTitle]
           ,[LangId]
           ,[HtmlContent])
     VALUES
           (@PageTitle
           ,@LangId
           ,@HtmlContent)

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId


	end
else if @ActivityCode=3
	begin
		exec [Log].ProcConcatOldValues  'Page','CMS','PageId',@PageId,@OldValues output
	
		exec [Log].[ProcTransactionLogUID]  34,@ActivityCode,@Username,@PageId,'CMS.Page'
	,@NewValues,@OldValues
	


	DELETE FROM [CMS].[Page]
		   WHERE PageId=@PageId



	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
