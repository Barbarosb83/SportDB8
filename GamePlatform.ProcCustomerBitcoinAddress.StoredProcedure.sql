USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBitcoinAddress]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcCustomerBitcoinAddress] 
@CustomerId bigint,
@BitcoinAddress nvarchar(150)
AS

BEGIN
SET NOCOUNT ON;

declare @result int=1

 if exists (SELECT Customer.Bitcoin.BitcoinId  from Customer.Bitcoin where Customer.Bitcoin.BitcoinAddress=@BitcoinAddress and Customer.Bitcoin.CustomerId<>@CustomerId)
			set @result=0
 else
	begin
		if(select count(Customer.BitcoinTransaction.BitcoinTransactionId) from Customer.BitcoinTransaction where InvoiceId=@BitcoinAddress)=0
			begin
				if exists (SELECT Customer.Bitcoin.BitcoinId  from Customer.Bitcoin where   Customer.Bitcoin.CustomerId=@CustomerId)
					  update Customer.Bitcoin set Customer.Bitcoin.BitcoinAddress=@BitcoinAddress where Customer.Bitcoin.CustomerId=@CustomerId

				else
					insert Customer.Bitcoin (CustomerId,Bitcoin,BitcoinAddress,CreateDate)
					values (@CustomerId,0,@BitcoinAddress,GETDATE())
			end
		else
			set @result=0


	end

	return @result
	




END



GO
