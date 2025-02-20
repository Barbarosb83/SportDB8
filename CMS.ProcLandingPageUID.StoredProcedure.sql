USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcLandingPageUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [CMS].[ProcLandingPageUID]
@LandingPageId int,
@ItemName nvarchar(150),
@FileName nvarchar(50),
@IsActive bit,
@StartDate datetime,
@EndDate datetime,
@Link nvarchar(150),
@SelectedLangId int,
@LangId int,
@PositionId int,
@Title nvarchar(50),
@Description nvarchar(250),
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
		exec [Log].ProcConcatOldValues   'LandingPage','CMS','LandingPageId ',@LandingPageId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  34,@ActivityCode,@Username,@LandingPageId,'CMS.LandingPage'
	,@NewValues,@OldValues
	

	UPDATE [CMS].LandingPage
	   SET ItemName = @ItemName
		  ,[IsActive] = @IsActive
		  ,[StartDate] = @StartDate
		  ,[EndDate] = @EndDate
		  ,[LangId]=@SelectedLangId
		  ,[Link]=@Link
		  ,PositionId =@PositionId
		  ,Title =@Title
		  ,[Description]=@Description
	 WHERE LandingPageId =@LandingPageId

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=2
	begin

			exec [Log].[ProcTransactionLogUID]  34,@ActivityCode,@Username,@LandingPageId,'CMS.LandingPage'
	,@NewValues,null
	
	INSERT INTO CMS.LandingPage 
			   (ItemName
			   ,[FileName]
			   ,IsActive
			   ,StartDate
			   ,EndDate
			   ,LangId
			   ,Link
			   ,PositionId
			   ,Title
			   ,[Description] )
		 VALUES
			   (@ItemName
			   ,@FileName
			   ,@IsActive
			   ,@StartDate
			   ,@EndDate
			   ,@SelectedLangId
			   ,@Link
			   ,@PositionId
			   ,@Title
			   ,@Description)

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId


	end
else if @ActivityCode=3
	begin
			exec [Log].ProcConcatOldValues   'LandingPage','CMS','LandingPageId ',@LandingPageId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  34,@ActivityCode,@Username,@LandingPageId,'CMS.LandingPage'
	,null,@OldValues
	


	DELETE FROM CMS.LandingPage 
		   WHERE LandingPageId=@LandingPageId



	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
