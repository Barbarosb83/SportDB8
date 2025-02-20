USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCustomerSlipWithdraw]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcCustomerSlipWithdraw] 
@TransactionId bigint,
@CustomerId bigint,
@PinCode nvarchar(30),
@Amount money,
@TransactionTypeId int, --  8
@CurrenyId int,
@Comments nvarchar(150),
@LangId int,
@username nvarchar(max),
@ActivityCode int,  -- 2 geliyor
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
declare @Control int=1
declare @BranchCurrencyId int
declare @IsBranchCustomer bit


select @UserBranchId=Users.Users.UnitCode
--,@UserBranchBalance=Parameter.Branch.Balance
,@UserId=Users.Users.UserId
--,@BranchCurrencyId=Parameter.Branch.CurrencyId
from Users.Users with (nolock)
--INNER JOIN Parameter.Branch on Parameter.Branch.BranchId=Users.UnitCode
 where Users.Users.UserName=@username
	
select @direction=Parameter.TransactionTypeBranch.Direction from Parameter.TransactionTypeBranch with (nolock)
where Parameter.TransactionTypeBranch.BranchTransactionTypeId=@TransactionTypeId
 

 --insert dbo.betslip (CreateDate,data,id) values (GETDATE(),cast(@Amount as nvarchar(50)),@TransactionId)

 declare @CustomerCurrencyId int
select @CustomerCurrencyId=CurrencyId,@IsBranchCustomer=IsBranchCustomer from Customer.Customer with (Nolock) where CustomerId=@CustomerId

if @ActivityCode=2
	begin
		
			if exists (select RiskManagement.BranchTransaction.BranchTransactionId from RiskManagement.BranchTransaction with (Nolock) where RiskManagement.BranchTransaction.SlipId=@TransactionId and RiskManagement.BranchTransaction.TransactionTypeId=@TransactionTypeId)
						begin
						if exists (select Customer.Slip.SlipId from  Customer.Slip with (Nolock) where SlipId=@TransactionId and SlipTypeId<3 )
											begin
												update Customer.Slip set IsPayOut=1 where SlipId=@TransactionId
												
											end
										else if exists (select Archive.Slip.SlipId from  Archive.Slip with (Nolock) where SlipId=@TransactionId and SlipTypeId<3)
											update Archive.Slip set IsPayOut=1 where SlipId=@TransactionId
										else
											begin
											update Customer.SlipSystem set IsPayOut=1 where SystemSlipId= (select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@TransactionId)
											update Customer.Slip  set IsPayOut=1 where SlipId in (Select SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId in (select  Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@TransactionId))
												update Archive.Slip  set IsPayOut=1 where SlipId in (Select SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId in (select  Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@TransactionId))
													

											end
						set @Control=0
						end

										if exists (select Customer.Slip.SlipId from  Customer.Slip with (Nolock) where SlipId=@TransactionId and SlipTypeId<3 and IsPayOut=1)
											begin
											set @Control=0
											end
										else if exists (select Archive.Slip.SlipId from  Archive.Slip with (Nolock) where SlipId=@TransactionId and SlipTypeId<3 and IsPayOut=1)
											set @Control=0
										else if exists (select Customer.SlipSystem.SystemSlipId from Customer.SlipSystem with (Nolock) where IsPayOut=1 and SystemSlipId= (select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (Nolock) where SlipId=@TransactionId) )
											begin
											set @Control=0

											end



		if(@UserBranchId=1)
			begin
				exec [Log].ProcConcatOldValues  'Transaction','[Customer]','TransactionId',@TransactionId,@OldValues output
			
				exec [Log].[ProcTransactionLogUID] 25,@ActivityCode,@Username,@TransactionId,'Customer.Transaction'
				,@NewValues,null
		
		
				

				--select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId

				if(@direction=1)
				begin
				set @Balance=@Balance+@Amount
				update Parameter.Branch set Balance=Balance+@Amount where BranchId=@UserBranchId
 
				end
				else if (@direction=0)
				set @Balance=@Balance-@Amount
				
				insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
				values(@CustomerId,@Amount,@CurrenyId,GETDATE(),@TransactionTypeId,2,@Comments,@Balance)

				--update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
				if(@TransactionTypeId=30)
					select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock) where ErrorCodeId=146 and Log.ErrorCodes.LangId=@LangId
				else
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock) where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
			end
		else
			begin

						if(@IsBranchCustomer=1)
						begin
						if(@TransactionTypeId=2)
							begin
								if(select Balance from Customer.Customer with (Nolock) where CustomerId=@CustomerId)<@Amount
									set @Control=0

							end

							if(@Control=1)
							begin
							exec [Log].ProcConcatOldValues  'Transaction','[Customer]','TransactionId',@TransactionId,@OldValues output
			
						exec [Log].[ProcTransactionLogUID] 25,@ActivityCode,@Username,@TransactionId,'Customer.Transaction'
						,@NewValues,null


										if exists (select Customer.Slip.SlipId from  Customer.Slip with (Nolock) where SlipId=@TransactionId and SlipTypeId<3 and ( IsPayOut=0))
											begin
												update Customer.Slip set IsPayOut=1 where SlipId=@TransactionId
											end
										else if exists (select Archive.Slip.SlipId from  Archive.Slip with (Nolock) where SlipId=@TransactionId and SlipTypeId<3 and ( IsPayOut=0))
											begin
											update Archive.Slip set IsPayOut=1 where SlipId=@TransactionId
											end
										else
											begin
												update Customer.SlipSystem set IsPayOut=1 where SystemSlipId= (select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (Nolock) where SlipId=@TransactionId)
												update Archive.Slip set IsPayOut=1 where SlipId=@TransactionId
												update Customer.Slip set IsPayOut=1 where SlipId=@TransactionId

											end
						--insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment)
						--values(@CustomerId,dbo.FuncCurrencyConverter(@Amount,@CurrenyId,@CustomerCurrencyId),@CustomerCurrencyId,GETDATE(),@TransactionTypeId,2,@Comments)

						declare @CustomerBalance money
						
						--select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer with (Nolock) where Customer.CustomerId=@CustomerId
						--set @CustomerBalance=@Balance
						declare @UserBalance money

						select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction with (Nolock)
						where UserId=@UserId and TransactionTypeId not in (3,5) order by CreateDate desc

						if(@direction=1)
							begin

							 
							 if not exists (select RiskManagement.BranchTransaction.BranchTransactionId from RiskManagement.BranchTransaction with (Nolock) where RiskManagement.BranchTransaction.SlipId=@TransactionId and RiskManagement.BranchTransaction.TransactionTypeId=@TransactionTypeId)
							 begin
								set @UserBalance=ISNULL(@UserBalance,0)-@Amount 

								insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
								values(@UserBranchId,@CustomerId,@TransactionTypeId,@Amount,@CurrenyId,GETDATE(),@UserId,@UserBalance,@TransactionId)

										update Parameter.Branch set Balance=Balance+@Amount where BranchId=@UserBranchId

										--if exists (select Customer.Slip.SlipId from  Customer.Slip with (Nolock) where SlipId=@TransactionId and SlipTypeId<>3)
										--	begin
										--		update Customer.Slip set IsPayOut=1 where SlipId=@TransactionId
												
										--	end
										--else if exists (select Archive.Slip.SlipId from  Archive.Slip with (Nolock) where SlipId=@TransactionId and SlipTypeId<>3)
										--	update Archive.Slip set IsPayOut=1 where SlipId=@TransactionId
										--else
										--	begin
										--	update Customer.SlipSystem set IsPayOut=1 where SystemSlipId= (select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (Nolock) where SlipId=@TransactionId)
										--	update Archive.Slip set IsPayOut=1 where SlipId=@TransactionId
										--	 update Customer.Slip set IsPayOut=1 where SlipId=@TransactionId
										--	end
								end
								
							end
						else if (@direction=0)
							begin
								 if not exists (select RiskManagement.BranchTransaction.BranchTransactionId from RiskManagement.BranchTransaction with (Nolock) where RiskManagement.BranchTransaction.SlipId=@TransactionId and RiskManagement.BranchTransaction.TransactionTypeId=@TransactionTypeId)
							 begin
								set @UserBalance=ISNULL(@UserBalance,0)+@Amount 

								insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
								values(@UserBranchId,@CustomerId,@TransactionTypeId,@Amount,@CurrenyId,GETDATE(),@UserId,@UserBalance,@TransactionId)
										
										update Parameter.Branch set Balance=Balance-@Amount where BranchId=@UserBranchId
								end
							end
					
						
						select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock) where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
						end
						else
							select @resultcode=106,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock) where ErrorCodeId=106 and Log.ErrorCodes.LangId=@LangId
						end
						else
							begin

												set @Control=0
											if exists (select Customer.Slip.SlipId from  Customer.Slip with (Nolock) where SlipId=@TransactionId and SlipTypeId<3 and ( IsPayOut=0))
											begin
												update Customer.Slip set IsPayOut=1 where SlipId=@TransactionId
												set @Control=1
												
											end
										else if exists (select Archive.Slip.SlipId from  Archive.Slip with (Nolock) where SlipId=@TransactionId and SlipTypeId<3 and (IsPayOut=0))
												begin
											update Archive.Slip set IsPayOut=1 where SlipId=@TransactionId
											set @Control=1
											end
										else
											begin
											update Customer.SlipSystem set IsPayOut=1 where SystemSlipId= (select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (Nolock) where SlipId=@TransactionId)
											 update Archive.Slip set IsPayOut=1 where SlipId=@TransactionId
											 update Customer.Slip set IsPayOut=1 where SlipId=@TransactionId
											 set @Control=1
											end
										if(@Control=1)
										begin
										exec Job.FuncCustomerBooking @CustomerId,@Amount,1,@TransactionId
										select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock) where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
										end
										else
											select @resultcode=106,@resultmessage=ErrorCode from Log.ErrorCodes with (nolock) where ErrorCodeId=106 and Log.ErrorCodes.LangId=@LangId
							end
					--end
				--else
				--	begin
				--	select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=148 and Log.ErrorCodes.LangId=@LangId
				--	end
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
