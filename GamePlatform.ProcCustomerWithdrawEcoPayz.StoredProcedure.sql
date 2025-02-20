USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerWithdrawEcoPayz]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerWithdrawEcoPayz] 
@CustomerId bigint,
@IsSuccessfull bit,
@ecoPayzResultCode int,
@ecoPayzAccountId nvarchar(max),
@ecoPayzTranscationId nvarchar(max),
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

if @IsSuccessfull=1
	begin
	
		insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId)
		values(@CustomerId,@Amount,@CurrenyId,GETDATE(),22,1)

		select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

		set @Balance=@Balance-@Amount

		update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
		
		--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=123 and Log.ErrorCodes.LangId=@LangId
	
	end

	INSERT INTO [Log].[ErrorLog] ([Username],[MethodName],[SpName],[Message],[StackTrace],[Parameters],[CreateDate])
     VALUES (@UserName
           ,'ecoPayzWithdraw'
           ,'ProcCustomerWithdrawEcoPayz'
           ,'ecoPayz Withdraw'
           ,cast(@IsSuccessfull as nvarchar(max))
           ,cast(@ecoPayzResultCode as nvarchar(max)) +'|'+ cast(@ecoPayzAccountId as nvarchar(max)) +'|'+ cast(@ecoPayzAccountId as nvarchar(max))+'|'+cast(@ecoPayzTranscationId as nvarchar(max))+'|'+cast(@Amount as nvarchar(max))+'|'+cast(@CurrenyId as nvarchar(max))
           ,GetDate())
	
END


GO
