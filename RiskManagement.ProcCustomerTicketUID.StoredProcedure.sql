USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerTicketUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerTicketUID]
@TicketId bigint,
@CustomerId bigint,
@Subject nvarchar(150),
@Description nvarchar(max),
@UploadFile nvarchar(150),
@UserId int,
@LangId int,
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
	--	exec [Log].ProcConcatOldValues  'BranchBetTypeCommision','[RiskManagement]','BranchBetTypeCommisionId',@BranchBetTypeCommisionId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	--,@NewValues,@OldValues
	
	update RiskManagement.Ticket set Subject=@Subject,Description=@Description,UploadFile=@UploadFile,IsRead=0
	where TicketId=@TicketId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin

	
	--exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	--,@NewValues,null
	
	INSERT INTO [RiskManagement].[Ticket]
           ([Subject]
           ,[Description]
           ,[CreateDate]
           ,[CustomerId]
           ,[TicketStatusId]
           ,[UploadFile],IsRead)
     VALUES
		(@Subject,@Description,GETDATE(),@CustomerId,1,@UploadFile,0)

			set @TicketId=SCOPE_IDENTITY()

			INSERT INTO [RiskManagement].[TicketAnswers]
           ([TicketId]
           ,[Answer]
           ,[CreateDate]
           ,[UploadFile],IsRead,UserId)
     VALUES
		(@TicketId,@Description,GETDATE(),@UploadFile,0,@UserId)
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	--execute Users.Notification 1,0,9,158,''
	end
	
	if @ActivityCode=3
	begin

	--	exec [Log].ProcConcatOldValues  'BranchBetTypeCommision','[RiskManagement]','BranchBetTypeCommisionId',@BranchBetTypeCommisionId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	--,null,@OldValues
	
	delete from [RiskManagement].[Ticket] where TicketId=@TicketId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=4
	begin

	
	--exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	--,@NewValues,null
	
	INSERT INTO [RiskManagement].[TicketAnswers]
           ([TicketId]
           ,[Answer]
           ,[CreateDate]
           ,[UploadFile])
     VALUES
		(@TicketId,@Description,GETDATE(),@UploadFile)
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	execute Users.Notification 1,0,9,158,''
	end
	


	select @resultcode as resultcode,@resultmessage as resultmessage
END




GO
