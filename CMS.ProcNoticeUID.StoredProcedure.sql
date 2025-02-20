USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcNoticeUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [CMS].[ProcNoticeUID]
@NoticeId int,
@Title nvarchar(50),
@Description nvarchar(250),
@SelectedLangId int,
@StartDate datetime,
@EndDate datetime,
@username nvarchar(max),
@LangId int,
@IsActive bit,
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
		exec [Log].ProcConcatOldValues 'Notice','CMS','NoticeId ',@NoticeId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  41,@ActivityCode,@Username,@NoticeId,'CMS.Notice'
	,@NewValues,@OldValues
	

	UPDATE [CMS].Notice
	   SET [Title]= @Title
		  ,[IsActive] = @IsActive
		  ,[StartDate] = @StartDate
		  ,[EndDate] = @EndDate
		  ,[LangId]=@SelectedLangId
		  ,[Description]=@Description
	 WHERE NoticeId =@NoticeId

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=2
	begin

				exec [Log].[ProcTransactionLogUID]  41,@ActivityCode,@Username,@NoticeId,'CMS.Notice'
	,@NewValues,null
	
	INSERT INTO CMS.Notice 
			   (IsActive
			   ,StartDate
			   ,EndDate
			   ,LangId
			   ,CreateDate
			   ,Title
			   ,[Description]
			   ,CreateUser )
		 VALUES
			   (
			   @IsActive
			   ,@StartDate
			   ,@EndDate
			   ,@SelectedLangId
			   ,GETDATE()
			   ,@Title
			   ,@Description
			   ,@username)

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId


	end
else if @ActivityCode=3
	begin
			exec [Log].ProcConcatOldValues 'Notice','CMS','NoticeId ',@NoticeId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  41,@ActivityCode,@Username,@NoticeId,'CMS.Notice'
	,null,@OldValues
	


	DELETE FROM CMS.Notice 
		   WHERE NoticeId=@NoticeId



	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END

GO
