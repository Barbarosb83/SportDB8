USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDeviceUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerDeviceUID]
@CustomerId bigint,
@DeviceId nvarchar(150),
@AndroidToken nvarchar(150),
@IOSToken nvarchar(150),
@IsNotification bit,
@ActivityCode int 


AS




BEGIN
SET NOCOUNT ON;


declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=2


if @ActivityCode=1
	begin
	--	exec [Log].ProcConcatOldValues  'BranchBetTypeCommision','[RiskManagement]','BranchBetTypeCommisionId',@BranchBetTypeCommisionId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	--,@NewValues,@OldValues
	
	update [Customer].[DeviceToken] set [DeviceId]=@DeviceId,[AndroidToken]=@AndroidToken,[IOSToken]=@IOSToken where CustomerId=@CustomerId
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=2
	
	
	end
if @ActivityCode=2
	begin

	
	--exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	--,@NewValues,null
	
	INSERT INTO [Customer].[DeviceToken]
           ([CustomerId]
           ,[DeviceId]
           ,[AndroidToken]
           ,[IOSToken]
           ,[CreateDate]
           ,[IsNotification])
     VALUES (@CustomerId,@DeviceId,@AndroidToken,@IOSToken,GETDATE(),@IsNotification)

	 select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=2
	end
	
	--if @ActivityCode=3
	--begin

	----	exec [Log].ProcConcatOldValues  'BranchBetTypeCommision','[RiskManagement]','BranchBetTypeCommisionId',@BranchBetTypeCommisionId,@OldValues output
	
	----exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	----,null,@OldValues
	
	--delete from [RiskManagement].[Ticket] where TicketId=@TicketId
	
	--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=2
	
	
	--end
--if @ActivityCode=4
--	begin

	
--	--exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
--	--,@NewValues,null
	
--	INSERT INTO [RiskManagement].[TicketAnswers]
--           ([TicketId]
--           ,[Answer]
--           ,[CreateDate]
--           ,[UploadFile])
--     VALUES
--		(@TicketId,@Description,GETDATE(),@UploadFile)
	
--	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
--	execute Users.Notification 1,0,9,158,''
--	end
	


	select @resultcode as resultcode,@resultmessage as resultmessage
END




GO
