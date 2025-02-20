USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCashOutTerminal_OLD]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcCashOutTerminal_OLD] 
@SlipId bigint,
@LangId int,
@CashOutValue money,
 @CustomerId bigint
AS

begin

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
--declare @Outcome nvarchar(50)
--declare @SlipOddId bigint
--declare @LiveEventId bigint
--declare @SportId int
--declare @OddId bigint 
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
declare @CashOut money=3.50
--declare @OddProfitfactor float
--declare @EventId bigint
--declare @SystemCashOut money=0
--declare @IsCashout bit=1
--declare @TotalOddValue float=0
--declare @ProfitFactor float=1
--declare @ReelValue money=@Amount
--declare @LayRate float=0
--declare @CurrentOddValue float
declare @resultId int
declare @result nvarchar(150)
--declare @OddKey float=1.05
--declare @probodd decimal(18,2)=0
--declare @Oldprobodd decimal(18,2)=0
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
--declare @Banko int

--	 declare @WinAmount money=0
--declare @WinAmountReel money=0
--declare @TotalWinAmount money=0
--declare @TotalWinAmountReel money=0

--declare @SlipSystemCashOut money
-- declare @CustomerSpecialBetValue nvarchar(200)
--declare @TLiveEvent table (BetradarMatchId bigint not null,EventId bigint not null,ConnectionStatu int)
--declare @TLiveEvenDetail table (EventId bigint not null,BetStatus int,TimeStatu int,BetradarMatchId bigint,MatchTime bigint,Score nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,LegScore nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS )
--declare @TArchiveLiveEvenDetail table (EventId bigint not null,BetStatus int,TimeStatu int,BetradarMatchId bigint,MatchTime bigint,Score nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,LegScore nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS )
--declare @TLiveEventOdd table (BetradarMatchId bigint not null,MatchId bigint not null,ParameterOddId int,OutCome nvarchar(100),SpecialBetValue nvarchar(100),IsEvaluated bit,OddResult bit,IsCanceled bit,OddValue float,OddId bigint,IsActive bit,OddsTypeId int)
--declare @TLiveEventOddResult table (BetradarMatchId bigint not null,OutCome nvarchar(100),SpecialBetValue nvarchar(100),IsEvaluated bit,OddResult bit,IsCanceled bit,OddId bigint)

--declare @TempSlip table (BetradarMatchId bigint not null)

--declare @TempTable table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float)

--declare @TempTable2 table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float)


--declare @TempTableSystem table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float,OldOddProb float)

--declare @TCashoutKey table (CashoutKeyId int not null,Value1 float not null,Value2 float not null,CashoutKey float not null)
--declare @TCashoutKey2 table (CashoutKeyId int not null,Value1 float not null,Value2 float not null,CashoutKey float not null)


--insert @TCashoutKey2
--select * from Parameter.CashoutKey2

--insert @TCashoutKey
--select * from Parameter.CashoutKey
 
insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOutValue,GETDATE(),'Request')

if((select CustomerId from Customer.Slip with (nolock) where SlipId=@SlipId)=@CustomerId)
begin

waitfor delay '00:00:05.000'
if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId<3 and SlipStateId=1  and (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0 )
begin

	if(@CashOutValue>1)
							exec  @CashOut=  [GamePlatform].[FuncCashOutSlipDetail3] @SlipId,2
						else
							set @CashOut=0.5

		--if(@CashOutValue>1)
		--					exec  @CashOut=  [GamePlatform].[FuncCashOutSlipDetail] @SlipId,2
		--				else
		--					set @CashOut=0.5

							 if not exists (select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=7)  --Cash out hala veriliyormu diye kontrol ediliyor.
						begin
						if(@CashOut>1 and @CashOutValue>1 and @CashOut>=@CashOutValue-1.000 )-- and @CashOutValue=@CashOut and (Select Count(Customer.Slip.SlipId) from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=1)>0) --Gelen Cashout değeri 0 dan büyük ve son hesaplanan ile aynı veya küçük mü diye bakılıyor.
								begin
								 
										update Customer.Slip set SlipStateId=7,IsPayOut=1,EvaluateDate=GETDATE()  where SlipId=@SlipId  --Slip Cash out ile sonuçlandırılıyor.
						 
									 
 
										insert Customer.SlipCashOut (SlipId,CashOutValue,CreateDate) values (@SlipId,@CashOutValue,GETDATE())

										if(select COUNT(TaxAmount) from Customer.Tax with (nolock) where SlipId=@SlipId and SlipTypeId=2)>0 --Kuponun tax ı varsa tax onaylanıyor
											begin
											update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId and SlipTypeId=2
											end
								set @Comment  =cast(@SlipId as nvarchar(50))
									exec Job.FuncCustomerBooking2 @CustomerId,@CashOutValue,1,63,@Comment --Hesabına transaction type cashout olarak ödeme yapılıyor

									set @result='Cashout succes'
									set @resultId=1

								end
								else
									begin
										if(@CashOut>1)
										begin
										set @result='Cashout value is change'
										set @resultId=-1
										 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@result)
										end
										else
											begin

												set @result='Minumum Cashout betragt 1 euro'
												set @resultId=-1
												 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@result)
											end
									end

						end
						else
							begin
								set @resultId=-1
								set @result='CashOut is not active'
								 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@result)
							end
					
end
 else if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=4 and (Select COUNT(Customer.SlipSystem.SystemSlipId) from Customer.SlipSystem with (nolock) where SystemSlipId=(select Top 1 SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId) and SlipStateId=1)>0  and  (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0  )
 begin 
					if(@CashOutValue>1)
							exec  @CashOut=  [GamePlatform].[FuncCashOutSlipDetail3] @SlipId,2
						else
							set @CashOut=0.5

					--if(@CashOutValue>1)
					--		exec  @CashOut=  [GamePlatform].[FuncCashOutSlipDetail] @SlipId,2
					--	else
					--		set @CashOut=0.5

					 if not exists (select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=7)  --Cash out hala veriliyormu diye kontrol ediliyor.
						begin
						if(@CashOut>1 and @CashOutValue>1 and @CashOut>=@CashOutValue-1.000 ) --Gelen Cashout değeri 0 dan büyük ve son hesaplanan ile aynı veya küçük mü diye bakılıyor.
								begin
								 
										update Customer.Slip set SlipStateId=7,IsPayOut=1,EvaluateDate=GETDATE()  where SlipId=@SlipId  --Slip Cash out ile sonuçlandırılıyor.
						 
										update Customer.SlipSystem set SlipStateId=7 , IsPayOut=1 ,EvaluateDate=GETDATE() where SystemSlipId in (Select SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId)
 
										insert Customer.SlipCashOut (SlipId,CashOutValue,CreateDate) values (@SlipId,@CashOutValue,GETDATE())

										if(select COUNT(TaxAmount) from Customer.Tax with (nolock) where SlipId=@SlipId)>0 --Kuponun tax ı varsa tax onaylanıyor
											begin
											update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId  and SlipTypeId=2
											end
								set @Comment  =cast(@SlipId as nvarchar(50))
									exec Job.FuncCustomerBooking2 @CustomerId,@CashOutValue,1,63,@Comment --Hesabına transaction type cashout olarak ödeme yapılıyor

									set @result='Cashout succes'
									set @resultId=1

								end
								else
									begin
										if(@CashOut>1)
										begin
										set @result='Cashout value is change'
										set @resultId=-1
										 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@result)
										end
										else
											begin
												set @result='Minumum Cashout betragt 1 euro'
												set @resultId=-1
												 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@result)
											end
									end

						end
						else
							begin
								set @resultId=-1
								set @result='CashOut is not active'
								 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@result)
							end

					 
							--from @TempTableSystem2
						end
  else if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=5 and (Select COUNT(Customer.SlipSystem.SystemSlipId) from Customer.SlipSystem with (nolock) where SystemSlipId=(select Top 1 SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId) and SlipStateId=1)>0  and  (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0 )
 
						begin
					if(@CashOutValue>1)
							exec  @CashOut=  [GamePlatform].[FuncCashOutSlipDetail3] @SlipId,2
						else
							set @CashOut=0.5

					--if(@CashOutValue>1)
					--		exec  @CashOut=  [GamePlatform].[FuncCashOutSlipDetail] @SlipId,2
					--	else
					--		set @CashOut=0.5

					 if not exists (select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipStateId=7)  --Cash out hala veriliyormu diye kontrol ediliyor.
						begin
						if(@CashOut>1 and @CashOutValue>0 and @CashOut>=@CashOutValue-1.000 ) --Gelen Cashout değeri 0 dan büyük ve son hesaplanan ile aynı veya küçük mü diye bakılıyor.
								begin
								 
										update Customer.Slip set SlipStateId=7,IsPayOut=1,EvaluateDate=GETDATE()  where SlipId=@SlipId  --Slip Cash out ile sonuçlandırılıyor.
						 
										update Customer.SlipSystem set SlipStateId=7 , IsPayOut=1 ,EvaluateDate=GETDATE() where SystemSlipId in (Select SystemSlipId from Customer.SlipSystemSlip where SlipId=@SlipId)
 
										insert Customer.SlipCashOut (SlipId,CashOutValue,CreateDate) values (@SlipId,@CashOutValue,GETDATE())

										if(select COUNT(TaxAmount) from Customer.Tax with (nolock) where SlipId=@SlipId)>0 --Kuponun tax ı varsa tax onaylanıyor
											begin
											update Customer.Tax set TaxStatusId=3 where SlipId=@SlipId  and SlipTypeId=2
											end
								set @Comment  =cast(@SlipId as nvarchar(50))
									exec Job.FuncCustomerBooking2 @CustomerId,@CashOutValue,1,63,@Comment --Hesabına transaction type cashout olarak ödeme yapılıyor

									set @result='Cashout succes'
									set @resultId=1

								end
								else
									begin
										if(@CashOut>1)
										begin
										set @result='Cashout value is change'
										set @resultId=-1
										 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@result)
										end
										else
											begin
												set @result='Minumum Cashout betragt 1 euro'
												set @resultId=-1
												 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@result)
											end
									end

						end
						else
							begin
								set @resultId=-1
								set @result='CashOut is not active'
								 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@result)
							end
							--from @TempTableSystem2
						end
end

else
	begin
		set @resultId=-1
							set @result='CashOut is not active'
							 insert Customer.SlipCashoutHistory (SlipId,CashoutValue,CreateDate,Activity) values (@SlipId,@CashOut,GETDATE(),@result)
	end
					--	select * from @TempTable
						select @resultId as ResultId,@result as ResultMessage


end
GO
