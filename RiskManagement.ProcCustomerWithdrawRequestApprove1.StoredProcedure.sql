USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerWithdrawRequestApprove1]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerWithdrawRequestApprove1] 
@WithdrawRequestId bigint,
@IsApproved bit,
@Username nvarchar(50),
@TranscationCode nvarchar(100),
@Approved1Comment nvarchar(250)
AS

BEGIN
SET NOCOUNT ON;

declare @UserId int

select @UserId=Users.Users.UserId from Users.Users where Users.Users.UserName=@Username

if(@IsApproved=1)
begin

	declare @Amount money
	declare @TransactionType int
	declare @CurrencyId int
	declare @CustomerId bigint
	
	--select @Amount=Amount,@TransactionType=TransactionType,@CurrencyId=CurrencyId,@CustomerId=CustomerId
	--from [RiskManagement].[WithdrawRequest] where [RiskManagement].[WithdrawRequest].WithdrawRequestId =@WithdrawRequestId
	

	--update Customer.[Transaction] set TransactionTypeId=31 where CustomerId=@CustomerId and TransactionTypeId=33 and TransactionComment=@WithdrawRequestId
	
	
	UPDATE [RiskManagement].[WithdrawRequest]
   SET [IsApproved1] = @IsApproved
      ,[Approved1UserId] = @UserId
      ,[Approved1Date] = GetDate()
   --   ,[TransactionCode] = @TranscationCode
	  --,TransactionType=31
	WHERE WithdrawRequestId =@WithdrawRequestId
	
end
Else
begin

--select @Amount=Amount,@TransactionType=TransactionType,@CurrencyId=CurrencyId,@CustomerId=CustomerId
--	from [RiskManagement].[WithdrawRequest] where [RiskManagement].[WithdrawRequest].WithdrawRequestId =@WithdrawRequestId

--EXEC	[RiskManagement].[ProcCustomerDeposit]
--		@TransactionId = 0,
--		@CustomerId = @CustomerId,
--		@PinCode = N'''''',
--		@Amount = @Amount,
--		@TransactionTypeId = 34,
--		@CurrenyId = @CurrencyId,
--		@Comments = N'''''',
--		@LangId = 1,
--		@username =@Username,
--		@ActivityCode = 2,
--		@NewValues = N''''''

	UPDATE [RiskManagement].[WithdrawRequest]
   SET [IsApproved1] = @IsApproved
      ,[Approved1UserId] = @UserId
      ,[Approved1Date] = GetDate()
   --   ,[TransactionCode] = @TranscationCode
	  --,TransactionType=34
	WHERE WithdrawRequestId =@WithdrawRequestId
	
	
	
	
end

select 1

END




GO
