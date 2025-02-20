USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Parameter].[ProcParameterBankAcountUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Parameter].[ProcParameterBankAcountUID]
@BankAccountId int,
@BankId int,
@BranchCode nvarchar(50),
@AccountNo nvarchar(50),
@IBAN nvarchar(50),
@Name nvarchar(100),
@Surname nvarchar(100),
@IsActive bit,
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)

AS

BEGIN

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'


SET NOCOUNT ON;

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId



if(@ActivityCode=1)
	begin
	
	exec [Log].ProcConcatOldValues   'BankAccount','[Parameter]','BankAccountId',@BankAccountId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 38,@ActivityCode,@Username,@BankAccountId,'Parameter.BankAccount'
	,@NewValues,@OldValues
	
	
	update Parameter.BankAccount set
	BankId=@BankId
	,BranchCode=@BranchCode
	,AccountNo=@AccountNo
	,IBAN=@IBAN
	,Name=@Name
	,Surname=@Surname
	,IsActive=@IsActive
	where Parameter.BankAccount.BankAccountId=@BankAccountId
	
	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

	end
	
	else if(@ActivityCode=2)
	begin
	
	
	exec [Log].[ProcTransactionLogUID] 38,@ActivityCode,@Username,@BankAccountId,'Parameter.BankAccount'
	,@NewValues,null
	
	insert Parameter.BankAccount(BankId,BranchCode,AccountNo,IBAN,Name,Surname,CreateDate,IsActive)
	values (@BankId,@BranchCode,@AccountNo,@IBAN,@Name,@Surname,GETDATE(),@IsActive)
	
	

	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
	End
	
	else if(@ActivityCode=3)
	begin
	
	exec [Log].ProcConcatOldValues   'BankAccount','[Parameter]','BankAccountId',@BankAccountId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 38,@ActivityCode,@Username,@BankAccountId,'Parameter.BankAccount'
	,null,@OldValues
	
	
	delete from Parameter.BankAccount where BankAccountId=@BankAccountId
	
			select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId

	end



	select @resultcode as resultcode,@resultmessage as resultmessage



END


GO
