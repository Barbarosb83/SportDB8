USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipOddsEvaluateManuel]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSlipOddsEvaluateManuel] 
@SlipOddId bigint,
@StateId int,
@VoidFactor nvarchar(10),
@LangId int,
@UserId int
as 

BEGIN TRAN
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'

select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=103 and Log.ErrorCodes.LangId=@LangId

declare @MatchId bigint
declare @OddTypeId int
declare @SlipId bigint
declare @CustomerId bigint
declare @Amount money
declare @SlipTypeId int
declare @SystemSlipId bigint
declare @IsBranchCustomer bit
declare @OddId bigint
declare @OldStateId int
declare @Gain money
declare @CashoutValue money=0
declare @IsPay bit=0
declare @Control bit=0
declare @MultiSlipState int
		declare @TotalOddValue float
		declare @SystemMinSlipId bigint
		declare @SystemGain money=0
					declare @TaxAmount money=0
												declare @TaxId bigint=0

	if exists(Select SlipId from Customer.SlipOdd where SlipOddId=@SlipOddId)
		begin
		INSERT INTO [RiskManagement].[SlipManuelEvo] ([SlipOddId],[StateId],[CreateDate]) VALUES(@SlipOddId,@StateId,GETDATE())

select  @MatchId=MatchId,@OddTypeId=OddsTypeId,@SlipId=Customer.SlipOdd.SlipId,@OddId=OddId,@OldStateId=StateId from Customer.SlipOdd with (nolock) where SlipOddId=@SlipOddId
select @SlipTypeId=Customer.Slip.SlipTypeId,@Gain=Customer.Slip.Amount*Customer.Slip.TotalOddValue,@Amount=Customer.Slip.Amount,@CustomerId=CustomerId,@IsPay=IsPayOut from Customer.Slip with (nolock) where Customer.Slip.SlipId=@SlipId

		end
	else
		begin
		select  @MatchId=MatchId,@OddTypeId=OddsTypeId,@SlipId=Archive.SlipOdd.SlipId,@OddId=OddId,@OldStateId=StateId from Archive.SlipOdd with (nolock) where SlipOddId=@SlipOddId
		select @SlipTypeId=Archive.Slip.SlipTypeId,@Gain=Archive.Slip.Amount*Archive.Slip.TotalOddValue,@Amount=Archive.Slip.Amount,@CustomerId=CustomerId,@IsPay=IsPayOut from Archive.Slip with (nolock) where Archive.Slip.SlipId=@SlipId

		end

select @IsBranchCustomer=IsBranchCustomer from Customer.Customer with (nolock) where CustomerId=@CustomerId

if(@IsBranchCustomer=1)
	if(@IsPay=1)
		set @Control=1


if @MatchId is not null and @OddTypeId is not null and @Control=0 and (Select COUNT(Customer.Slip.SlipId) from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId in (7))=0
		begin
		
	if exists(Select SlipId from Customer.SlipOdd where SlipOddId=@SlipOddId)
	begin
		if(@StateId=2)
		 set @VoidFactor='1'

		if(@SlipTypeId<3)
			begin
				if(@VoidFactor='0' or @VoidFactor is null or @VoidFactor='')
					update Customer.SlipOdd set StateId=@StateId where SlipOddId=@SlipOddId
				else
					update Customer.SlipOdd set StateId=@StateId,OddValue=@VoidFactor where SlipOddId=@SlipOddId
			end
		else
			begin
				if(@VoidFactor='0' or @VoidFactor is null or @VoidFactor='')
					update Customer.SlipOdd set StateId=@StateId where SlipId in (Select SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId in (Select SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)) and OddId=@OddId
				else
					update Customer.SlipOdd set StateId=@StateId,OddValue=@VoidFactor  where SlipId in (Select SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId in (Select SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)) and OddId=@OddId
			end




		select @TotalOddValue=EXP(SUM(LOG(OddValue))) from Customer.SlipOdd with (nolock) where SlipId=@SlipId 
		
		--Void olmuş oddlar olabileceğinden Total Odd value tekrar hesaplanıyor.
			if(@SlipTypeId not in (4,5))
			begin
			select @TotalOddValue=EXP(SUM(LOG(OddValue))) from Customer.SlipOdd with (nolock) where SlipId=@SlipId 
			update Customer.Slip set TotalOddValue=@TotalOddValue where SlipId=@SlipId
			end
			set @Gain=@Amount*@TotalOddValue

			    if (@SlipTypeId<=3)
					begin
						if exists (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId=4)
							begin
								if exists (Select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId in (3,6))
									begin
										exec Job.FuncCustomerBooking @CustomerId,@Gain,0,@SlipId
									end
								if not exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=7 ) --Slip CashOut yapılmadıysa 
									update Customer.Slip set SlipStateId=4,EvaluateDate=GETDATE(),TotalOddValue=@TotalOddValue where SlipId=@SlipId
									update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId and SlipTypeId=2
						 
			
							end
						else if not exists (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (1,4))
							begin
								if not exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and Customer.Slip.SlipStateId in (2,3,5,6,7))
									begin
										set @Gain=@TotalOddValue*@Amount
										exec Job.FuncCustomerBooking @CustomerId,@Gain,3,@SlipId

							----------------------------------TAX----------------------------------------------------------
										if exists (select TaxAmount from Customer.Tax with (nolock) where SlipId=@SlipId)
											begin
												if(@TotalOddValue=1) --Kupon Cancel olursa tax geri yükleniyor
													begin
												set @TaxAmount =0
												set @TaxId =0
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
									end
							end
						else if not exists (select  Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId=4)
							begin
								if exists (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId =1)
									begin
										if exists (Select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId in (3,6))
											begin
												exec Job.FuncCustomerBooking @CustomerId,@Gain,0,@SlipId
											end
										if not exists (Select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=1)
												update Customer.Slip set SlipStateId=1 where SlipId=@SlipId
									end

							end

					end
				else if @SlipTypeId=4
					begin
							 
								if exists (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId =1)
									begin
										if exists (Select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId in (3,6))
											begin
												select @SystemMinSlipId=Customer.SlipSystem.SystemSlipId,@Gain=MaxGain from Customer.SlipSystemSlip with (nolock) INNER JOIN Customer.SlipSystem On 
												Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId and Customer.SlipSystemSlip.SlipId=@SlipId

												update Customer.SlipSystem set SlipStateId=1 where SystemSlipId=@SystemMinSlipId
												update Customer.Slip set SlipStateId=1 where SlipId=@SlipId

												exec Job.FuncCustomerBooking @CustomerId,@Gain,0,@SlipId
											end
										 		
									end
								else
									exec [RiskManagement].[ProcSlipOddsEvaluateSystemSlip] @SlipId

						 
							--
					end
				else if @SlipTypeId=5
					begin
							if exists (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId =1)
									begin
									set @MultiSlipState=0
										select @SystemMinSlipId=Customer.SlipSystem.SystemSlipId,@Gain=MaxGain,@MultiSlipState=SlipStateId from Customer.SlipSystemSlip with (nolock) INNER JOIN Customer.SlipSystem On 
												Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId and Customer.SlipSystemSlip.SlipId=@SlipId
										if exists (Select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId in (3,6))
											begin
										 

												update Customer.SlipSystem set SlipStateId=1 where SystemSlipId=@SystemMinSlipId
												update Customer.Slip set SlipStateId=1 where SlipId=@SlipId

												exec Job.FuncCustomerBooking @CustomerId,@Gain,0,@SlipId
											end
										else	if exists(Select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=4) or (@MultiSlipState=4)
												begin
													update Customer.SlipSystem set SlipStateId=1 where SystemSlipId=@SystemMinSlipId
													update Customer.Slip set SlipStateId=1 where SlipId=@SlipId
												end
									end
							else
								exec [RiskManagement].[ProcSlipOddsEvaluateMultiSlip] @SlipId
					end

	
		end
		else if exists(Select SlipId from Archive.SlipOdd where SlipOddId=@SlipOddId)
	begin
		if(@StateId=2)
		 set @VoidFactor='1'

		if(@SlipTypeId<3)
			begin
				if(@VoidFactor='0' or @VoidFactor is null or @VoidFactor='')
					update Archive.SlipOdd set StateId=@StateId where SlipOddId=@SlipOddId
				else
					update Archive.SlipOdd set StateId=@StateId,OddValue=@VoidFactor where SlipOddId=@SlipOddId
			end
		else
			begin
				if(@VoidFactor='0' or @VoidFactor is null or @VoidFactor='')
					update Archive.SlipOdd set StateId=@StateId where SlipId in (Select SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId in (Select SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)) and OddId=@OddId
				else
					update Archive.SlipOdd set StateId=@StateId,OddValue=@VoidFactor  where SlipId in (Select SlipId from Customer.SlipSystemSlip with (nolock) where SystemSlipId in (Select SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)) and OddId=@OddId
			end




		select @TotalOddValue=EXP(SUM(LOG(OddValue))) from Archive.SlipOdd with (nolock) where SlipId=@SlipId 
		
		--Void olmuş oddlar olabileceğinden Total Odd value tekrar hesaplanıyor.
			if(@SlipTypeId not in (4,5))
			begin
			select @TotalOddValue=EXP(SUM(LOG(OddValue))) from Archive.SlipOdd with (nolock) where SlipId=@SlipId 
			update Archive.Slip set TotalOddValue=@TotalOddValue where SlipId=@SlipId
			end
			set @Gain=@Amount*@TotalOddValue

			    if (@SlipTypeId<=3)
					begin
						if exists (select Archive.SlipOdd.SlipOddId from Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId=4)
							begin
								if exists (Select Archive.Slip.SlipId from Archive.Slip with (nolock) where SlipId=@SlipId and SlipStateId in (3,6))
									begin
										exec Job.FuncCustomerBooking @CustomerId,@Gain,0,@SlipId
									end
								if not exists (select Archive.Slip.SlipId from Archive.Slip with (nolock) where SlipId=@SlipId and SlipStateId=7 ) --Slip CashOut yapılmadıysa 
									update Archive.Slip set SlipStateId=4,EvaluateDate=GETDATE(),TotalOddValue=@TotalOddValue where SlipId=@SlipId
									update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId and SlipTypeId=2
						 
			
							end
						else if not exists (select Archive.SlipOdd.SlipOddId from Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (1,4))
							begin
								if not exists (select Archive.Slip.SlipId from Archive.Slip with (nolock) where SlipId=@SlipId and Archive.Slip.SlipStateId in (2,3,5,6,7))
									begin
										set @Gain=@TotalOddValue*@Amount
										exec Job.FuncCustomerBooking @CustomerId,@Gain,3,@SlipId

							----------------------------------TAX----------------------------------------------------------
										if exists (select TaxAmount from Customer.Tax with (nolock) where SlipId=@SlipId)
											begin
												if(@TotalOddValue=1) --Kupon Cancel olursa tax geri yükleniyor
													begin
												set @TaxAmount  =0
												set @TaxId  =0
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
		
										update Archive.Slip set SlipStateId=3,EvaluateDate=GETDATE(),TotalOddValue=@TotalOddValue,IsPayOut= Case when @IsBranchCustomer=1 then 0 else 1 end where SlipId=@SlipId
									end
							end
						else if not exists (select  Archive.SlipOdd.SlipOddId from Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId=4)
							begin
								if exists (select Archive.SlipOdd.SlipOddId from Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId =1)
									begin
										if exists (Select Archive.Slip.SlipId from Archive.Slip with (nolock) where SlipId=@SlipId and SlipStateId in (3,6))
											begin
												exec Job.FuncCustomerBooking @CustomerId,@Gain,0,@SlipId
											end
										if not exists (Select Archive.Slip.SlipId from Archive.Slip with (nolock) where SlipId=@SlipId and SlipStateId=1)
												update Archive.Slip set SlipStateId=1 where SlipId=@SlipId
									end

							end

					end
				else if @SlipTypeId=4
					begin
							 
								if exists (select Archive.SlipOdd.SlipOddId from Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId =1)
									begin
										if exists (Select Archive.Slip.SlipId from Archive.Slip with (nolock) where SlipId=@SlipId and SlipStateId in (3,6))
											begin
												select @SystemMinSlipId=Customer.SlipSystem.SystemSlipId,@Gain=MaxGain from Customer.SlipSystemSlip with (nolock) INNER JOIN Customer.SlipSystem On 
												Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId and Customer.SlipSystemSlip.SlipId=@SlipId

												update Customer.SlipSystem set SlipStateId=1 where SystemSlipId=@SystemMinSlipId
												update Archive.Slip set SlipStateId=1 where SlipId=@SlipId

												exec Job.FuncCustomerBooking @CustomerId,@Gain,0,@SlipId
											end
										 		
									end
								else
									exec [RiskManagement].[ProcSlipOddsEvaluateSystemSlipOld] @SlipId

						 
							--
					end
				else if @SlipTypeId=5
					begin
							if exists (select Archive.SlipOdd.SlipOddId from Archive.SlipOdd with (nolock) where SlipId=@SlipId and StateId =1)
									begin
									set @MultiSlipState =1
										select @SystemMinSlipId=Customer.SlipSystem.SystemSlipId,@Gain=MaxGain,@MultiSlipState=SlipStateId from Customer.SlipSystemSlip with (nolock) INNER JOIN Customer.SlipSystem On 
												Customer.SlipSystemSlip.SystemSlipId=Customer.SlipSystem.SystemSlipId and Customer.SlipSystemSlip.SlipId=@SlipId
										if exists (Select Archive.Slip.SlipId from Archive.Slip with (nolock) where SlipId=@SlipId and SlipStateId in (3,6))
											begin
										 

												update Customer.SlipSystem set SlipStateId=1 where SystemSlipId=@SystemMinSlipId
												update Archive.Slip set SlipStateId=1 where SlipId=@SlipId

												exec Job.FuncCustomerBooking @CustomerId,@Gain,0,@SlipId
											end
										else	if exists(Select Archive.Slip.SlipId from Archive.Slip with (nolock) where SlipId=@SlipId and SlipStateId=4) or (@MultiSlipState=4)
												begin
													update Customer.SlipSystem set SlipStateId=1 where SystemSlipId=@SystemMinSlipId
													update Archive.Slip set SlipStateId=1 where SlipId=@SlipId
												end
									end
							else
								exec [RiskManagement].[ProcSlipOddsEvaluateMultiSlipOld] @SlipId
					end

	
		end

		insert Customer.SlipHistory(SlipOddId,[ActionType],[ActionDate],[UserId],OldStateId)
	values(@SlipOddId,@StateId,GETDATE(),@UserId,@OldStateId)
	end
else if exists(Select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId =7)
		begin
			if(@Control=0)
			begin
				select @CashoutValue = CashOutValue from Customer.SlipCashOut with (nolock) where SlipId=@SlipId
				set @OldStateId=7
				if(@SlipTypeId<=3 and @CashoutValue>0)
					begin
					if exists(select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId)
							update Customer.Slip set SlipStateId=1 where SlipId=@SlipId
					else
							update Archive.Slip set SlipStateId=1 where SlipId=@SlipId

							delete from Customer.SlipCashOut where SlipId=@SlipId

					exec Job.FuncCustomerBooking @CustomerId,@CashoutValue,0,@SlipId

				end
				else
					begin
					if exists(select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId)
							update Customer.Slip set SlipStateId=1 where SlipId=@SlipId
					else
							update Archive.Slip set SlipStateId=1 where SlipId=@SlipId

							select @SystemSlipId = SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId

							update Customer.SlipSystem set MaxGain=MaxGain2,SlipStateId=1 where SystemSlipId=@SystemSlipId

							delete from Customer.SlipCashOut where SlipId=@SlipId

							exec Job.FuncCustomerBooking @CustomerId,@CashoutValue,0,@SlipId
				end
			end
				insert Customer.SlipHistory(SlipOddId,[ActionType],[ActionDate],[UserId],OldStateId)
	values(@SlipOddId,@StateId,GETDATE(),@UserId,@OldStateId)
		end
	


	select @resultcode as resultcode,@resultmessage as resultmessage

COMMIT TRAN


GO
