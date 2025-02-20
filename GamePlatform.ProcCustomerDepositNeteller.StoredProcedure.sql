USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDepositNeteller]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerDepositNeteller] 
@CustomerId bigint,
@IsSuccessfull bit,
@NetellerResultCode int,
@NetellerAccountId nvarchar(max),
@NetellerTranscationId nvarchar(max),
@Amount money,
@CurrenyId int,
@UserName nvarchar(max),
@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @Balance money
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

declare @CustomerCreateDate datetime
if @IsSuccessfull=1
	begin
	
		insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId)
		values(@CustomerId,@Amount,@CurrenyId,GETDATE(),15,1)

		select @Balance=ISNULL(Customer.Customer.Balance,0),@CustomerCreateDate=CreateDate from Customer.Customer where Customer.CustomerId=@CustomerId

		set @Balance=@Balance+@Amount

		update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
		exec [Bonus].[ProcBonusCustomer]  @CustomerId,@Amount,@CurrenyId,@CustomerCreateDate,2
		--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=123 and Log.ErrorCodes.LangId=@LangId
	
	end

	INSERT INTO [Log].[ErrorLog] ([Username],[MethodName],[SpName],[Message],[StackTrace],[Parameters],[CreateDate])
     VALUES (@UserName
           ,'NetellerDeposit'
           ,'ProcCustomerDepositNeteller'
           ,'Neteller Deposit'
           ,cast(@IsSuccessfull as nvarchar(max))
           ,cast(@NetellerResultCode as nvarchar(max)) +'|'+ cast(@NetellerAccountId as nvarchar(max)) +'|'+ cast(@NetellerAccountId as nvarchar(max))+'|'+cast(@NetellerTranscationId as nvarchar(max))+'|'+cast(@Amount as nvarchar(max))+'|'+cast(@CurrenyId as nvarchar(max))
           ,GetDate())
	
END


GO
