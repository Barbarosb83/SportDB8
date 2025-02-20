USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcMobilMenuUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [CMS].[ProcMobilMenuUID]
@MobileHomeMenuId int,
@Title nvarchar(150),
@Icon nvarchar(50),
@SelectedLangId int,
@NavigateURL nvarchar(50),
@Position int,
@IsTop bit,
@SportId int,
@TournamentId nvarchar(max),
@TimeRangeId int,
@IsEnable bit,
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
		exec [Log].ProcConcatOldValues   'MobileHomeMenu','CMS','MobileHomeMenuId',@MobileHomeMenuId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  40,@ActivityCode,@Username,@MobileHomeMenuId,'CMS.MobileHomeMenu'
	,@NewValues,@OldValues
	

	UPDATE [CMS].MobileHomeMenu
	   SET [Title] = @Title
		  --,[Icon] = @Icon
		  ,[LanguageId] = @SelectedLangId
		  ,[NavigateURL] = @NavigateURL
		  ,[Position] =@Position
		  ,[IsTop] =@IsTop
		  ,[SportId] =@SportId
		  ,[TournamentId] =@TournamentId
		  ,[TimeRangeId] =@TimeRangeId
		  ,[IsEnabled] =@IsEnable
	 WHERE [MobileHomeMenuId] =@MobileHomeMenuId

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=2
	begin

			exec [Log].[ProcTransactionLogUID]  40,@ActivityCode,@Username,@MobileHomeMenuId,'CMS.MobileHomeMenu'
	,@NewValues,null
	
	INSERT INTO [CMS].[MobileHomeMenu]
           ( [Title]
           ,[Icon]
           ,[LanguageId]
           ,[NavigateURL]
           ,[Position]
           ,[IsTop]
           ,[SportId]
           ,[TournamentId]
           ,[TimeRangeId]
           ,[IsEnabled])
     VALUES
           (@Title,@Icon,@SelectedLangId,@NavigateURL,@Position,@IsTop,@SportId,@TournamentId,@TimeRangeId,@IsEnable)

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId


	end
else if @ActivityCode=3
	begin
		exec [Log].ProcConcatOldValues   'MobileHomeMenu','CMS','MobileHomeMenuId',@MobileHomeMenuId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  40,@ActivityCode,@Username,@MobileHomeMenuId,'CMS.MobileHomeMenu'
	,@NewValues,@OldValues
	


	DELETE FROM [CMS].MobileHomeMenu
		   WHERE MobileHomeMenuId=@MobileHomeMenuId



	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END

GO
