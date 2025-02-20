USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerWithDrawRequest]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcCustomerWithDrawRequest] 
	@CustomerId bigint,
	@Amount money,
	@CurrencyId int,
	@AccountId nvarchar(max),
	@TransactionType int,
	@BankId int,
	@CustomerNote nvarchar(250),
	@LangId int
AS

BEGIN
SET NOCOUNT ON;

declare @resultcode int=143
declare @resultmessage nvarchar(max)='Hata oluştu'

set @CurrencyId=3

	declare @WithdrawRequestId bigint
declare @Balance money

select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

if (@Balance<@Amount)
begin
	set @resultcode =143
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode 
	from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
	
	select @resultcode as resultcode,@resultmessage as resultmessage
end
else
begin
 --if(Select COUNT(RiskManagement.WithdrawRequest.WithdrawRequestId) from RiskManagement.WithdrawRequest where RiskManagement.WithdrawRequest.CustomerId=@CustomerId and cast( RiskManagement.WithdrawRequest.RequestDate  as date)=CAST( GETDATE() as date) and (IsApproved is null or IsApproved=1))<2
 --begin
	INSERT INTO [RiskManagement].[WithdrawRequest]
           ([CustomerId]
           ,[RequestDate]
           ,[Amount]
           ,[CurrencyId]
           ,[TransactionType]
           ,[AccountId]
           ,BankId
           ,CustomerNote
          )
     VALUES
           (@CustomerId
           ,GetDate()
           ,@Amount
           ,3
           ,@TransactionType
           ,@AccountId
           ,@BankId
           ,@CustomerNote)
	
		set @WithdrawRequestId=SCOPE_IDENTITY()


	
EXEC	[RiskManagement].[ProcCustomerDeposit]
		@TransactionId = 0,
		@CustomerId = @CustomerId,
		@PinCode = N'''''',
		@Amount = @Amount,
		@TransactionTypeId = @TransactionType,
		@CurrenyId = @CurrencyId,
		@Comments =@WithdrawRequestId,
		@LangId = 1,
		@username ='Administrator',
		@ActivityCode = 2,
		@NewValues = N''''''

	set @resultcode =144
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode 
	from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
	
	execute Users.Notification 1,0,2,127,''	
	
	select @resultcode as resultcode,@resultmessage as resultmessage

	--end
	--else
	--	begin
	--		set @resultcode =155
	--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode 
	--from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
	
	
	--select @resultcode as resultcode,@resultmessage as resultmessage

	--	end
end

END


GO
