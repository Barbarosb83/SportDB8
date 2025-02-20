USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcNewsUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcNewsUID]
@NewsId bigint,
@News nvarchar(max),
@LangId int,
@StartDate datetime,
@EndDate datetime,
@IsActive bit,
@CreateUserId int,
@IsTerminalView bit,
@IsBranchView bit,
@IsTvView bit,
@IsWebView bit,
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
		exec [Log].ProcConcatOldValues 'News','[RiskManagement]','NewsId',@NewsId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 14,@ActivityCode,@Username,@NewsId,'RiskManagement.News'
	,@NewValues,@OldValues
	
	UPDATE [RiskManagement].[News]
   SET [News] = @News
      ,[LangId] =@LangId
      ,[StartDate] =DATEADD(HOUR,-3,@StartDate)
      ,[EndDate] = DATEADD(HOUR,-3,@EndDate)
      ,[IsActive] =@IsActive
      ,[CreateUserId] = @CreateUserId
      ,[IsTerminalView] =@IsTerminalView
      ,[IsBranchView] =@IsBranchView
      ,[IsTvView] =@IsTvView
      ,[IsWebView] = @IsWebView
	where NewsId=@NewsId


	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=2
	begin
	--	exec [Log].ProcConcatOldValues 'News','[RiskManagement]','NewsId',@NewsId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID] 14,@ActivityCode,@Username,@NewsId,'RiskManagement.News'
	--,@NewValues,@OldValues
	
	INSERT INTO [RiskManagement].[News]
           ([News]
           ,[LangId]
           ,[StartDate]
           ,[EndDate]
           ,[IsActive]
           ,[CreateUserId]
           ,[IsTerminalView]
           ,[IsBranchView]
           ,[IsTvView]
           ,[IsWebView]
           ,[CreateDate])
     VALUES
           (@News
           ,@LangId
           ,DATEADD(HOUR,-3,@StartDate)
           ,DATEADD(HOUR,-3,@EndDate)
           ,@IsActive
           ,@CreateUserId
           ,@IsTerminalView
           ,@IsBranchView
           ,@IsTvView
           ,@IsWebView
           ,GETDATE())


	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	
	end
else if @ActivityCode=3
	begin
	--	exec [Log].ProcConcatOldValues 'News','[RiskManagement]','NewsId',@NewsId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID] 14,@ActivityCode,@Username,@NewsId,'RiskManagement.News'
	--,@NewValues,@OldValues
	delete from RiskManagement.News where NewsId=@NewsId

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	
	end



	select @resultcode as resultcode,@resultmessage as resultmessage


END



GO
