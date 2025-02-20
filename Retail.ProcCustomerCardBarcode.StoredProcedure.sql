USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerCardBarcode]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[ProcCustomerCardBarcode] 
@CustomerId bigint,
@BarcodeNumber bigint,
@PIN int,
@UserId int,
@LangId int,
@ActivityCode int
AS
BEGIN
SET NOCOUNT ON;

declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock) where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
--insert dbo.temptabl values(@CustomerId,@UserId,GETDATE(),@ActivityCode)
if @ActivityCode=1 --Control
	begin

		if exists (Select [CardBarcodeId] from [Customer].[CardBarcode] with (nolock) where [CustomerId]=@CustomerId)
			select @resultcode=-1,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock) where ErrorCodeId=173 and Log.ErrorCodes.LangId=@LangId
		else
			begin
			if not exists (Select [CardBarcodeId] from [Customer].[CardBarcode] with (nolock) where Barcode=@BarcodeNumber)
				if exists(select [BarcodeId] from [Parameter].[CardBarcode] with (nolock) where [BarcodeNumber]=@BarcodeNumber and IsUsed=1)
					select @resultcode=0,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock) where ErrorCodeId=174 and Log.ErrorCodes.LangId=@LangId
				else
					select @resultcode=-1,@resultmessage='Card Number Error' from Log.ErrorCodes with (nolock) where ErrorCodeId=174 and Log.ErrorCodes.LangId=@LangId
			else
				select @resultcode=-1,@resultmessage='Card Number Error' from Log.ErrorCodes with (nolock) where ErrorCodeId=174 and Log.ErrorCodes.LangId=@LangId
				--INSERT INTO [Customer].[Card]
				--	   ([CustomerId]
				--	   ,[UserId]
				--	   ,[CreateDate])
				-- VALUES
				--	   (
				--	   @CustomerId
				--	   ,@UserId
				--	   ,GETDATE()
				--	   )
			end
	end
else if @ActivityCode=2
	begin
		if not exists(select Customer.CardBarcode.CardBarcodeId from Customer.CardBarcode with (nolock) where Barcode=@BarcodeNumber)
			begin
				if exists(select [BarcodeId] from [Parameter].[CardBarcode] with (nolock) where [BarcodeNumber]=@BarcodeNumber and IsUsed=1)
					begin
						INSERT INTO [Customer].[CardBarcode]
					   ([CustomerId]
					   ,[Barcode]
					   ,[CreateDate]
					   ,[PIN]
					   ,[TryCount]
					   ,[FirstLogin],UserId)
						VALUES (@CustomerId,@BarcodeNumber,GETDATE(),@PIN,0,1,@UserId)

					   	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock)  where ErrorCodeId=174 and Log.ErrorCodes.LangId=@LangId
					end
			end
		else
			begin
				select @resultcode=-1,@resultmessage='Card Number Error' from Log.ErrorCodes with (nolock) where ErrorCodeId=174 and Log.ErrorCodes.LangId=@LangId
			end
	end
else if @ActivityCode=2
	begin
		if not exists(select Customer.CardBarcode.CardBarcodeId from Customer.CardBarcode with (nolock) where Barcode=@BarcodeNumber)
			begin
				if exists(select [BarcodeId] from [Parameter].[CardBarcode] with (nolock) where [BarcodeNumber]=@BarcodeNumber and IsUsed=1)
					begin
						INSERT INTO [Customer].[CardBarcode]
					   ([CustomerId]
					   ,[Barcode]
					   ,[CreateDate]
					   ,[PIN]
					   ,[TryCount]
					   ,[FirstLogin],UserId)
						VALUES (@CustomerId,@BarcodeNumber,GETDATE(),@PIN,0,1,@UserId)

					   	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock)  where ErrorCodeId=174 and Log.ErrorCodes.LangId=@LangId
					end
			end
		else
			begin
				select @resultcode=-1,@resultmessage='Card Number Error' from Log.ErrorCodes with (nolock) where ErrorCodeId=174 and Log.ErrorCodes.LangId=@LangId
			end
	end
else if @ActivityCode=3
	begin
		if exists(select Customer.CardBarcode.CardBarcodeId from Customer.CardBarcode with (nolock) where Barcode=@BarcodeNumber)
			begin
				if exists(select [BarcodeId] from [Parameter].[CardBarcode] with (nolock) where [BarcodeNumber]=@BarcodeNumber and IsUsed=1)
					begin

						update Customer.CardBarcode set PIN=@PIN,TryCount=0 where Barcode=@BarcodeNumber

					   	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock)  where ErrorCodeId=174 and Log.ErrorCodes.LangId=@LangId
					end
			end
		else
			begin
				select @resultcode=-1,@resultmessage='Card Number Error' from Log.ErrorCodes with (nolock) where ErrorCodeId=174 and Log.ErrorCodes.LangId=@LangId
			end
	end



	
	select @resultcode as resultcode,@resultmessage as resultmessage



END



GO
