USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipOddsEvaluateCancelRoolback]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [RiskManagement].[ProcSlipOddsEvaluateCancelRoolback] 
@MatchId bigint,
@OddTypeId int,
@BetTypeId int
as 


begin    

declare @SlipId bigint
declare @Amount money
declare @Gain money
declare @CustomerId bigint
declare @TotalOdd float
declare @tempSlip table (SlipId bigint,Gain money,CustomerId bigint,Amount money,SlipTyepId int)
declare @SlipTypeId int
declare @SystemSlipId bigint
declare @IsBranchCustomer bit

insert @tempSlip
	select Customer.Slip.SlipId,Customer.Slip.Amount*Customer.Slip.TotalOddValue,Customer.Slip.CustomerId,Customer.Slip.Amount,Customer.Slip.SlipTypeId
					FROM         Customer.SlipOdd with (nolock)  INNER JOIN
                      Customer.Slip with (nolock)  ON Customer.SlipOdd.SlipId = Customer.Slip.SlipId
					where Customer.SlipOdd.MatchId=@MatchId and Customer.SlipOdd.OddsTypeId=@OddTypeId  
					and Customer.SlipOdd.BetTypeId=@BetTypeId and SlipTypeId<4 and Customer.Slip.SlipStateId<>7

set nocount on
					declare cur111 cursor local for(
					select SlipId,Gain,CustomerId,Amount,SlipTyepId From @tempSlip

						)

					open cur111
					fetch next from cur111 into @SlipId,@Gain,@CustomerId,@Amount, @SlipTypeId 
					while @@fetch_status=0
						begin
							begin

select @IsBranchCustomer=IsBranchCustomer from Customer.Customer with (nolock) where CustomerId=@CustomerId
--insert Tempbooking values(@SlipId,@SlipOdId)
--Kazanan Oddtype'ın bütün oddları lost yapılıyor.
declare @TotalOddValue float
declare @SystemMinSlipId bigint
declare @SystemGain money=0

--Void olmuş oddlar olabileceğinden Total Odd value tekrar hesaplanıyor.
	select @TotalOddValue=EXP(SUM(LOG(case when stateid<> 2 then OddValue else 1 end))) from Customer.SlipOdd with (nolock) where SlipId=@SlipId
	update Customer.Slip set  TotalOddValue=@TotalOddValue where SlipId=@SlipId
	--if (@TotalOddValue>100)
	--		set @TotalOddValue=100
if @SlipId is not null
begin
		if exists (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId=4)
			begin
				if exists (Select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId in (3,6))
				begin
					--select @Amount=TotalOddValue*Amount,@CustomerId=Customer.Slip.CustomerId from Customer.Slip where SlipId=@SlipId
					
						exec Job.FuncCustomerBooking @CustomerId,@Gain,0,@SlipId
				end
			if not exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=7 ) --Slip CashOut yapılmadıysa 
				update Customer.Slip set SlipStateId=4,EvaluateDate=GETDATE(),TotalOddValue=@TotalOddValue where SlipId=@SlipId
			update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId and SlipTypeId=2
					if(@SlipTypeId=3 ) -- System Kupon kapatma
					begin
						select @SystemSlipId=Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId
							 
						select @SystemMinSlipId=Min(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=@SystemSlipId
						
						if not exists (select SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipStateId=1 and Customer.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId =@SystemSlipId))
						begin
							if exists (select SlipId from Archive.Slip with (nolock) where Archive.Slip.SlipStateId=3 and Archive.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId =@SystemSlipId))
								begin
								if not exists(select Customer.SlipSystem.SystemSlipId from Customer.SlipSystem with (nolock) where SlipStateId=3 and SystemSlipId=@SystemSlipId) -- Eğer sistem kuponu ödemesi yapılmadıysa yapılıyor.
										begin
										select @SystemGain = cast( ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=@SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=@SystemSlipId)),0) as money)  
										exec Job.FuncCustomerBooking @CustomerId,@SystemGain,1,@SystemMinSlipId

										end
									update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE(),IsPayOut= Case when @IsBranchCustomer=1 then 0 else 1 end where SystemSlipId=@SystemSlipId

									update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3

								end
							else if exists (select SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipStateId=3 and Customer.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId =@SystemSlipId))
								begin
									if not exists(select Customer.SlipSystem.SystemSlipId from Customer.SlipSystem with (nolock) where SlipStateId=3 and SystemSlipId=@SystemSlipId) -- Eğer sistem kuponu ödemesi yapılmadıysa yapılıyor.
											begin
										select @SystemGain = cast( ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=@SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=@SystemSlipId)),0) as money)  
										exec Job.FuncCustomerBooking @CustomerId,@SystemGain,1,@SystemMinSlipId

										end
								update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE(),IsPayOut= Case when @IsBranchCustomer=1 then 0 else 1 end where SystemSlipId=@SystemSlipId
								update Customer.Tax set TaxStatusId=3 where  SlipId =@SystemSlipId and SlipTypeId=3
								end
							else
								begin
								if exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipStateId=7 and SlipId in (Select SlipId from Customer.SlipSystemSlip wiyh (nolock) where SystemSlipId=@SystemSlipId))
								begin
								update Customer.SlipSystem set SlipStateId=7,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
								end
								else if exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipStateId=3 and SlipId in (Select SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId=@SystemSlipId))
								begin
								update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
								end
								else
									update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId

								update Customer.Tax set TaxStatusId=3 where  SlipId =@SystemSlipId and SlipTypeId=3
								end
						end
					end
			
			end
		else if not exists (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (1,4))
			begin
				if not exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and Customer.Slip.SlipStateId in (2,3,5,6,7))
				begin
					
					--select @Amount=@TotalOddValue*Amount,@CustomerId=Customer.Slip.CustomerId from Customer.Slip where SlipId=@SlipId
						set @Gain=@TotalOddValue*@Amount
				--insert dbo.Tempbooking values(@CustomerId,@Amount)
				if (@SlipTypeId<>3)
					exec Job.FuncCustomerBooking @CustomerId,@Gain,1,@SlipId

					----------------------------------TAX----------------------------------------------------------
					if exists (select TaxAmount from Customer.Tax with (nolock) where SlipId=@SlipId)
					begin
						if(@TotalOddValue=1) --Kupon Cancel olursa tax geri yükleniyor
							begin
								declare @TaxAmount money=0
								declare @TaxId bigint=0
								select @TaxAmount=TaxAmount,@TaxId=Customer.Tax.TaxId from Customer.Tax where SlipId=@SlipId
								update Customer.Tax set TaxStatusId=2 where SlipId=@SlipId

								exec  [Job].[FuncCustomerBooking2]  @CustomerId,@TaxAmount,1,54,@TaxId
							end
						else
							begin
								update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId

							end

					end
					----------------------------------------------------------------------------------------------------
					--Customer slipteki Total Odd value Void oddlar olabilir diye tekrar update ediliyor.
		
					update Customer.Slip set SlipStateId=3,EvaluateDate=GETDATE(),TotalOddValue=@TotalOddValue,IsPayOut= Case when @IsBranchCustomer=1 then 0 else 1 end where SlipId=@SlipId
						if(@SlipTypeId=3) -- System Kupon kapatma
					begin
						select @SystemSlipId=Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId
						select @SystemMinSlipId=Min(SlipId) from Customer.SlipSystemSlip with (nolock)  where Customer.SlipSystemSlip.SystemSlipId=@SystemSlipId
						
						if not exists (select SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipStateId=1 and Customer.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId =@SystemSlipId))
						begin
							--select @SystemGain = cast( ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=@SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=@SystemSlipId)),0) as money)  
							if exists (select SlipId from Archive.Slip with (nolock) where Archive.Slip.SlipStateId=3 and Archive.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId=@SystemSlipId))
								begin
									if not exists(select Customer.SlipSystem.SystemSlipId from Customer.SlipSystem with (nolock) where SlipStateId=3 and SystemSlipId=@SystemSlipId) -- Eğer sistem kuponu ödemesi yapılmadıysa yapılıyor.
											begin
										select @SystemGain = cast( ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=@SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=@SystemSlipId)),0) as money)  
										exec Job.FuncCustomerBooking @CustomerId,@SystemGain,1,@SystemMinSlipId

										end
									update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE(), IsPayOut= Case when @IsBranchCustomer=1 then 0 else 1 end where SystemSlipId=@SystemSlipId
									update Customer.Tax set TaxStatusId=3 where  SlipId =@SystemSlipId and SlipTypeId=3

										

								end
							else if exists (select SlipId from Customer.Slip with (nolock) where Customer.Slip.SlipStateId=3 and Customer.Slip.SlipId in  (select Customer.SlipSystemSlip.SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId=@SystemSlipId))
								begin
									if not exists(select Customer.SlipSystem.SystemSlipId from Customer.SlipSystem with (nolock) where SlipStateId=3 and SystemSlipId=@SystemSlipId) -- Eğer sistem kuponu ödemesi yapılmadıysa yapılıyor.
											begin
										select @SystemGain = cast( ISNULL((Select SUM(Customer.Slip.TotalOddValue*Customer.Slip.Amount) from Customer.Slip with (nolock) where Customer.Slip.SlipStateId in (3,2,6) and Customer.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=@SystemSlipId)),0)+ISNULL((Select SUM(Archive.Slip.TotalOddValue*Archive.Slip.Amount) from Archive.Slip with (nolock) where Archive.Slip.SlipStateId in (3,2,6) and Archive.Slip.SlipId in (select SlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SystemSlipId=@SystemSlipId)),0) as money)  
										exec Job.FuncCustomerBooking @CustomerId,@SystemGain,1,@SystemMinSlipId

										end
								update Customer.SlipSystem set SlipStateId=3,EvaluateDate=GETDATE(),IsPayOut= Case when @IsBranchCustomer=1 then 0 else 1 end where SystemSlipId=@SystemSlipId
								update Customer.Tax set TaxStatusId=3 where  SlipId =@SystemSlipId and SlipTypeId=3
								end
							else
								begin
								update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
								update Customer.Tax set TaxStatusId=3 where  SlipId =@SystemSlipId and SlipTypeId=3
								end
						end
					end


				end
			end
		else if not exists (select  Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId=4)
			begin
				if exists (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId =1)
					begin
						if not exists (Select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=1)
							begin
							update Customer.Slip set SlipStateId=1,TotalOddValue=@TotalOddValue where SlipId=@SlipId
								update Customer.Customer set Customer.Customer.Balance=Balance-@Amount where Customer.Customer.CustomerId=@CustomerId
								insert Customer.[Transaction](CustomerId,Amount,CurrencyId,TransactionDate,TransactionTypeId,TransactionSourceId,TransactionComment,TransactionBalance)
								values(@CustomerId,@Amount,3,GETDATE(),3,3,cast(@SlipId as nvarchar(50))+'-Cancel Roolback',@Amount)
							end
							if(@SlipTypeId=3) -- System Kupon  
									begin
										
										select @SystemSlipId=Customer.SlipSystemSlip.SystemSlipId from Customer.SlipSystemSlip with (nolock) where Customer.SlipSystemSlip.SlipId=@SlipId
										if not exists (Select Customer.SlipSystem.SystemSlipId from Customer.SlipSystem with (nolock) where SystemSlipId=@SystemSlipId and SlipStateId=1)
											update Customer.SlipSystem set SlipStateId=1  where SystemSlipId=@SystemSlipId

						 
									end


					end

			end
			
	
end
end
							fetch next from cur111 into @SlipId,@Gain,@CustomerId,@Amount,@SlipTypeId
			
						end
					close cur111
					deallocate cur111

					delete @tempSlip
end


GO
