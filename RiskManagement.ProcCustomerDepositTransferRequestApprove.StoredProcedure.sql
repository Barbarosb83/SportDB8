USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerDepositTransferRequestApprove]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerDepositTransferRequestApprove] 
@DepositTransferId bigint,
@IsApproved bit,
@UserComment nvarchar(250),
@Username nvarchar(50),
@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @UserId int

select @UserId=Users.Users.UserId from Users.Users where Users.Users.UserName=@Username
declare @resultcode int=145
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId

if(@IsApproved=1)
begin

	declare @Amount money
	declare @TransactionType int
	declare @CurrencyId int
	declare @CustomerId bigint
	
	if(select COUNT(Customer.DepositTransfer.DepositTransferId) from Customer.DepositTransfer where Customer.DepositTransfer.DepositTransferId=@DepositTransferId and DepositStatuId=1)>0
		begin
		select @Amount=DepositAmount,@CurrencyId=CurrencyId,@CustomerId=CustomerId ,@TransactionType=TransactionTypeId
		from  Customer.DepositTransfer  where Customer.DepositTransfer.DepositTransferId =@DepositTransferId
	
	
EXEC	[RiskManagement].[ProcCustomerDeposit]
		@TransactionId = 0,
		@CustomerId = @CustomerId,
		@PinCode = N'''''',
		@Amount = @Amount,
		@TransactionTypeId = @TransactionType,
		@CurrenyId = @CurrencyId,
		@Comments = N'''''',
		@LangId = 1,
		@username =@Username,
		@ActivityCode = 2,
		@NewValues = N''''''
	
	
		UPDATE [Customer].DepositTransfer
		SET DepositStatuId= 2
	   ,UserId= @UserId
		 ,UpdateDate= GetDate()
		WHERE DepositTransferId =@DepositTransferId

		----------------------------BONUS------------------------------------------------------------------------------
		--execute [RiskManagement].[ProcCustomerBonusCreate] @CustomerId,@CurrencyId,0,@Amount
		-----------------------------------------------------------------------------------------------------------------
	
		
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=146 and Log.ErrorCodes.LangId=@LangId

		
	end
end
Else
begin
if(select COUNT(Customer.DepositTransfer.DepositTransferId) from Customer.DepositTransfer where Customer.DepositTransfer.DepositTransferId=@DepositTransferId and DepositStatuId=1)>0
		begin
			UPDATE [Customer].DepositTransfer
		SET DepositStatuId= 3
	   ,UserId= @UserId
		 ,UpdateDate= GetDate()
		WHERE DepositTransferId =@DepositTransferId
	
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=147 and Log.ErrorCodes.LangId=@LangId
		end
	
	
	
end

select @resultcode as resultcode,@resultmessage as resultmessage

END


GO
