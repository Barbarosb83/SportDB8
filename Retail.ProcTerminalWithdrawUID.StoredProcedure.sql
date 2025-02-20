USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalWithdrawUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcTerminalWithdrawUID]
@TransactionId bigint,
@BranchId int,
@Amount money,
@CurrencyId int,
@LangId int,
@username nvarchar(max),
@TransactionTypeId int


AS




BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode bigint=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @BranchBalance money=0
declare @ParentBranchBalance money
declare @Control int=0
declare @UserId int
declare @UserRoleId int
declare @UserBranchId int 
declare @CurrenyId int
declare @CustomerId bigint
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
declare @IsTerminal bit
	 
select @UserRoleId=Users.UserRoles.RoleId,@UserId=Users.Users.UserId,@UserBranchId=Users.Users.UnitCode from Users.UserRoles INNER JOIN Users.Users ON Users.UserRoles.UserId=Users.Users.UserId where UserName=@username

select @CustomerId=CustomerId from Customer.Customer where BranchId=@BranchId and IsTerminalCustomer=1

	select @BranchBalance=Balance,@CurrencyId= CurrencyId,@IsTerminal= IsTerminal from Parameter.Branch where BranchId=@BranchId
	

 declare @UserBalance money

						select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction
						where UserId=@UserId order by CreateDate desc

			 
if(@IsTerminal=0)
begin
	if(@TransactionTypeId=5) --Withdraw
		begin
		set @TransactionTypeId=16 -- Terminalden çıkan ödeme kuponun ödemesi yapılıyor Credit Voucher
				 if(@BranchBalance>=@Amount-0.1)
				 begin
					update Parameter.Branch set
							Balance=Balance+@Amount
							where Parameter.Branch.BranchId=@BranchId

							set @UserBalance=ISNULL(@UserBalance,0)-@Amount

							 
					

				 end
				 else 
				 set @Control=1

		end
	else if (@TransactionTypeId=3) --Deposit
		begin
		set @TransactionTypeId=14 -- Terminal için transactiontype 14 terminal deposit
			update Parameter.Branch set
			Balance=Balance-@Amount
			where Parameter.Branch.BranchId=@BranchId


				set @UserBalance=ISNULL(@UserBalance,0)+@Amount
		end
	else
		 set @Control=1
end
else
	set @TransactionTypeId=16 
	if exists (select RiskManagement.BranchTransactionPass.BranchTransactionId from RiskManagement.BranchTransactionPass where RiskManagement.BranchTransactionPass.BranchTransactionId=@TransactionId and IsPaid=1)
		set @Control=1

					if(@Control=0)
					begin
						update RiskManagement.BranchTransactionPass set UpdateDate=GETDATE(),UpdateUserName=@username,IsPaid=1 Where RiskManagement.BranchTransactionPass.BranchTransactionId=@TransactionId
				--	insert RiskManagement.BranchDepositRequest(RequestUserId,BranchId,RequestDate,Amount,CurrencyId,BranchNote,TransactionTypeId,IsApproved,ApprovedUserId,ApprovedDate)
				--values (@UserId,@BranchId,GETDATE(),@Amount,@CurrencyId,'',@TransactionTypeId,1,@UserId,GETDATE())
					if not exists (select * from RiskManagement.BranchTransaction where SlipId=@TransactionId and TransactionTypeId=@TransactionTypeId and BranchId=@BranchId and CustomerId=@CustomerId)
						begin
							insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
							values(@BranchId,@CustomerId,@TransactionTypeId,@Amount,@CurrencyId,GETDATE(),@UserId,@UserBalance,@TransactionId)
							set @resultcode=SCOPE_IDENTITY()
						end
					end
	select @BranchBalance=Balance from Parameter.Branch where BranchId=@BranchId
	 
			if(@Control=0)
	select @resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	else
		select @resultcode=ErrorCodeId, @resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=172 and Log.ErrorCodes.LangId=@LangId
	
	


	select @resultcode as resultcode,@resultmessage as resultmessage,@BranchBalance as Balance
END




GO
