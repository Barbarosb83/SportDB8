USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerQrCode]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcCustomerQrCode]
@BranchId bigint,
@CustomerId bigint,
@LangId int

AS




BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
 

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
 

  if not exists (Select BranchId from  [Customer].[QrCode] with (nolock) where [BranchId]=@BranchId)
	begin
		  INSERT INTO [Customer].[QrCode]
				   ([BranchId]
				   ,[CustomerId]
				   ,[CreateDate])
			 VALUES (@BranchId,@CustomerId,GETDATE())

		  INSERT INTO [Customer].[QrCodeLog]
				   ([BranchId]
				   ,[CustomerId]
				   ,[CreateDate],Comment)
			 VALUES (@BranchId,@CustomerId,GETDATE(),'QR')


			 	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	 end
	 

	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
