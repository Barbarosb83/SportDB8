USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerBarcodePINChange]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcCustomerBarcodePINChange] 
@Barcode bigint,
@OldPIN int,
@PIN int,
@LangId int

AS
BEGIN
SET NOCOUNT ON;

declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
 
 declare @customerId bigint=0
 declare @IsFirstLogin bit=0
	 if exists (Select CardBarcodeId from Customer.CardBarcode with (nolock) where Barcode=@Barcode )
		begin
			select @customerId=CustomerId from Customer.CardBarcode with (nolock) where Barcode=@Barcode
			if exists (Select CardBarcodeId from Customer.CardBarcode with (nolock) where Barcode=@Barcode and PIN=@OldPIN)
				begin
				 update Customer.CardBarcode set TryCount=0,FirstLogin=0,PIN=@PIN where CustomerId=@customerId
				 
						set @resultcode=100
						set @resultmessage='Success'
				 
				 end
			else
				begin
					update Customer.CardBarcode set TryCount=TryCount+1 where CustomerId=@customerId
					set @resultcode=-1
						set @resultmessage='Failed'
				end
		end
	else
		begin
		 
						set @resultcode=-1 
						set @resultmessage=''
			 
		 
		end
	
	select @customerId as CustomerId,@IsFirstLogin as [FirstLogin],@resultcode as resultcode,@resultmessage as resultmessage



END



GO
