USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Customer].[ProcBitcoinUpdate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Customer].[ProcBitcoinUpdate]
	@CustomerId bigint,
    @Amount money,
    @CurrencyId int,
    @CreatedDate datetime,
    @Status nvarchar(10),
    @InvoiceId nvarchar(22)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		
		UPDATE [Customer].[BitcoinTransaction]
		   SET [Status] = @Status
		 WHERE [InvoiceId] = @InvoiceId

		 select @CustomerId=[Customer].[BitcoinTransaction].CustomerId,
				 @Amount=[Customer].[BitcoinTransaction].Amount,
				 @CurrencyId=[Customer].[BitcoinTransaction].CurrencyId		 
		  from [Customer].[BitcoinTransaction] WHERE [InvoiceId] = @InvoiceId

		 if (@Status='complete')
		begin
			EXEC [RiskManagement].[ProcCustomerDeposit]
				  @TransactionId = 0,
				  @CustomerId = @CustomerId,
				  @PinCode = N'''''',
				  @Amount = @Amount,
				  @TransactionTypeId = 27, --Deposit 27,Withdraw 28
				  @CurrenyId = @CurrencyId,
				  @Comments = @InvoiceId,
				  @LangId = 1,
				  @username = 'administrator',
				  @ActivityCode = 2,
				  @NewValues = N''''''
		end

END


GO
