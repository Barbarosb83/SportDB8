USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerCardBarcode]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerCardBarcode]
@CustomerId bigint


AS




BEGIN
SET NOCOUNT ON;
 declare @Barcode nvarchar(50)=''

   if exists (Select CustomerId from Customer.CardBarcode where CustomerId=@CustomerId and DATEADD(MINUTE,10, CreateDate)>=GETDATE())
	begin
		select @Barcode=Barcode from Customer.CardBarcode where CustomerId=@CustomerId


	end
	else
		begin
			delete from Customer.CardBarcode where CustomerId=@CustomerId
			
			select @Barcode='800'+SUBSTRING( CAST(NEWID() as nvarchar(50)),0,9)+CAST(@CustomerId as nvarchar(50))

			INSERT INTO [Customer].[CardBarcode]
           ([CustomerId]
           ,[Barcode]
           ,[CreateDate])
     VALUES (@CustomerId,@Barcode,GETDATE())

		

		end

                      
select @Barcode as Barcode
END



GO
