USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerDepositNapal]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerDepositNapal] 
@Invoice nvarchar(150),
@IsSuccessfull bit,
@Comment nvarchar(50)

AS

BEGIN
SET NOCOUNT ON;

declare @Balance money
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @Amount money
declare @DepositStatuId int
declare @CurrenyId int=71
declare @CustomerId bigint
declare @DepositTransferId bigint

declare @CustomerCreateDate datetime
if @IsSuccessfull=1
	begin

		select @CustomerId=CustomerId,@Amount=[Customer].[DepositTransfer].DepositAmount,@DepositStatuId=[DepositStatuId],@DepositTransferId=DepositTransferId from [Customer].[DepositTransfer] WHERE [Customer].[DepositTransfer].CustomerNote=@Invoice
		
		if (@DepositStatuId=1)
		begin
			insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId)
			values(@CustomerId,@Amount,@CurrenyId,GETDATE(),32,1)

			select @Balance=ISNULL(Customer.Customer.Balance,0),@CustomerCreateDate=CreateDate from Customer.Customer where Customer.CustomerId=@CustomerId

			set @Balance=@Balance+@Amount

			update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
		
			--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=123 and Log.ErrorCodes.LangId=@LangId
	
			UPDATE [Customer].[DepositTransfer]  SET [DepositStatuId] = 2,[UpdateDate] = GetDate(),UserComment=@Comment WHERE DepositTransferId=@DepositTransferId

		exec [Bonus].[ProcBonusCustomer]  @CustomerId,@Amount,@CurrenyId,@CustomerCreateDate,2

		end
	end
else
	begin

		select @DepositStatuId=[DepositStatuId] from [Customer].[DepositTransfer] WHERE DepositTransferId=@DepositTransferId
		

		if (@DepositStatuId=1)
			begin
				UPDATE [Customer].[DepositTransfer]  SET [DepositStatuId] = 3,[UpdateDate] = GetDate(),UserComment=@Comment  WHERE DepositTransferId=@DepositTransferId
			end
	end
	
	
END


GO
