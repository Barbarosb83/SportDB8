USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerDepositCepBankRequestApprove]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerDepositCepBankRequestApprove] 
@DepositCepBankId bigint,
@IsApproved bit,
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
	
	if(select COUNT(Customer.DepositCepBank.DepositCepBankId) from Customer.DepositCepBank where Customer.DepositCepBank.DepositCepBankId=@DepositCepBankId and DepositStatuId=1)>0
		begin
		select @Amount=DepositAmount,@CurrencyId=CurrencyId,@CustomerId=CustomerId 
		from [Customer].[DepositCepBank]  where [Customer].[DepositCepBank].DepositCepBankId =@DepositCepBankId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=146 and Log.ErrorCodes.LangId=@LangId
	
EXEC	[RiskManagement].[ProcCustomerDeposit]
		@TransactionId = 0,
		@CustomerId = @CustomerId,
		@PinCode = N'''''',
		@Amount = @Amount,
		@TransactionTypeId = 29,
		@CurrenyId = @CurrencyId,
		@Comments = N'''''',
		@LangId = 1,
		@username =@Username,
		@ActivityCode = 2,
		@NewValues = N''''''
	
	
		UPDATE [Customer].[DepositCepBank]
		SET DepositStatuId= 2
	   ,UserId= @UserId
		 ,UpdateDate= GetDate()
		WHERE DepositCepBankId=@DepositCepBankId
		
		

		
	end
end
Else
begin
if(select COUNT(Customer.DepositCepBank.DepositCepBankId) from Customer.DepositCepBank where Customer.DepositCepBank.DepositCepBankId=@DepositCepBankId and DepositStatuId=1)>0
		begin
		UPDATE [Customer].[DepositCepBank]
		SET DepositStatuId= 3
		  ,UserId= @UserId
      ,UpdateDate= GetDate()
		WHERE DepositCepBankId=@DepositCepBankId
	
		select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=147 and Log.ErrorCodes.LangId=@LangId
		end
	
	
	
end

select @resultcode as resultcode,@resultmessage as resultmessage

END


GO
