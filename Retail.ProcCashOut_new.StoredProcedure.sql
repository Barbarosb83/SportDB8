USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcCashOut_new]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcCashOut_new] 
@SlipId bigint,
@LangId int,
@CashOutValue money,
 @CustomerId bigint,
 @username nvarchar(max)
AS

begin
--	 declare @WinAmount money=0
--declare @WinAmountReel money=0
--declare @TotalWinAmount money=0
--declare @TotalWinAmountReel money=0
--declare @SystemSlipId bigint
declare @Comment nvarchar(50)
--declare @BetType int
--declare @MatchId bigint
--declare @BetradarMatchId bigint
--declare @ParameterOddId int
--declare @OddValue float
--declare @Remaningtime int
--declare @Remaningtime2 int=9999
--declare @EventDate datetime
--declare @SpecialBetValue nvarchar(50)
--declare @Amount money
--declare @OddId bigint 
--declare @Outcome nvarchar(50)
--declare @SlipOddId bigint
--declare @LiveEventId bigint
--declare @SportId int
--declare @SportTime int
--declare @ActiveSportTime int
--declare @IsActive bit
--declare @IsLive bit
--declare @StateId int
--declare @Score nvarchar(20)
--declare @LegScore nvarchar(20)
--declare @EventName nvarchar(200)
--declare @CustomerOddValue float
--declare @CustomerOutCome nvarchar(150)
--declare @OddTypeId int
--declare @OddType nvarchar(100)
--declare @MatchTime nvarchar(20)
--declare @TimeStatu int
--declare @IsWon bit
--declare @Oldprobodd decimal(18,2)=0
declare @CashOut money=0
--declare @OddProfitfactor float
--declare @EventId bigint
--declare @SystemCashOut money=0
--declare @IsCashout bit=1
--declare @TotalOddValue float=0
--declare @ProfitFactor float=1
--declare @ReelValue money=@Amount
--declare @LayRate float=0
--declare @CurrentOddValue float
declare @resultcode int=106
declare @resultmessage nvarchar(max)='Hata oluştu'
declare @UserId int
declare @UserBranchId int
declare @UserBranchBalance money
declare @Control int=1
declare @BranchCurrencyId int
declare @IsBranchCustomer bit 
declare @Balance money
declare @direction int
declare @ParentBranch int
declare @CustomerBranchId int
declare @CustomerParentBranchId int
--declare @OddKey float=1.05
--declare @probodd decimal(18,2)
--declare @CashOutKey float=1.015
-- declare @TotalProb float=0
--   declare @SlipScore nvarchar(20)
--   	declare @MatchScore nvarchar(20)
--	declare @ActiveHomeScore int
--declare @ActiveAwayScore int
--declare @ActiveGoal int
--declare @CustomerTotalGoal int
--declare @HomeScore int
--declare @AwayScore int
--declare @Fark int
-- declare @Banko int
  insert dbo.betslip values (@CustomerId,CAST(@SlipId as nvarchar(20))+' username :'+@username,GETDATE())
declare @SlipSystemCashOut money
 declare @CustomerSpecialBetValue nvarchar(200)
			declare @CustomerBalance money
							declare @UserBalance money
select @UserBranchId=Users.Users.UnitCode
,@UserBranchBalance=Parameter.Branch.Balance
,@UserId=Users.Users.UserId
,@BranchCurrencyId=Parameter.Branch.CurrencyId
,@ParentBranch=Parameter.Branch.ParentBranchId
from Users.Users INNER JOIN 
Parameter.Branch on Parameter.Branch.BranchId=Users.UnitCode
 where Users.Users.UserName=@username

 select @direction=Parameter.TransactionTypeBranch.Direction from Parameter.TransactionTypeBranch with (nolock)
where Parameter.TransactionTypeBranch.BranchTransactionTypeId=11

declare @BranchIdCustomer int
 declare @CustomerCurrencyId int
 declare @SlipCustomerId bigint
select @CustomerCurrencyId=CurrencyId,@BranchIdCustomer=BranchId  from Customer.Customer where CustomerId=@CustomerId


select @CustomerBranchId=BranchId,@IsBranchCustomer=IsBranchCustomer,@SlipCustomerId=CustomerId from Customer.Customer with (nolock) where CustomerId=(
select top 1 CustomerId from Customer.Slip with (nolock) where SlipId=@SlipId)

select @CustomerParentBranchId=ParentBranchId from Parameter.Branch with (nolock) where BranchId=@CustomerBranchId

--declare @TLiveEvent table (BetradarMatchId bigint not null,EventId bigint not null,ConnectionStatu int)
--declare @TLiveEvenDetail table (EventId bigint not null,BetStatus int,TimeStatu int,BetradarMatchId bigint,MatchTime bigint,Score nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,LegScore nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS )
--declare @TArchiveLiveEvenDetail table (EventId bigint not null,BetStatus int,TimeStatu int,BetradarMatchId bigint,MatchTime bigint,Score nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,LegScore nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS )
--declare @TLiveEventOdd table (BetradarMatchId bigint not null,MatchId bigint not null,ParameterOddId int,OutCome nvarchar(100),SpecialBetValue nvarchar(100),IsEvaluated bit,OddResult bit,IsCanceled bit,OddValue float,OddId bigint,IsActive bit,OddsTypeId int)
--declare @TempSlip table (BetradarMatchId bigint not null)

--declare @TLiveEventOddResult table (BetradarMatchId bigint not null,OutCome nvarchar(100),SpecialBetValue nvarchar(100),IsEvaluated bit,OddResult bit,IsCanceled bit,OddId bigint)

--declare @TempTable table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float)

--declare @TempTable2 table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float)


--declare @TempTableSystem table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float,OldOddProb float)

--declare @TCashoutKey table (CashoutKeyId int not null,Value1 float not null,Value2 float not null,CashoutKey float not null)
--insert @TCashoutKey
--select * from Parameter.CashoutKey
--declare @TCashoutKey2 table (CashoutKeyId int not null,Value1 float not null,Value2 float not null,CashoutKey float not null)



--insert @TCashoutKey2
--select * from Parameter.CashoutKey2

 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOutValue,GETDATE(),'Request')
if((Select Count(*) from Customer.Slip with (nolock) where SlipId=@SlipId and (SlipStateId=1 or SlipTypeId=3))>0 and (@ParentBranch=@CustomerParentBranchId or @CustomerBranchId=@ParentBranch or @UserBranchId=@CustomerBranchId or @CustomerParentBranchId=@UserBranchId) )
begin

waitfor delay '00:00:05.000'
if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId<3 and SlipStateId=1 and (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0 )
begin


					 -- if(@CashOutValue>1)
						--	exec  @CashOut=  [GamePlatform].[FuncCashOutSlipDetail3] @SlipId,2
						--else
						--	set @CashOut=0.5

						if(@CashOutValue>1)
							exec  @CashOut=  [GamePlatform].[FuncCashOutSlipDetail] @SlipId,2
						else
							set @CashOut=0.5

					 
					 if not exists (select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=7)
					 begin
						if (@CashOut>1 )  --Cash out hala veriliyormu diye kontrol ediliyor.
						begin
							if( @CashOutValue-1.00<=@CashOut and @CashOut>1 and  @CashOutValue>0  )   --Gelen Cashout değeri 0 dan büyük ve son hesaplanan ile aynı veya küçük mü diye bakılıyor.
								begin
								--	if (@BranchIdCustomer=@CustomerBranchId or @CustomerParentBranchId=@BranchIdCustomer)
										--begin
										update Customer.Slip set SlipStateId=7,IsPayOut=1,EvaluateDate=GETDATE()  where SlipId=@SlipId  --Slip Cash out ile sonuçlandırılıyor.
						 
									 
 
										insert Customer.SlipCashOut (SlipId,CashOutValue,CreateDate) values (@SlipId,@CashOutValue,GETDATE())

										if(select COUNT(TaxAmount) from Customer.Tax with (nolock) where SlipId=@SlipId and SlipTypeId=2)>0 --Kuponun tax ı varsa tax onaylanıyor
											begin
											update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId  and SlipTypeId=2
											end
								set @Comment  =cast(@SlipId as nvarchar(50))
									if(@Control=1)
											begin
						  

											 
						
											select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer with (nolock) where Customer.CustomerId=@CustomerId
											set @CustomerBalance=@Balance
										 

											select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction with (nolock)
											where UserId=@UserId and TransactionTypeId not in (3,5) order by CreateDate desc

											if(@direction=1)
												begin
													if (@IsBranchCustomer=1)
														begin
															set @UserBalance=ISNULL(@UserBalance,0)-@CashOutValue

															insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
															values(@UserBranchId,@CustomerId,11,@CashOutValue,@BranchCurrencyId,GETDATE(),@UserId,@UserBalance,@SlipId)

															update Parameter.Branch set Balance=Balance+@CashOutValue where BranchId=@UserBranchId
														end
													else
														begin
														set @Comment  =cast(@SlipId as nvarchar(50))
																exec Job.FuncCustomerBooking2 @SlipCustomerId,@CashOutValue,1,63,@Comment 
														end
										
								
											  end
											else if (@direction=0)
												begin
												set @UserBalance=ISNULL(@UserBalance,0)+@CashOutValue

								insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
								values(@UserBranchId,@CustomerId,11,@CashOutValue,@BranchCurrencyId,GETDATE(),@UserId,@UserBalance,@SlipId)
										
										update Parameter.Branch set Balance=Balance-@CashOutValue where BranchId=@UserBranchId
								
							end
					
						
												select @resultcode=ErrorCodeId,@resultmessage=ErrorCode from Log.ErrorCodes where ErrorCodeId=104 and Log.ErrorCodes.LangId=@LangId
											end

									set @resultmessage='Cashout succes'
									set @resultcode=1
									--end
									--else
									--	begin
									--		set @resultmessage='Das Ticket ist nicht von dieser Filialle'
									--set @resultcode=-1
									--	end
								end
								else
									begin
									set @resultmessage='Cashout value is change'
									set @resultcode=-1
									 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@resultmessage)
									end

						end
						else
							begin
									set @resultmessage='Minumum Cashout betragt 1 euro'
												set @resultcode=-1
												 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@resultmessage)
							end
					end
					else
					begin
							set @resultcode=-1
						    set @resultmessage='CashOut is not active'
							 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@resultmessage)
					end
					
end
 else if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=4 and (Select COUNT(Customer.SlipSystem.SystemSlipId) from Customer.SlipSystem with (nolock) where SystemSlipId=(select Top 1 SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId) and SlipStateId=1)>0  and  (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0 )
 begin 

						--if(@CashOutValue>1)
						--	exec  @CashOut=  [GamePlatform].[FuncCashOutSlipDetail3] @SlipId,2
						--else
						--	set @CashOut=0.5

						if(@CashOutValue>1)
							exec  @CashOut=  [GamePlatform].[FuncCashOutSlipDetail] @SlipId,2
						else
							set @CashOut=0.5

						 if not exists (select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=7)  --Cash out hala veriliyormu diye kontrol ediliyor.
						begin
							if(@CashOut>1 and @CashOutValue>1  and @CashOut>=@CashOutValue-1.00  ) --Gelen Cashout değeri 0 dan büyük ve son hesaplanan ile aynı veya küçük mü diye bakılıyor.
								begin
								 
										update Customer.Slip set SlipStateId=7,IsPayOut=1,EvaluateDate=GETDATE()  where SlipId=@SlipId  --Slip Cash out ile sonuçlandırılıyor.
						 
										update Customer.SlipSystem set SlipStateId=7 , IsPayOut=1 ,EvaluateDate=GETDATE() where SystemSlipId in (Select SystemSlipId from Customer.SlipSystemSlip where SlipId=@SlipId)
 
										insert Customer.SlipCashOut (SlipId,CashOutValue,CreateDate) values (@SlipId,@CashOutValue,GETDATE())

										if(select COUNT(TaxAmount) from Customer.Tax where SlipId=@SlipId)>0 --Kuponun tax ı varsa tax onaylanıyor
											begin
											update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId  and SlipTypeId=2
											end
								--set @Comment  =cast(@SlipId as nvarchar(50))
								--	exec Job.FuncCustomerBooking2 @CustomerId,@CashOutValue,1,63,@Comment --Hesabına transaction type cashout olarak ödeme yapılıyor


											select @Balance=ISNULL(Customer.Customer.Balance,0) from Customer.Customer with (nolock) where Customer.CustomerId=@CustomerId
											set @CustomerBalance=@Balance
										 

											select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction with (nolock)
											where UserId=@UserId and TransactionTypeId not in (3,5) order by CreateDate desc

											if(@direction=1)
												begin
													if (@IsBranchCustomer=1)
														begin
															set @UserBalance=ISNULL(@UserBalance,0)-@CashOutValue

															insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
															values(@UserBranchId,@CustomerId,11,@CashOutValue,@BranchCurrencyId,GETDATE(),@UserId,@UserBalance,@SlipId)

															update Parameter.Branch set Balance=Balance+@CashOutValue where BranchId=@UserBranchId
														end
													else
														begin
														set @Comment  =cast(@SlipId as nvarchar(50))
																exec Job.FuncCustomerBooking2 @SlipCustomerId,@CashOutValue,1,63,@Comment 
														end
										
								
											  end
											else if (@direction=0)
												begin
												set @UserBalance=ISNULL(@UserBalance,0)+@CashOutValue

								insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
								values(@UserBranchId,@CustomerId,11,@CashOutValue,@BranchCurrencyId,GETDATE(),@UserId,@UserBalance,@SlipId)
										
										update Parameter.Branch set Balance=Balance-@CashOutValue where BranchId=@UserBranchId	
										end

									set @resultmessage='Cashout succes'
									set @resultcode=1

								end
								else
									begin
										if(@CashOut>1)
										begin
										set @resultmessage='Cashout value is change'
										set @resultcode=-1
												 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@resultmessage)
										end
										else
											begin
												set @resultmessage='Minumum Cashout betragt 1 euro'
												set @resultcode=-1
														 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@resultmessage)
											end
									end

						end
						else
							begin
								set @resultcode=-1
								set @resultmessage='CashOut is not active'
										 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@resultmessage)
							end

					 
							--from @TempTableSystem2
						end
  else if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=5 and (Select COUNT(Customer.SlipSystem.SystemSlipId) from Customer.SlipSystem with (nolock) where SystemSlipId=(select Top 1 SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId) and SlipStateId=1)>0  and  (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0  )
 
						begin
					--if(@CashOutValue>1)
					--		exec  @CashOut=  [GamePlatform].[FuncCashOutSlipDetail3] @SlipId,2
					--	else
					--		set @CashOut=0.5

						if(@CashOutValue>1)
							exec  @CashOut=  [GamePlatform].[FuncCashOutSlipDetail] @SlipId,2
						else
							set @CashOut=0.5
							
						 if not exists (select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=7) --Cash out hala veriliyormu diye kontrol ediliyor.
							begin
							if(@CashOut>1 and @CashOutValue>1 and  @CashOut>=@CashOutValue-1.000   ) --Gelen Cashout değeri 0 dan büyük ve son hesaplanan ile aynı veya küçük mü diye bakılıyor.
								begin
								 
										update Customer.Slip set SlipStateId=7,IsPayOut=1,EvaluateDate=GETDATE()  where SlipId=@SlipId  --Slip Cash out ile sonuçlandırılıyor.
						 
										update Customer.SlipSystem set SlipStateId=7 , IsPayOut=1 ,EvaluateDate=GETDATE() where SystemSlipId in (Select SystemSlipId from Customer.SlipSystemSlip where SlipId=@SlipId)
 
										insert Customer.SlipCashOut (SlipId,CashOutValue,CreateDate) values (@SlipId,@CashOutValue,GETDATE())

										if(select COUNT(TaxAmount) from Customer.Tax where SlipId=@SlipId)>0 --Kuponun tax ı varsa tax onaylanıyor
											begin
											update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId  and SlipTypeId=2
											end
								--set @Comment  =cast(@SlipId as nvarchar(50))
								--	exec Job.FuncCustomerBooking2 @CustomerId,@CashOutValue,1,63,@Comment --Hesabına transaction type cashout olarak ödeme yapılıyor


										select top 1 @UserBalance=ISNULL(RiskManagement.BranchTransaction.CashboxBalance,0) from RiskManagement.BranchTransaction with (nolock)
											where UserId=@UserId and TransactionTypeId not in (3,5) order by CreateDate desc

											if(@direction=1)
												begin
													if (@IsBranchCustomer=1)
														begin
															set @UserBalance=ISNULL(@UserBalance,0)-@CashOutValue

															insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
															values(@UserBranchId,@CustomerId,11,@CashOutValue,@BranchCurrencyId,GETDATE(),@UserId,@UserBalance,@SlipId)

															update Parameter.Branch set Balance=Balance+@CashOutValue where BranchId=@UserBranchId
														end
													else
														begin
														set @Comment  =cast(@SlipId as nvarchar(50))
																exec Job.FuncCustomerBooking2 @SlipCustomerId,@CashOutValue,1,63,@Comment 
														end
										
								
											  end
											else if (@direction=0)
												begin
												set @UserBalance=ISNULL(@UserBalance,0)+@CashOutValue

								insert RiskManagement.BranchTransaction (BranchId,CustomerId,TransactionTypeId,Amount,CurrencyId,CreateDate,UserId,[CashboxBalance],SlipId)
								values(@UserBranchId,@CustomerId,11,@CashOutValue,@BranchCurrencyId,GETDATE(),@UserId,@UserBalance,@SlipId)
										
										update Parameter.Branch set Balance=Balance-@CashOutValue where BranchId=@UserBranchId	
										end

									set @resultmessage='Cashout succes'
									set @resultcode=1

								end
									else
									begin
										if(@CashOut>1)
										begin
										set @resultmessage='Cashout value is change'
										set @resultcode=-1
												 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@resultmessage)
										end
										else
											begin
												set @resultmessage='Minumum Cashout betragt 1 euro'
												set @resultcode=-1
														 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@resultmessage)
											end
									end

						end
						else
							begin
								set @resultcode=-1
								set @resultmessage='CashOut is not active'
										 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@resultmessage)
							end
							--from @TempTableSystem2
						end
end

else
	begin
		set @resultcode=-1
							set @resultmessage='CashOut is not active'
									 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@resultmessage)
	end
					--	select * from @TempTable
						select @resultcode as resultcode,@resultmessage as resultmessage


end
GO
