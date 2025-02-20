USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcTerminalTransactionUID]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcTerminalTransactionUID]
 @BranchId bigint,
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
declare @BranchBalance decimal(18,2)=0
declare @ParentBranchBalance money
declare @Control int=0
declare @UserId int
declare @UserRoleId int
declare @UserBranchId int 
declare @CurrenyId int
 declare @UserBalance money
  declare @TransactionBalance money
 declare @CustomerTransactionTypeId int
select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=@resultcode and Log.ErrorCodes.LangId=@LangId
	declare @CustomerId bigint=@BranchId	 
	 
select @UserRoleId=Users.UserRoles.RoleId,@UserId=Users.Users.UserId,@UserBranchId=Users.Users.UnitCode from Users.UserRoles INNER JOIN Users.Users ON Users.UserRoles.UserId=Users.Users.UserId where UserName=@username

 
	--insert dbo.betslip values(@BranchId,CAST(@Amount as nvarchar(50))+@username,GETDATE())
	
if exists (select CustomerId from Customer.Customer where CustomerId=@CustomerId and IsTerminalCustomer=1)
begin

--select @CustomerId=CustomerId from Customer.Customer where BranchId=@UserBranchId and IsTerminalCustomer=1


select @BranchBalance=Balance,@CurrencyId= CurrencyId from Parameter.Branch where BranchId=@UserBranchId
						select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction
						where UserId=@UserId order by CreateDate desc

				 

	if(@TransactionTypeId=5) --Withdraw 
		begin
		set @TransactionTypeId=15 -- Terminal için transactiontype 15 cash voucher
				 if(@BranchBalance>=@Amount-0.1 and @BranchBalance>0)
				 begin
					update Parameter.Branch set
							Balance=0
							where Parameter.Branch.BranchId=@UserBranchId
							set @Amount=@BranchBalance
						--	set @UserBalance=ISNULL(@UserBalance,0)-@Amount

							 
					

				 end
				 else 
				 set @Control=1

		end
	else if (@TransactionTypeId=3) --Deposit
		begin

		 --IF(select top 1 DATEDIFF(MILLISECOND, CreateDate,GETDATE()) from RiskManagement.BranchTransaction where BranchId=@UserBranchId and TransactionTypeId=14  order by BranchTransactionId desc)>500
			--begin
			set @TransactionTypeId=14 -- Terminal için transactiontype 14 terminal deposit
			update Parameter.Branch set
			Balance=Balance+@Amount
			where Parameter.Branch.BranchId=@UserBranchId


				set @UserBalance=ISNULL(@UserBalance,0)+@Amount
		--	end
		--else
		--	set @Control=1
		end
	else
		 set @Control=1


					if(@Control=0)
					begin
				--	insert RiskManagement.BranchDepositRequest(RequestUserId,BranchId,RequestDate,Amount,CurrencyId,BranchNote,TransactionTypeId,IsApproved,ApprovedUserId,ApprovedDate)
				--values (@UserId,@BranchId,GETDATE(),@Amount,@CurrencyId,'',@TransactionTypeId,1,@UserId,GETDATE())

						insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
						values(@UserBranchId,@CustomerId,@TransactionTypeId,@Amount,@CurrencyId,GETDATE(),@UserId,@UserBalance)
							set @resultcode=SCOPE_IDENTITY()
					end
	select @BranchBalance=Balance from Parameter.Branch where BranchId=@UserBranchId
	 
			if(@Control=0)
	select @resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	else
		select @resultcode=ErrorCodeId, @resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=172 and Log.ErrorCodes.LangId=@LangId
	
	
end
else
begin
 

						select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction
						where UserId=@UserId order by CreateDate desc
						declare @CustomerBalance money


						select @CustomerBalance=Balance from Customer.Customer where CustomerId=@CustomerId

			 

	if(@TransactionTypeId=5) --Withdraw 
		begin
		set @TransactionTypeId=2 -- Terminal için transactiontype1 withdraw terminal
		set @CustomerTransactionTypeId=65
				 if(@CustomerBalance>=@Amount-0.01 and @CustomerBalance>0)
				 begin
					update Customer.Customer set Balance=0 where CustomerId=@CustomerId
							set @Amount=@CustomerBalance
						--	set @UserBalance=ISNULL(@UserBalance,0)-@Amount
						set @TransactionBalance=@CustomerBalance-@Amount
							 
					

				 end
				 else 
				 begin
				 set @Control=1
				 set @BranchBalance=@CustomerBalance
				 end

		end
	else if (@TransactionTypeId=3) --Deposit
		begin
		set @TransactionTypeId=1 -- Terminal için transactiontype 1 terminal deposit
		set @CustomerTransactionTypeId=64
			update Customer.Customer set Balance=Balance+@Amount where CustomerId=@CustomerId
			set @TransactionBalance=@CustomerBalance+@Amount

			--	set @UserBalance=ISNULL(@UserBalance,0)+@Amount
		end
	else
		 set @Control=1


					if(@Control=0)
					begin
				
					 select @BranchBalance=Balance from Customer.Customer where CustomerId=@CustomerId
				--	insert RiskManagement.BranchDepositRequest(RequestUserId,BranchId,RequestDate,Amount,CurrencyId,BranchNote,TransactionTypeId,IsApproved,ApprovedUserId,ApprovedDate)
				--values (@UserId,@BranchId,GETDATE(),@Amount,@CurrencyId,'',@TransactionTypeId,1,@UserId,GETDATE())
						insert Customer.[Transaction](CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
						values(@CustomerId,@Amount,@CurrencyId,GETDATE(),@CustomerTransactionTypeId,5,'',@TransactionBalance)
					

						insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
						values(@UserBranchId,@CustomerId,@TransactionTypeId,@Amount,@CurrencyId,GETDATE(),@UserId,@UserBalance)
							set @resultcode=SCOPE_IDENTITY()
					end
	
	
			if(@Control=0)
	select @resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId
	else
		select @resultcode=ErrorCodeId, @resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=172 and Log.ErrorCodes.LangId=@LangId
end



	select @resultcode as resultcode,@resultmessage as resultmessage,@BranchBalance as Balance
END




GO
