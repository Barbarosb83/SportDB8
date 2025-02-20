USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDepositBitcoin]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerDepositBitcoin] 
@CustomerId bigint,
@IsSuccessfull bit,
@BitcoinInvoiceId int,
@BitcoinTranscationId nvarchar(max),
@Amount money,
@CurrenyId int
AS

BEGIN
SET NOCOUNT ON;

declare @Balance money
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

if @IsSuccessfull=1
	begin
	
		insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId)
		values(@CustomerId,@Amount,@CurrenyId,GETDATE(),27,1)

		select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

		set @Balance=@Balance+@Amount

		update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
		
		--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=123 and Log.ErrorCodes.LangId=@LangId
	
	end

	INSERT INTO [Log].[ErrorLog] ([Username],[MethodName],[SpName],[Message],[StackTrace],[Parameters],[CreateDate])
     VALUES ('System'
           ,'BitcoinDeposit'
           ,'ProcCustomerDepositBitcoin'
           ,'Bitcoin Deposit'
           ,cast(@IsSuccessfull as nvarchar(max))
           ,cast(@BitcoinInvoiceId as nvarchar(max)) +'|'+ cast(@BitcoinTranscationId as nvarchar(max)) +'|'+ cast(@Amount as nvarchar(max))+'|'+cast(@CurrenyId as nvarchar(max))
           ,GetDate())
	
END


GO
