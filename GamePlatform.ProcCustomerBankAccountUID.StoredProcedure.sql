USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerBankAccountUID]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [GamePlatform].[ProcCustomerBankAccountUID]
@CustomerBankAccountId bigint,
@CustomerId bigint,
@BankId int,
@BranchCode nvarchar(150),
@AccountNo nvarchar(150),
@AccountTypeId int,
@IBAN nvarchar(50),
@LangId int,
@ActivityCode int,
@NewValues nvarchar(max)


AS




BEGIN
SET NOCOUNT ON;


declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId


if @ActivityCode=1
	begin
	--	exec [Log].ProcConcatOldValues  'BranchBetTypeCommision','[RiskManagement]','BranchBetTypeCommisionId',@BranchBetTypeCommisionId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	--,@NewValues,@OldValues
	
	update Customer.Account set
	[ParameterBankId] =@BankId,
	BranchCode=@BranchCode,
	AccountNo=@AccountNo
	,AccountTypeId=@AccountTypeId
	,IBAN=@IBAN
	where Customer.Account.CustomerAccountId=@CustomerBankAccountId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	
	
	end
if @ActivityCode=2
	begin

	
	--exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	--,@NewValues,null
	
	insert Customer.Account ([CustomerId],[ParameterBankId],[BranchCode],[AccountNo],[IBAN],[AccountTypeId])
	values(@CustomerId,@BankId,@BranchCode,@AccountNo,@IBAN,@AccountTypeId)
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	
	
	end
	
	if @ActivityCode=3
	begin

	--	exec [Log].ProcConcatOldValues  'BranchBetTypeCommision','[RiskManagement]','BranchBetTypeCommisionId',@BranchBetTypeCommisionId,@OldValues output
	
	--exec [Log].[ProcTransactionLogUID]  37,@ActivityCode,@Username,@BranchBetTypeCommisionId,'RiskManagement.BranchBetTypeCommision'
	--,null,@OldValues
	
	delete from Customer.Account where CustomerAccountId=@CustomerBankAccountId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	
	end
	


	select @resultcode as resultcode,@resultmessage as resultmessage
END





GO
