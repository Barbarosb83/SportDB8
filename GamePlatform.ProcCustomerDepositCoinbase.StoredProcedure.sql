USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDepositCoinbase]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcCustomerDepositCoinbase] 
@CustomerId bigint,
@DepositTransferId bigint,
@IsSuccessfull bit,
@ReferenceCode nvarchar(50)

AS

BEGIN
SET NOCOUNT ON;

declare @Balance money
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @Amount money
declare @DepositStatuId int
declare @CurrenyId int=1
declare @CustomerCurrency int
if @IsSuccessfull=1
	begin

		select @CustomerId=CustomerId,@Amount=[Customer].[DepositTransfer].DepositAmount,@DepositStatuId=[DepositStatuId] from [Customer].[DepositTransfer] WHERE DepositTransferId=@DepositTransferId
		select @CustomerCurrency=CurrencyId from Customer.Customer where Customer.Customer.CustomerId=@CustomerId
		if (@DepositStatuId=1)
		begin
 

			select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

			set @Balance=@Balance+dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@CustomerCurrency)

				insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionBalance)
			values(@CustomerId,@Amount,@CurrenyId,GETDATE(),61,1,@Balance)

			update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
		
			--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=123 and Log.ErrorCodes.LangId=@LangId
	
			UPDATE [Customer].[DepositTransfer]  SET [DepositStatuId] = 2,[UpdateDate] = GetDate(),[CustomerNote]=@ReferenceCode WHERE DepositTransferId=@DepositTransferId

		execute [RiskManagement].[ProcCustomerBonusCreate] @CustomerId,@CurrenyId,@Balance,@Amount

		end
	end
else
	begin

		select @DepositStatuId=[DepositStatuId] from [Customer].[DepositTransfer] WHERE DepositTransferId=@DepositTransferId
		

		if (@DepositStatuId=1)
			begin
				UPDATE [Customer].[DepositTransfer]  SET [DepositStatuId] = 3,[UpdateDate] = GetDate(),[CustomerNote]=@ReferenceCode WHERE DepositTransferId=@DepositTransferId
			end
	end
	
	
END


GO
