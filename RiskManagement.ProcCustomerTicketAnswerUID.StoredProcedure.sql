USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerTicketAnswerUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerTicketAnswerUID]
@TicketId bigint,
@Answers nvarchar(max),
@UploadFile nvarchar(250),
@StatusId int,
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
	
	update RiskManagement.TicketAnswers set Answer=@Answers,CreateDate=GETDATE()
	where TicketId=@TicketId

	update RiskManagement.Ticket set IsRead=0 where TicketId=@TicketId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin

	
	--exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	--,@NewValues,null
	
INSERT INTO [RiskManagement].[TicketAnswers]
           ([TicketId]
           ,[Answer]
           ,[CreateDate]
           ,[UploadFile],UserId)
     VALUES
		(@TicketId,@Answers,GETDATE(),@UploadFile,@UserId)
	
	update RiskManagement.Ticket set IsRead=0 where TicketId=@TicketId

	if(@StatusId=2)
			update RiskManagement.Ticket set TicketStatusId=2,CloseDate=GETDATE() where TicketId=@TicketId

	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
 
	end
	
	--if @ActivityCode=3
	--begin

	----	exec [Log].ProcConcatOldValues  'BranchBetTypeCommision','[RiskManagement]','BranchBetTypeCommisionId',@BranchBetTypeCommisionId,@OldValues output
	
	----exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	----,null,@OldValues
	
	--delete from [RiskManagement].[Ticket] where TicketId=@TicketId
	
	--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	
	--end
 
	


	select @resultcode as resultcode,@resultmessage as resultmessage
END




GO
