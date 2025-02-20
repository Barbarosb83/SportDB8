USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerWithDrawRequestAuto]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCustomerWithDrawRequestAuto] 
	@CustomerId bigint,
	@Amount money,
	@CurrencyId int,
	@AccountId nvarchar(max),
	@TransactionType int,
	@BankId int,
	@CustomerNote nvarchar(250),
	@LangId int,
	@IsActive bit
AS

BEGIN
SET NOCOUNT ON;

declare @resultcode int=143
declare @resultmessage nvarchar(max)='Hata oluştu'

set @CurrencyId=3

	declare @WithdrawRequestId bigint
declare @Balance money

select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId


if not exists (Select Customer.WithDrawRequest.CustomerWithdrawId from Customer.WithDrawRequest where CustomerId=@CustomerId and TransactionTypeId=@TransactionType)
	begin
		INSERT INTO [Customer].[WithDrawRequest]
           ([CustomerId]
           ,[TransactionTypeId]
           ,[CreateDate]
           ,[IsActive],Amount,CurrencyId)
     VALUES ( @CustomerId,@TransactionType,GETDATE(),@IsActive,@Amount,@CurrencyId)


	 INSERT INTO [RiskManagement].[WithdrawRequestAuto]
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
           , GetDate()
           ,@Amount
           ,3
           ,@TransactionType
           ,@AccountId
           ,@BankId
           ,@CustomerNote)
	
		set @WithdrawRequestId=SCOPE_IDENTITY()

	end
else
	begin
		if exists (Select Customer.WithDrawRequest.CustomerWithdrawId from Customer.WithDrawRequest where CustomerId=@CustomerId and TransactionTypeId=@TransactionType and CreateDate<=DATEADD(DAY,-7,GETDATE()))
		begin
			update [Customer].[WithDrawRequest] set  [IsActive]=@IsActive,Amount=@Amount,CurrencyId=@CurrencyId,CreateDate=GETDATE() where CustomerId=@CustomerId and TransactionTypeId=@TransactionType

		update [RiskManagement].[WithdrawRequestAuto] set Amount=@Amount,CurrencyId=@CurrencyId,AccountId=@AccountId,BankId=@BankId,CustomerNote=@CustomerNote
		where CustomerId=@CustomerId and TransactionType=@TransactionType
		end
		else
			begin
				
				update [Customer].[WithDrawRequest] set  [IsActive]=@IsActive where CustomerId=@CustomerId and TransactionTypeId=@TransactionType
				set @IsActive=0
			end

	end


if (@IsActive=1)
	begin
		if (@Balance<@Amount)
		begin
			set @resultcode =185
 			 select @resultcode=ErrorCodeId,@resultmessage=ErrorCode 
			from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
		end
		else
		begin
		 --if(Select COUNT(RiskManagement.WithdrawRequest.WithdrawRequestId) from RiskManagement.WithdrawRequest where RiskManagement.WithdrawRequest.CustomerId=@CustomerId and cast( RiskManagement.WithdrawRequest.RequestDate  as date)=CAST( GETDATE() as date) and (IsApproved is null or IsApproved=1))<2
		 --begin

 			INSERT INTO [RiskManagement].[WithdrawRequestAuto]
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
				   , GetDate()
				   ,@Amount
				   ,3
				   ,@TransactionType
				   ,@AccountId
				   ,@BankId
				   ,@CustomerNote)
	


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
	
			

			--end
			--else
			--	begin
			--		set @resultcode =155
			--select @resultcode=ErrorCodeId,@resultmessage=ErrorCode 
			--from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
	
	
			--select @resultcode as resultcode,@resultmessage as resultmessage

			--	end
		end
	end
else
	begin
	  set @resultcode=103
	  select @resultcode=ErrorCodeId,@resultmessage=ErrorCode 
			from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
	end

	select @resultcode as resultcode,@resultmessage as resultmessage

END


GO
