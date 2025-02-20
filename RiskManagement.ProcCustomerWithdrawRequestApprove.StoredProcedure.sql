USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerWithdrawRequestApprove]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcCustomerWithdrawRequestApprove] 
@WithdrawRequestId bigint,
@IsApproved bit,
@Username nvarchar(50),
@TranscationCode nvarchar(100),
@ApprovedComment nvarchar(250)
AS

BEGIN
SET NOCOUNT ON;

declare @UserId int

select @UserId=Users.Users.UserId from Users.Users where Users.Users.UserName=@Username

if exists(select [RiskManagement].[WithdrawRequest].WithdrawRequestId from [RiskManagement].[WithdrawRequest] where [RiskManagement].[WithdrawRequest].WithdrawRequestId =@WithdrawRequestId and [IsApproved] is null)
begin

if(@IsApproved=1)
begin

	declare @Amount money
	declare @TransactionType int
	declare @CurrencyId int
	declare @CustomerId bigint
	
	select @Amount=Amount,@TransactionType=TransactionType,@CurrencyId=CurrencyId,@CustomerId=CustomerId
	from [RiskManagement].[WithdrawRequest] where [RiskManagement].[WithdrawRequest].WithdrawRequestId =@WithdrawRequestId
	

	update Customer.[Transaction] set TransactionTypeId=31 where CustomerId=@CustomerId and TransactionTypeId=33 and TransactionComment=cast(@WithdrawRequestId as nvarchar(10))+'-'+@ApprovedComment
	
	
	UPDATE [RiskManagement].[WithdrawRequest]
   SET [IsApproved] = @IsApproved
      ,[ApprovedUserId] = @UserId
      ,[ApprovedDate] = GetDate()
	  ,ApprovedComment=@ApprovedComment
      ,[TransactionCode] = @TranscationCode
	  ,TransactionType=31
	WHERE WithdrawRequestId =@WithdrawRequestId
	
end
Else
begin

select @Amount=Amount,@TransactionType=TransactionType,@CurrencyId=CurrencyId,@CustomerId=CustomerId
	from [RiskManagement].[WithdrawRequest] where [RiskManagement].[WithdrawRequest].WithdrawRequestId =@WithdrawRequestId

EXEC	[RiskManagement].[ProcCustomerDeposit]
		@TransactionId = 0,
		@CustomerId = @CustomerId,
		@PinCode = N'''''',
		@Amount = @Amount,
		@TransactionTypeId = 34,
		@CurrenyId = @CurrencyId,
		@Comments = @ApprovedComment,
		@LangId = 1,
		@username =@Username,
		@ActivityCode = 2,
		@NewValues = N''''''

	UPDATE [RiskManagement].[WithdrawRequest]
   SET [IsApproved] = @IsApproved
      ,[ApprovedUserId] = @UserId
      ,[ApprovedDate] = GetDate()
	  ,ApprovedComment=@ApprovedComment
      ,[TransactionCode] = @TranscationCode
	  ,TransactionType=34
	WHERE WithdrawRequestId =@WithdrawRequestId
	

	
end

end
select 1

END




GO
