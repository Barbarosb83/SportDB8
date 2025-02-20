USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerBarcode]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCustomerBarcode] 
@Barcode nvarchar(50),
@BranchId int,
@LangId int

AS
BEGIN
SET NOCOUNT ON;

declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
 
 declare @customerId bigint=0

	 if exists (Select CustomerId from Customer.CardBarcode where Barcode=@Barcode and DATEADD(day,1, CreateDate)>=GETDATE())
		begin
			
			select @customerId=CustomerId from Customer.CardBarcode where Barcode=@Barcode
				if exists (select CustomerId from Customer.Customer with (nolock) where CustomerId=@customerId and BranchId in (select BranchId from Parameter.Branch with (nolock) where (BranchId=@BranchId or ParentBranchId=@BranchId)))
					begin
						set @resultcode=100
						set @resultmessage='Success'
					end
				else
					begin
					set @customerId=0
					set @resultcode=-200
						set @resultmessage='The customer is not affiliated with this shop.'
					end
		end
	else
		begin
			if exists (Select CustomerId from Customer.CardBarcode where Barcode=@Barcode and DATEADD(MINUTE,10, CreateDate)<=GETDATE())
				begin
						set @resultcode=-100
						set @resultmessage='Barcode expired. Please create new barcode'
				end
		 
		end
	
	select @customerId as CustomerId,@resultcode as resultcode,@resultmessage as resultmessage



END



GO
