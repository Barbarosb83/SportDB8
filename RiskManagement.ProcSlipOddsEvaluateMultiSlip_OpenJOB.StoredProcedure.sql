USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSlipOddsEvaluateMultiSlip_OpenJOB]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcSlipOddsEvaluateMultiSlip_OpenJOB] 
 as
 
begin    
declare @SlipId bigint
declare @Amount money
declare @CustomerId bigint
declare @TotalOdd float
declare @tempSlip table (SlipId bigint,CustomerId bigint,Amount money,SlipTyepId int,Systems nvarchar(300),SystemSlipId bigint,CopuonCount int)
declare @SlipTypeId int
declare @IsBranchCustomer bit
declare @Systems nvarchar(300)
declare @SystemSlipId bigint
declare @CouponCount int
insert @tempSlip
	select DISTINCT Customer.Slip.SlipId,Customer.Slip.CustomerId,Customer.Slip.Amount,Customer.Slip.SlipTypeId,Customer.SlipSystem.[System],Customer.SlipSystemSlip.SystemSlipId,Customer.SlipSystem.CouponCount
					FROM         Customer.SlipOdd with (nolock)  INNER JOIN
                      Customer.Slip with (nolock)  ON Customer.SlipOdd.SlipId = Customer.Slip.SlipId INNER JOIN Customer.SlipSystemSlip 
					  ON Customer.SlipSystemSlip.SlipId=Customer.Slip.SlipId INNER JOIN
					  Customer.SlipSystem ON Customer.SlipSystem.SystemSlipId=Customer.SlipSystemSlip.SystemSlipId
					where Customer.SlipOdd.SlipId in (select SlipId FROM            Customer.Slip with (nolock)
WHERE     (SlipId IN
                             (SELECT        SlipId
                               FROM            Customer.SlipSystemSlip with (nolock)
                               WHERE        (SystemSlipId IN
                                                             (SELECT        SystemSlipId
                                                               FROM            Customer.SlipSystem with (nolock)
                                                               WHERE        (NewSlipTypeId = 5) AND (SlipStateId = 1) AND (SystemSlipId IN
                                                                                             (SELECT        SystemSlipId
                                                                                               FROM            Customer.SlipSystemSlip AS SlipSystemSlip_1 with (nolock)
                                                                                               WHERE        (SlipId IN
                                                                                                                             (SELECT        SlipId
                                                                                                                               FROM            Customer.SlipOdd
                                                                                                                               WHERE        (StateId <> 1))))))))))

set nocount on
					declare cur111 cursor local for(
					select SlipId,CustomerId,Amount,SlipTyepId,Systems,SystemSlipId,CopuonCount From @tempSlip

						)

				
					open cur111
					fetch next from cur111 into @SlipId,@CustomerId,@Amount, @SlipTypeId,@Systems,@SystemSlipId,@CouponCount
					while @@fetch_status=0
						begin
							begin




	

select @IsBranchCustomer=IsBranchCustomer from Customer.Customer with (nolock) where CustomerId=@CustomerId


declare @SystemCount int
declare @WinAmount money=0
declare @TotalWinAmount money=0
declare @OddValue float
declare @Odds nvarchar(300)=''
declare @OddMatchId bigint
declare @OldMatchId bigint=0


 declare @EventPerBet int=0

 select @EventPerBet= COUNT(distinct Customer.SlipOdd.BetradarMatchId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId

							--while @cCount< @CouponCount
							--	begin
								if not exists(select SlipId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetradarMatchId in  (Select BetradarMatchId from Customer.SlipOdd with (nolock) where SlipId=@SlipId GROUP BY BetradarMatchId HAVING COUNT( BetradarMatchId)=1) and StateId=4)
									begin
										if not exists (Select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock)  where SlipId=@SlipId and StateId=1)
											begin
										 
													set @OldMatchId=0
										
													set nocount on
															declare cur11123 cursor local for(
															select case when stateid =3 then OddValue else 1 end,BetradarMatchId From Customer.SlipOdd with (nolock) where SlipId=@SlipId and StateId in (3,2,5) 

																)
																order by BetradarMatchId
															open cur11123
															fetch next from cur11123 into @OddValue,@OddMatchId
															while @@fetch_status=0
																begin
																	begin
														 
																		
																	 if(@OldMatchId<>@OddMatchId)
																		set @Odds=@Odds+';'
																	else
																		set @Odds=@Odds+','

																		 set @Odds=@Odds+cast(@OddValue as nvarchar(10))
																		set @OldMatchId=@OddMatchId

																	end
																	fetch next from cur11123 into @OddValue,@OddMatchId
			
																end
															close cur11123
															deallocate cur11123

															set @Odds=SUBSTRING(@Odds,2,LEN(@Odds))
															select @WinAmount=[RiskManagement].[FuncSlipMultiEvaluate]     (@EventPerBet,@Odds,@Amount)
															set @TotalWinAmount=@TotalWinAmount+ @WinAmount
															
															--select @WinAmount,@CouponCount,@Odds,@Amount
															set @Odds=''

															if(@TotalWinAmount>0)
																	begin
																	if not exists(select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock)  where SlipId=@SlipId and StateId=1)
																			begin

																			if not exists (select Customer.Slip.SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and IsPayOut=1)
																			begin
																			exec Job.FuncCustomerBooking @CustomerId,@TotalWinAmount,1,@SlipId
							 
																			update Customer.SlipSystem set SlipStateId=3 ,MaxGain=@TotalWinAmount,EvaluateDate=GETDATE(),IsPayOut= Case when @IsBranchCustomer=1 then 0 else 1 end where SystemSlipId=@SystemSlipId
																			update Customer.Slip set SlipStateId=3 ,EvaluateDate=GETDATE(),IsPayOut  =Case when @IsBranchCustomer=1 then 0 else 1 end where SlipId=@SlipId
																			update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3

																				if (select EXP(SUM(LOG(OddValue))) from Customer.SlipOdd with (nolock) where SlipId=@SlipId)=1 -- Eğer kupondaki tüm maçlar cancel olduysa tax da geri yükleniyor.
																						begin
																							declare @TaxAmount money=0
																							declare @TaxId bigint=0
																							select @TaxAmount=TaxAmount,@TaxId=Customer.Tax.TaxId from Customer.Tax where SlipId=@SystemSlipId and SlipTypeId=3
																							update Customer.Tax set TaxStatusId=2 where SlipId=@SlipId
																									update Customer.SlipSystem set  MaxGain=@TotalWinAmount+@TaxAmount  where SystemSlipId=@SystemSlipId
																							exec  [Job].[FuncCustomerBooking2]  @CustomerId,@TaxAmount,1,54,@TaxId

																						end

																			end
																			end
																	end
																else
																	begin
																		if not exists(select Customer.SlipOdd.SlipId from Customer.SlipOdd with (nolock)  where SlipId=@SlipId and StateId=1)
																			begin
																		 
																			update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
																			update Customer.Slip set SlipStateId=4 ,EvaluateDate=GETDATE() where SlipId=@SlipId
																			update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
																		
																			 end
																		--else if exists(Select Customer.Slip.SlipId from Customer.Slip where SlipId=@SlipId and SlipStateId=4 )
																		--	begin
																		--		update Customer.SlipSystem set SlipStateId=1,EvaluateDate=null where SystemSlipId=@SystemSlipId
																		--	update Customer.Slip set SlipStateId=1 ,EvaluateDate=null where SlipId=@SlipId
																		--	end
																	end

												end
									end
								else
									begin
										 
																			update Customer.SlipSystem set SlipStateId=4,EvaluateDate=GETDATE() where SystemSlipId=@SystemSlipId
																			update Customer.Slip set SlipStateId=4 ,EvaluateDate=GETDATE() where SlipId=@SlipId
																			update Customer.Tax set TaxStatusId=3 where SlipId =@SystemSlipId and SlipTypeId=3
																		 
									end

						
	set @TotalWinAmount=0
	set @WinAmount=0
 --delete from  @tblOdd

end
							fetch next from cur111 into @SlipId,@CustomerId,@Amount,@SlipTypeId,@Systems,@SystemSlipId,@CouponCount
			
						end
					close cur111
					deallocate cur111

					delete @tempSlip
end


GO
