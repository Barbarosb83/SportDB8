USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerBarcodeSearchTerminal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCustomerBarcodeSearchTerminal] 
@Barcode bigint,
@BranchId int,
@LangId int

AS
BEGIN
SET NOCOUNT ON;

declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @CustomerBranchId bigint
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
 
 declare @customerId bigint=0
 declare @IsFirstLogin bit=0
	 if exists (Select CardBarcodeId from Customer.CardBarcode with (nolock) where Barcode=@Barcode )
		begin
			
			select @customerId=CustomerId,@IsFirstLogin=[FirstLogin] from Customer.CardBarcode with (nolock) where Barcode=@Barcode
				 select @CustomerBranchId= BranchId from Customer.Customer where CustomerId=@customerId 
					if(@CustomerBranchId<>32643)
						begin
						set @resultcode=100
						set @resultmessage='Success'
				 set @resultmessage='The customer is not affiliated with this shop.'
					end
				else
					begin
							set @resultcode=-1 
						set @resultmessage=''
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
