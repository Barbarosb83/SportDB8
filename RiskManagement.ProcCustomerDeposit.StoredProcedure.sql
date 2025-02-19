USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCustomerDeposit]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCustomerDeposit] 
@TransactionId bigint,
@CustomerId bigint,
@PinCode nvarchar(30),
@Amount money,
@TransactionTypeId int,
@CurrenyId int,
@Comments nvarchar(150),
@LangId int,
@username nvarchar(max),
@ActivityCode int,
@NewValues nvarchar(max)
AS

BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @Balance money
declare @direction int

declare @UserId int
declare @UserBranchId int
declare @UserBranchBalance money

declare @BranchCurrencyId int
set @CurrenyId=3
select @UserBranchId=Users.Users.UnitCode
,@UserBranchBalance=Parameter.Branch.Balance
,@UserId=Users.Users.UserId
,@BranchCurrencyId=Parameter.Branch.CurrencyId
from Users.Users with (nolock) INNER JOIN 
Parameter.Branch with (nolock) on Parameter.Branch.BranchId=Users.UnitCode
 where Users.Users.UserName=@username
	
select @direction=Parameter.TransactionType.Direction from Parameter.TransactionType with (nolock)
where Parameter.TransactionType.TransactionTypeId=@TransactionTypeId

if @ActivityCode=2
	begin
		if(@UserBranchId=1)
			begin
				exec [Log].ProcConcatOldValues  'Transaction','[Customer]','TransactionId',@TransactionId,@OldValues output
			
				exec [Log].[ProcTransactionLogUID] 25,@ActivityCode,@Username,@TransactionId,'Customer.Transaction'
				,@NewValues,null
		
		
			

				select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

				if(@direction=1)
				begin
				set @Balance=@Balance+@Amount
				

					execute [RiskManagement].[ProcCustomerBonusCreate] @CustomerId,@CurrenyId,@Balance,@Amount
				end
				else if (@direction=0)
					set @Balance=@Balance-@Amount

				update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId

					insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
				values(@CustomerId,@Amount,@CurrenyId,GETDATE(),@TransactionTypeId,2,@Comments,@Balance)

				if(@TransactionTypeId=30)
					select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=146 and Log.ErrorCodes.LangId=@LangId
				else
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
			end
		else
			begin
				if(@Amount<@UserBranchBalance)
					begin
						exec [Log].ProcConcatOldValues  'Transaction','[Customer]','TransactionId',@TransactionId,@OldValues output
			
						exec [Log].[ProcTransactionLogUID] 25,@ActivityCode,@Username,@TransactionId,'Customer.Transaction'
						,@NewValues,null
				
				
						insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment)
						values(@CustomerId,@Amount,@CurrenyId,GETDATE(),@TransactionTypeId,2,@Comments)

						
						
						select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

						if(@direction=1)
							begin
								insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId)
								values(@UserBranchId,@CustomerId,1,@Amount,@CurrenyId,GETDATE(),@UserId)
						
								set @Balance=@Balance+@Amount
								update Parameter.Branch set Balance=Balance-dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@BranchCurrencyId) where BranchId=@UserBranchId
							end
						else if (@direction=0)
							begin
								insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId)
								values(@UserBranchId,@CustomerId,2,@Amount,@CurrenyId,GETDATE(),@UserId)
								set @Balance=@Balance-@Amount
								update Parameter.Branch set Balance=Balance+dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@BranchCurrencyId) where BranchId=@UserBranchId
							end
						update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
						
						select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
					end
				else
					begin
					select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=148 and Log.ErrorCodes.LangId=@LangId
					end
			end
		
	
	
	
end
if @ActivityCode=3
	begin
	declare @DeleteAmount money=0
	
		exec [Log].ProcConcatOldValues  'Transaction','[Customer]','TransactionId',@TransactionId,@OldValues output
	
	exec [Log].[ProcTransactionLogUID] 25,@ActivityCode,@Username,@TransactionId,'Customer.Transaction'
	,null,@OldValues
	
	select @DeleteAmount=Customer.[Transaction].Amount,@CustomerId=Customer.[Transaction].CustomerId from Customer.[Transaction] where Customer.[Transaction].TransactionId=@TransactionId
	
	delete from Customer.[Transaction] where Customer.[Transaction].TransactionId=@TransactionId
	
	
	
	select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId
if(@TransactionTypeId=1)
set @Balance=@Balance-@DeleteAmount
else if (@TransactionTypeId=2)
set @Balance=@Balance+@DeleteAmount



	update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
	
	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=105 and Log.ErrorCodes.LangId=@LangId
	
	end

	select @resultcode as resultcode,@resultmessage as resultmessage

END



GO
