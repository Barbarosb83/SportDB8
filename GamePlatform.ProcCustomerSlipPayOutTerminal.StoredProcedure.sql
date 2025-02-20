USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCustomerSlipPayOutTerminal]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [GamePlatform].[ProcCustomerSlipPayOutTerminal] 
@CustomerId bigint,
@SlipId bigint,
@Amount money,
@LangId int,
@username nvarchar(max),
@TerminalId bigint
AS

BEGIN
SET NOCOUNT ON;

declare @OldValues nvarchar(max)
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @Balance money
declare @direction int=1

declare @UserId int
declare @UserBranchId int
declare @UserBranchBalance money
declare @Control int=1
declare @BranchCurrencyId int
declare @IsBranchCustomer bit
declare @UserBalance money

select @UserBranchId=Users.Users.UnitCode
--,@UserBranchBalance=Parameter.Branch.Balance
,@UserId=Users.Users.UserId
--,@BranchCurrencyId=Parameter.Branch.CurrencyId
from Users.Users with (nolock) 
--INNER JOIN Parameter.Branch with (nolock) on Parameter.Branch.BranchId=Users.UnitCode
 where Users.Users.UserName=@username


 if exists(Select SlipId from Customer.Slip where SlipId=@SlipId and SlipTypeId<3)
	select @Amount= Customer.Slip.Amount*Customer.Slip.TotalOddValue from Customer.Slip where SlipId=@SlipId and SlipTypeId<3
else if exists(Select SlipId from Archive.Slip where SlipId=@SlipId and SlipTypeId<3)
	select @Amount= Archive.Slip.Amount*Archive.Slip.TotalOddValue from Archive.Slip where SlipId=@SlipId and SlipTypeId<3
else if exists(Select SlipId from Customer.Slip where SlipId=@SlipId and SlipTypeId>=3)
	begin
	select @Amount= Customer.SlipSystem.MaxGain from Customer.SlipSystem with (nolock) where SlipStateId in (3,7)
										and SystemSlipId= (select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
	end
else if exists(Select SlipId from Archive.Slip where SlipId=@SlipId and SlipTypeId>=3)
	begin
	select @Amount= Customer.SlipSystem.MaxGain from Customer.SlipSystem with (nolock) where SlipStateId in (3,7)
										and SystemSlipId= (select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
	end

 declare @CustomerCurrencyId int
select @CustomerCurrencyId=CurrencyId,@IsBranchCustomer=IsBranchCustomer from Customer.Customer with (nolock) where CustomerId=@CustomerId

 if exists (select RiskManagement.BranchTransaction.BranchTransactionId from RiskManagement.BranchTransaction with (nolock)  where RiskManagement.BranchTransaction.SlipId=@SlipId and RiskManagement.BranchTransaction.TransactionTypeId in (12,9))
						set @Control=0

			if exists (select Customer.Slip.SlipId from  Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId<3 and IsPayOut=1)
											begin
											set @Control=0
											end
										else if exists (select Archive.Slip.SlipId from  Archive.Slip with (nolock) where SlipId=@SlipId and SlipTypeId<3 and IsPayOut=1 and SlipStateId in (3,7))
											set @Control=0
										else if exists (select Customer.SlipSystem.SystemSlipId from Customer.SlipSystem with (nolock) where IsPayOut=1 and SlipStateId in (3,7)
										and SystemSlipId= (select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId) )
											begin
											set @Control=0

											end
				if exists (select Customer.Slip.SlipId from  Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId<3 and SlipStateId not in (3,7))
					set @Control=0
				else if exists (select Archive.Slip.SlipId from  Archive.Slip with (nolock) where SlipId=@SlipId and SlipTypeId<3 and SlipStateId not in (3,7))
											set @Control=0
				else if exists (select Customer.SlipSystem.SystemSlipId from Customer.SlipSystem with (nolock) where SlipStateId not in (3,7)
										and SystemSlipId= (select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId) )
											begin
											set @Control=0

											end
					if @Control=1
					begin
							if exists (select Customer.Slip.SlipId from  Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId<3 and (IsPayOut is null or IsPayOut=0))
											begin
											if not exists(Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and TotalOddValue=1)
												select @Amount= Amount*TotalOddValue from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId

												update Customer.Slip set IsPayOut=1 where SlipId=@SlipId
														select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=111 and Log.ErrorCodes.LangId=@LangId
											end
										else if exists (select Archive.Slip.SlipId from  Archive.Slip with (nolock) where SlipId=@SlipId and SlipTypeId<3 and (IsPayOut is null or IsPayOut=0))
										begin
										if not exists(Select SlipId from Archive.Slip with (nolock) where SlipId=@SlipId and TotalOddValue=1)
											select @Amount= Amount*TotalOddValue from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId
											update Archive.Slip set IsPayOut=1 where SlipId=@SlipId
													select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=112 and Log.ErrorCodes.LangId=@LangId
											end
										else
										begin
											update Customer.SlipSystem set IsPayOut=1 where SystemSlipId= (select top 1 Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip where SlipId=@SlipId)
											update Customer.Slip  set IsPayOut=1 where SlipId in (Select SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId in (select  Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId))
												update Archive.Slip  set IsPayOut=1 where SlipId in (Select SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId in (select  Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId))
													select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=113 and Log.ErrorCodes.LangId=@LangId
											end
			
			
				--exec [Log].ProcConcatOldValues  'Transaction','[Customer]','TransactionId',@TransactionId,@OldValues output
			
				--exec [Log].[ProcTransactionLogUID] 25,@ActivityCode,@Username,@TransactionId,'Customer.Transaction'
				--,@NewValues,null
		
			if(@IsBranchCustomer=1)
				begin
				
					--select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer where Customer.CustomerId=@CustomerId
					select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction with (nolock)
						where UserId=@UserId and TransactionTypeId not in (14,15) order by CreateDate desc
					insert Customer.[Transaction] (CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment)
					values(@CustomerId,@Amount,@CustomerCurrencyId,GETDATE(),47,2,cast(@SlipId as nvarchar(20)))
				end
					
				
				if(@direction=1)
				begin
						

								
									if(@IsBranchCustomer=1)
									begin
										set @UserBalance=ISNULL(@UserBalance,0)-@Amount
										
										insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
										values(@UserBranchId,@CustomerId,12,@Amount,@CustomerCurrencyId,GETDATE(),@UserId,@UserBalance,@SlipId)
										
										update Parameter.Branch set Balance=Balance+@Amount where BranchId=@UserBranchId
									end
									else
										begin
											select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction with (nolock)
											where BranchId=@TerminalId and TransactionTypeId not in (14,15) order by CreateDate desc

										  set @UserBalance=ISNULL(@UserBalance,0)-@Amount
										
										insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
										values(@UserBranchId,@CustomerId,12,@Amount,@CustomerCurrencyId,GETDATE(),@UserId,@UserBalance,@SlipId)

											exec Job.FuncCustomerBooking @CustomerId,@Amount,1,@SlipId
										end
 
				end
				else if (@direction=0)
				set @Balance=@Balance-@Amount
						
				--update Customer.Customer set Balance=@Balance where CustomerId=@CustomerId
				
				else
				select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
		
end

	select @resultcode as resultcode,@resultmessage as resultmessage

END





GO
