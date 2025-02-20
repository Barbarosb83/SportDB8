USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDepositOxxo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerDepositOxxo] 
@CustomerId bigint,
@OxxoResult int,
@Amount money,
@CurrenyId int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @Balance money
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

if @OxxoResult=5
	begin
		insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId)
		values(@CustomerId,@Amount,@CurrenyId,GETDATE(),7,4)

		select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId


		set @Balance=@Balance+@Amount

		update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
		
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=123 and Log.ErrorCodes.LangId=@LangId
	
	end
else
	begin
		if @OxxoResult=0
			begin
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=118 and Log.ErrorCodes.LangId=@LangId
			end
		else if @OxxoResult=1
			begin
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=119 and Log.ErrorCodes.LangId=@LangId
			end
		else if @OxxoResult=2
			begin
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=120 and Log.ErrorCodes.LangId=@LangId
			end
		else if @OxxoResult=3
			begin
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=121 and Log.ErrorCodes.LangId=@LangId
			end
		else if @OxxoResult=4
			begin
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=122 and Log.ErrorCodes.LangId=@LangId
			end
	end

	select @resultcode as resultcode,@resultmessage as resultmessage
END


GO
