USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [CMS].[ProcSliderUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [CMS].[ProcSliderUID]
@SliderId int,
@SliderItemName nvarchar(150),
@FileName nvarchar(150),
@IsActive bit,
@StartDate datetime,
@EndDate datetime,
@Link nvarchar(150),
@SelectedLangId int,
@LangId int,
@SeqNo int,
@MobilLink nvarchar(150),
@Title nvarchar(50),
@Descripton nvarchar(150),
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
		exec [Log].ProcConcatOldValues  'Slider','CMS','SliderId',@SliderId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID]  34,@ActivityCode,@Username,@SliderId,'CMS.Slider'
	,@NewValues,@OldValues
	

	UPDATE [CMS].[Slider]
	   SET [SliderItemName] = @SliderItemName
		  ,[IsActive] = @IsActive
		  ,[StartDate] = @StartDate
		  ,[EndDate] = @EndDate
		  ,[LangId]=@SelectedLangId
		  ,[Link]=@Link
		  ,[SeqNo]=@SeqNo
		  ,MobileLink=@MobilLink
		  ,[Description]=@Descripton
		  ,[Title]=@Title
	 WHERE SliderId=@SliderId

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=2
	begin

		exec [Log].[ProcTransactionLogUID]  34,@ActivityCode,@Username,@SliderId,'CMS.Slider'
	,@NewValues,null
	
	INSERT INTO [CMS].[Slider]
			   ([SliderItemName]
			   ,[FileName]
			   ,[IsActive]
			   ,[StartDate]
			   ,[EndDate]
			   ,[LangId]
			   ,[Link]
			   ,[SeqNo]
			   ,[MobileLink]
			   ,[Title]
			   ,[Description] )
		 VALUES
			   (@SliderItemName
			   ,@FileName
			   ,@IsActive
			   ,@StartDate
			   ,@EndDate
			   ,@SelectedLangId
			   ,@Link
			   ,@SeqNo
			   ,@MobilLink
			   ,@Title
			   ,@Descripton)

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId


	end
else if @ActivityCode=3
	begin
		exec [Log].ProcConcatOldValues  'Slider','CMS','SliderId',@SliderId,@OldValues output
	
		exec [Log].[ProcTransactionLogUID]  34,@ActivityCode,@Username,@SliderId,'CMS.Slider'
	,@NewValues,@OldValues
	


	DELETE FROM [CMS].[Slider]
		   WHERE SliderId=@SliderId



	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	
	end


	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
