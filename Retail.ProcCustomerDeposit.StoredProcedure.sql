USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerDeposit]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCustomerDeposit] 
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
declare @resultcode bigint=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @Balance money
declare @direction int

declare @UserId int
declare @UserBranchId int
declare @UserBranchBalance money
declare @Control int=1
declare @BranchCurrencyId int
declare @DailyDepositControl int=1
declare @DailyWithDrawControl int=1
declare @BranchTransId bigint
declare @BranchName nvarchar(150)
declare @CustomerName nvarchar(150)
declare @Currency nvarchar(5)
declare @SystemCurrencyId int


select top 1 @SystemCurrencyId= SystemCurrencyId from General.Setting

select @UserBranchId=Users.Users.UnitCode
,@UserBranchBalance=Parameter.Branch.Balance
,@UserId=Users.Users.UserId
,@BranchCurrencyId=Parameter.Branch.CurrencyId,@BranchName=Parameter.Branch.BrancName
from Users.Users with (nolock) INNER JOIN 
Parameter.Branch with (nolock) on Parameter.Branch.BranchId=Users.UnitCode
 where Users.Users.UserName=@username
	

declare @CustomerDepositLimit money=0

select @direction=Parameter.TransactionTypeBranch.Direction from Parameter.TransactionTypeBranch with (nolock)
where Parameter.TransactionTypeBranch.BranchTransactionTypeId=@TransactionTypeId
 
 
	declare @CustomerBalance money
							declare @UserBalance money	


 declare @CustomerCurrencyId int
select @CustomerCurrencyId=Customer.Customer.CurrencyId,@CustomerName=Customer.Customer.CustomerName+' '+Customer.Customer.CustomerSurname+'('+Customer.Customer.Username+')' 
,@Balance=ISNULL(Customer.Customer.Balance,0),@Currency=Parameter.Currency.Symbol3
from Customer.Customer with (nolock) INNER JOIN Parameter.Currency with (nolock) ON Customer.Customer.CurrencyId=Parameter.Currency.CurrencyId where CustomerId=@CustomerId

if @ActivityCode=2 --Normal deposit / withdraw
	begin
	


		if(@UserBranchId=1)
			begin
				exec [Log].ProcConcatOldValues  'Transaction','[Customer]','TransactionId',@TransactionId,@OldValues output
			
				exec [Log].[ProcTransactionLogUID] 25,@ActivityCode,@Username,@TransactionId,'Customer.Transaction'
				,@NewValues,null
		
		
				
				 
				if(@direction=1)
				begin
				set @Balance=@Balance+@Amount
				

					--execute [RiskManagement].[ProcCustomerBonusCreate] @CustomerId,@CurrenyId,@Balance,@Amount
				end
				else if (@direction=0)
				set @Balance=@Balance-@Amount


				insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
				values(@CustomerId,@Amount,@CurrenyId,GETDATE(),@TransactionTypeId,2,@Comments,@Balance)

				update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
				if(@TransactionTypeId=30)
					select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=146 and Log.ErrorCodes.LangId=@LangId
				else
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
			end
		else
			begin

				if(@TransactionTypeId=1) --Depositte 2000€ üzeri kontrol yapılıyor.
					begin
						declare @SumDayDeposit money=0
						declare @SystemDailyDepositLimit money=0

						select @SumDayDeposit=ISNULL(SUM(Amount),0) 
						from Customer.[Transaction] with (nolock) 
						where CustomerId=@CustomerId and cast( TransactionDate as date)=cast(GETDATE() as date) and TransactionTypeId=@TransactionTypeId

						select top 1 @SystemDailyDepositLimit=CustomerDailyDeposit from General.Setting with (nolock)
						exec  @CustomerDepositLimit=  [dbo].[FuncCustomerDepositLimitControl] @CustomerId,1

						if(@CustomerDepositLimit<@Amount)
								set @Control=0
						if( @SumDayDeposit+@Amount>=@SystemDailyDepositLimit)
							set @DailyDepositControl=0

					end
				else if (@TransactionTypeId=2)
					begin
						declare @SumDayWithdraw money=0
						declare @SystemDailyWithdrawLimit money=0

						select @SumDayWithdraw=ISNULL(SUM(Amount),0) 
						from Customer.[Transaction] with (nolock) 
						where CustomerId=@CustomerId and cast( TransactionDate as date)=cast(GETDATE() as date) and TransactionTypeId=@TransactionTypeId

						select top 1 @SystemDailyWithdrawLimit=CustomerDailyWithdraw from General.Setting with (nolock)

						if(dbo.FuncCurrencyConverter(@SumDayWithdraw+@Amount,@CurrenyId,@SystemCurrencyId)>=@SystemDailyWithdrawLimit)
							set @DailyWithDrawControl=0

					end

				if((dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@BranchCurrencyId)<=@UserBranchBalance or @TransactionTypeId=2) and @DailyDepositControl=1 and @DailyWithDrawControl=1 and @Control=1)
					begin
					
				
						
						if(@TransactionTypeId=2)
							begin
								if(@Balance)<@Amount
									set @Control=0

							end

							if(@Control=1)
							begin
							exec [Log].ProcConcatOldValues  'Transaction','[Customer]','TransactionId',@TransactionId,@OldValues output
			
						exec [Log].[ProcTransactionLogUID] 25,@ActivityCode,@Username,@TransactionId,'Customer.Transaction'
						,@NewValues,null
						 
						set @CustomerBalance=@Balance
					 

						select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction with (nolock)
						where UserId=@UserId and TransactionTypeId not in (3,5) order by CreateDate desc

						if(@direction=1)
							begin

							 

								set @UserBalance=ISNULL(@UserBalance,0)-dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@BranchCurrencyId)

								insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
								values(@UserBranchId,@CustomerId,2,@Amount,@CurrenyId,GETDATE(),@UserId,@UserBalance)
								set @BranchTransId=SCOPE_IDENTITY()

								set @CustomerBalance=@CustomerBalance-dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@CustomerCurrencyId)
								set @Balance=@Balance+dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@CustomerCurrencyId)
								update Parameter.Branch set Balance=Balance+dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@BranchCurrencyId) where BranchId=@UserBranchId
							end
						else if (@direction=0)
							begin
								set @UserBalance=ISNULL(@UserBalance,0)+dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@BranchCurrencyId)

								insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
								values(@UserBranchId,@CustomerId,1,@Amount,@CurrenyId,GETDATE(),@UserId,@UserBalance)
								set @BranchTransId=SCOPE_IDENTITY()

								set @CustomerBalance=@CustomerBalance+dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@CustomerCurrencyId)
								set @Balance=@Balance-dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@CustomerCurrencyId)
								update Parameter.Branch set Balance=Balance-dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@BranchCurrencyId) where BranchId=@UserBranchId
							end
						update Customer.Customer set Balance=@CustomerBalance where CustomerId=@CustomerId

							insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
						values(@CustomerId,dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@CustomerCurrencyId),@CustomerCurrencyId,GETDATE(),@TransactionTypeId,2,@Comments,@CustomerBalance)

						select @resultcode=@BranchTransId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
						end
						else
							select @resultcode=148,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=149 and Log.ErrorCodes.LangId=@LangId
					end
				else
					begin
						if (@DailyDepositControl=1 and @DailyWithDrawControl=1)
							begin
							if(@Control=1)
							select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=148 and Log.ErrorCodes.LangId=@LangId
							else
								select @resultcode=ErrorCodeId,@resultmessage='Ihr tägliches Einzahlungslimit beträgt 0 .' from Log.ErrorCodes where ErrorCodeId=148 and Log.ErrorCodes.LangId=@LangId
							end
						else
							begin
								
								declare @Passwords nvarchar(20)

								set  @Passwords	=  dbo.[FuncGenPass](Rand())
								insert dbo.spintest(CustomerID,TransId,Round,CreateDate) values (@CustomerId,@TransactionId,@Passwords,GETDATE())
								set @resultcode=-1000
								if (@DailyDepositControl=0)
									set @resultmessage= convert(varchar(20), GETDATE(),113)+' Customer Deposit Alert | Branch Name:'+@BranchName+' Customer:'+@CustomerName+' Amount:'+cast(@Amount as nvarchar(100))+' '+@Currency+' Password:'+ @Passwords
								else if (@DailyWithDrawControl=0)
									set @resultmessage= convert(varchar(20), GETDATE(),113)+' Customer Withdraw Alert | Branch Name:'+@BranchName+' Customer:'+@CustomerName+' Amount:'+cast(@Amount as nvarchar(100))+' '+@Currency+' Password:'+ @Passwords
							end
					end
			end
		
	
	
	
end
else if @ActivityCode=3
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
else if @ActivityCode=4 --Şifre girilerek yapılan deposit / withdraw
	begin
	


		if(@UserBranchId=1)
			begin
				exec [Log].ProcConcatOldValues  'Transaction','[Customer]','TransactionId',@TransactionId,@OldValues output
			
				exec [Log].[ProcTransactionLogUID] 25,@ActivityCode,@Username,@TransactionId,'Customer.Transaction'
				,@NewValues,null
		
		
				 

				if(@direction=1)
				begin
				set @Balance=@Balance+@Amount
				

					execute [RiskManagement].[ProcCustomerBonusCreate] @CustomerId,@CurrenyId,@Balance,@Amount
				end
				else if (@direction=0)
				set @Balance=@Balance-@Amount


				insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
				values(@CustomerId,@Amount,@CurrenyId,GETDATE(),@TransactionTypeId,2,@Comments,@Balance)

				update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
				if(@TransactionTypeId=30)
					select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=146 and Log.ErrorCodes.LangId=@LangId
				else
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
			end
		else
			begin

			

				if((dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@BranchCurrencyId)<=@UserBranchBalance or @TransactionTypeId=2)  )
					begin
					
				
						
						if(@TransactionTypeId=2)
							begin
								if(@Balance)<@Amount
									set @Control=0

							end

							if(@Control=1)
							begin
							exec [Log].ProcConcatOldValues  'Transaction','[Customer]','TransactionId',@TransactionId,@OldValues output
			
						exec [Log].[ProcTransactionLogUID] 25,@ActivityCode,@Username,@TransactionId,'Customer.Transaction'
						,@NewValues,null

					
					
						select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId
						set @CustomerBalance=@Balance
					

						select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction with (nolock)
						where UserId=@UserId and TransactionTypeId not in (3,5) order by CreateDate desc

						if(@direction=1)
							begin

							 

								set @UserBalance=ISNULL(@UserBalance,0)-dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@BranchCurrencyId)

								insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
								values(@UserBranchId,@CustomerId,2,@Amount,@CurrenyId,GETDATE(),@UserId,@UserBalance)
								set @BranchTransId=SCOPE_IDENTITY()

								set @CustomerBalance=@CustomerBalance-dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@CustomerCurrencyId)
								set @Balance=@Balance+dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@CustomerCurrencyId)
								update Parameter.Branch set Balance=Balance+dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@BranchCurrencyId) where BranchId=@UserBranchId
							end
						else if (@direction=0)
							begin
								set @UserBalance=ISNULL(@UserBalance,0)+dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@BranchCurrencyId)

								insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance])
								values(@UserBranchId,@CustomerId,1,@Amount,@CurrenyId,GETDATE(),@UserId,@UserBalance)
								set @BranchTransId=SCOPE_IDENTITY()

								set @CustomerBalance=@CustomerBalance+dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@CustomerCurrencyId)
								set @Balance=@Balance-dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@CustomerCurrencyId)
								update Parameter.Branch set Balance=Balance-dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@BranchCurrencyId) where BranchId=@UserBranchId
							end
						update Customer.Customer set Balance=@CustomerBalance where CustomerId=@CustomerId

							insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
						values(@CustomerId,dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@CustomerCurrencyId),@CustomerCurrencyId,GETDATE(),@TransactionTypeId,2,@Comments,@CustomerBalance)

						select @resultcode=@BranchTransId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
						end
						else
							select @resultcode=148,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=149 and Log.ErrorCodes.LangId=@LangId
					end
				else
					begin
						 
							select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=148 and Log.ErrorCodes.LangId=@LangId
					 
					end
			end
		
	
	
	
end

	select @resultcode as resultcode,@resultmessage as resultmessage

END





GO
