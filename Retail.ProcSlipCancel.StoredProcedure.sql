USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcSlipCancel]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcSlipCancel] 
@SlipId bigint,
@UserId int
as 

begin    
 declare @SlipOddId bigint

declare @Amount money
declare @CustomerId int
declare @SlipTypeId int
declare @SystemSlipId bigint=@SlipId
declare @TotalOddValue float=1
declare @Comment nvarchar(50)
declare @IsBranchCustomer bit
declare @UserBranchId int
declare @CurrenyId int
declare @UserBalance money
declare @Balance money

declare @TaxAmount money=0
declare @TaxId bigint=0

if exists (select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=1)
begin
if( ((select DATEDIFF(MINUTE,Customer.Slip.CreateDate,GETDATE()) from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=1)<10 or (Select COUNT(Customer.SlipOdd.SlipOddId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.SlipId=@SlipId and Customer.SlipOdd.BetTypeId=1 )=0))
begin
		update Customer.Slip set  SlipStateId=2,EvaluateDate=GETDATE() where SlipId=@SlipId
select @UserBranchId=Users.Users.UnitCode,@CurrenyId=Parameter.Branch.CurrencyId,@Balance=Parameter.Branch.Balance from Users.Users INNER JOIN Parameter.Branch ON Parameter.Branch.BranchId=Users.Users.UnitCode where UserId=@UserId
	 if exists (select Customer.Slip.SlipId  from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId and Customer.Slip.SlipTypeId<3 )
	 begin
		set @Comment=cast(@SlipId as nvarchar(10))+'-'+cast(@UserId as nvarchar(10))

		select @Amount=Amount,@CustomerId=Customer.Slip.CustomerId from Customer.Slip where SlipId=@SlipId

		select @IsBranchCustomer=customer.Customer.IsBranchCustomer from Customer.Customer where Customer.Customer.CustomerId=@CustomerId
		
			--update Customer.Slip set SlipStateId=2,EvaluateDate=GETDATE() where SlipId=@SlipId

			update Customer.SlipOdd set OddValue=1, StateId=2 where SlipId=@SlipId
				if(@IsBranchCustomer=0)
				begin
					--insert dbo.Tempbooking values(@CustomerId,@Amount)
						exec Job.FuncCustomerBooking2 @CustomerId,@Amount,1,8,@Comment

									update Customer.Slip set SlipStateId=2,EvaluateDate=GETDATE() where SlipId=@SlipId

									update Customer.SlipOdd set  OddValue=1, StateId=2 where SlipId=@SlipId
						----------------------------------TAX----------------------------------------------------------
						if(select COUNT(TaxAmount) from Customer.Tax with (nolock) where SlipId=@SlipId and SlipTypeId=2)>0
						begin
							if(@TotalOddValue=1) --Kupon Cancel olursa tax geri yükleniyor
								begin
							 
									select @TaxAmount=ISNULL(TaxAmount,0),@TaxId=Customer.Tax.TaxId from Customer.Tax where SlipId=@SlipId and SlipTypeId=2
									update Customer.Tax set TaxStatusId=2 where SlipId=@SlipId and SlipTypeId=2
									if(@TaxAmount is not null and @TaxAmount>0)
									exec  [Job].[FuncCustomerBooking2]  @CustomerId,@TaxAmount,1,54,@TaxId
								end
							else
								begin
									update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId and SlipTypeId=2

								end

						end
				end
				else
				begin
						select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction with (nolock)
													where UserId=@UserId and TransactionTypeId not in (3,5) order by CreateDate desc
								
									select @TaxAmount=TaxAmount,@TaxId=Customer.Tax.TaxId from Customer.Tax where SlipId=@SlipId and SlipTypeId=2
									update Customer.Tax set TaxStatusId=2 where SlipId=@SlipId and SlipTypeId=2
						
									set @UserBalance=@UserBalance-(@Amount+ISNULL(@TaxAmount,0))

									insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
									values(@UserBranchId,@CustomerId,9,@Amount+ISNULL(@TaxAmount,0),@CurrenyId,GETDATE(),@UserId,@UserBalance,@SlipId)
						
									update Customer.Slip set IsPayOut=1 where SlipId=@SlipId
									update Parameter.Branch set Balance=Balance+@Amount+ISNULL(@TaxAmount,0) where BranchId=@UserBranchId

				end

			end
	 else
	 begin
		set nocount on
					declare cur111 cursor local for(
					Select SlipId,SystemSlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId=(Select SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)

						)

					open cur111
					fetch next from cur111 into @SlipId,@SystemSlipId
					while @@fetch_status=0
						begin
							begin
								 
								 set @Comment=cast(@SlipId as nvarchar(10))+'-'+cast(@UserId as nvarchar(10))

		select @Amount=Amount,@CustomerId=Customer.Slip.CustomerId from Customer.Slip with (nolock) where SlipId=@SlipId
		--Select @SystemSlipId= SystemSlipId from Customer.SlipSystemSlip where SlipId=@SlipId
		select @IsBranchCustomer=customer.Customer.IsBranchCustomer from Customer.Customer with (nolock)  where Customer.Customer.CustomerId=@CustomerId
		
			update Customer.Slip set SlipStateId=2,EvaluateDate=GETDATE() where SlipId=@SlipId

			update Customer.SlipOdd set  OddValue=1, StateId=2 where SlipId=@SlipId
				if(@IsBranchCustomer=0)
				begin
					--insert dbo.Tempbooking values(@CustomerId,@Amount)
					--	exec Job.FuncCustomerBooking2 @CustomerId,@Amount,1,8,@Comment

						----------------------------------TAX----------------------------------------------------------
						if exists(select TaxAmount from Customer.Tax with (nolock) where SlipId=@SystemSlipId and SlipTypeId=3)
						begin
							if(@TotalOddValue=1) --Kupon Cancel olursa tax geri yükleniyor
								begin
							 
									select @TaxAmount=ISNULL(TaxAmount,0),@TaxId=Customer.Tax.TaxId from Customer.Tax with (nolock) where SlipId=@SystemSlipId and SlipTypeId=3
									update Customer.Tax set TaxStatusId=2 where SlipId=@SystemSlipId and SlipTypeId=3
									--if(@TaxAmount is not null and @TaxAmount>0)
									--exec  [Job].[FuncCustomerBooking2]  @CustomerId,@TaxAmount,1,54,@TaxId
								end
							else
								begin
									update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId

								end

						end
				end
				else
				begin
						
									update Customer.Slip set IsPayOut=1 where SlipId=@SlipId
									

				end
						 
								 
								 	
							end
							fetch next from cur111 into @SlipId,@SystemSlipId
			
						end
					close cur111
					deallocate cur111	
							
							if(@IsBranchCustomer=1 and (Select COUNT(*) from Customer.SlipSystem with (nolock) where  SystemSlipId=@SystemSlipId and SlipStateId=2 and IsPayOut=0 )=0)
							begin
							 

							select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction
													where UserId=@UserId and TransactionTypeId not in (3,5) order by CreateDate desc
								Select @Amount=Amount from Customer.SlipSystem with (nolock) where  SystemSlipId=@SystemSlipId
									select @TaxAmount=TaxAmount,@TaxId=Customer.Tax.TaxId from Customer.Tax with (nolock) where SlipId=@SystemSlipId and SlipTypeId=3
									update Customer.Tax set TaxStatusId=2 where SlipId=@SystemSlipId and SlipTypeId=3
						
									set @UserBalance=@UserBalance-(ISNULL(@Amount,0)+ISNULL(@TaxAmount,0))

									insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
									values(@UserBranchId,@CustomerId,9,ISNULL(@Amount,0)+ISNULL(@TaxAmount,0),@CurrenyId,GETDATE(),@UserId,@UserBalance,@SlipId)

									update Parameter.Branch set Balance=Balance+ISNULL(@Amount,0)+ISNULL(@TaxAmount,0) where BranchId=@UserBranchId
							end
							else
							begin
								if not exists((Select SystemSlipId from Customer.SlipSystem with (nolock) where  SystemSlipId=@SystemSlipId and SlipStateId=2 and IsPayOut=0 ))
								begin
								Select @Amount=Amount from Customer.SlipSystem where  SystemSlipId=@SystemSlipId
									select @TaxAmount=ISNULL(TaxAmount,0),@TaxId=Customer.Tax.TaxId from Customer.Tax with (nolock) where SlipId=@SystemSlipId and SlipTypeId=3
									update Customer.Tax set TaxStatusId=2 where SlipId=@SystemSlipId and SlipTypeId=3
									set @Amount=@Amount+ISNULL(@TaxAmount,0)
									exec Job.FuncCustomerBooking2 @CustomerId,@Amount,1,8,@Comment
								end
							end

							update Customer.SlipSystem set SlipStateId=2,IsPayOut=1,EvaluateDate=GETDATE(),MaxGain=(ISNULL(@Amount,0)+ISNULL(@TaxAmount,0)) where SystemSlipId=@SystemSlipId 


	 end



			select 1 as result
	end

end
	else
	select 0 as result

	


end

GO
