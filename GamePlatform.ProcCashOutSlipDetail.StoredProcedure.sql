USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCashOutSlipDetail]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcCashOutSlipDetail] 
@SlipId bigint,
@LangId int
AS
declare @BetType int
declare @MatchId bigint
declare @BetradarMatchId bigint
declare @ParameterOddId int
declare @OddValue float
declare @Remaningtime int
declare @Remaningtime2 int=9999
declare @EventDate datetime
declare @SpecialBetValue nvarchar(50)
declare @Amount money
declare @Outcome nvarchar(50)
declare @SlipOddId bigint
declare @Banko int
declare @LiveEventId bigint
declare @SportId int
declare @SportTime int
declare @ActiveSportTime int
declare @IsActive bit
declare @IsLive bit
declare @StateId int
declare @Score nvarchar(30)
declare @LegScore nvarchar(20)
declare @EventName nvarchar(200)
declare @CustomerOddValue float
declare @CustomerOutCome nvarchar(150)
declare @OldOutCome nvarchar(150)
declare @OddTypeId int
declare @OddType nvarchar(100)
declare @MatchTime nvarchar(20)
declare @TimeStatu int
declare @IsWon bit
declare @CashOut money=3.50
declare @OddProfitfactor float
declare @EventId bigint
declare @OddId bigint 
declare @SystemCashOut money=0
declare @SlipSystemCashOut money
declare @IsCashout bit=1
declare @OddKey float=1.05
declare @probodd float=0
declare @Oldprobodd decimal(18,2)=0
declare @CashOutKey float=1.015
declare @TotalProb float=0
declare @CustomerSpecialBetValue nvarchar(200)
declare @MatchScore nvarchar(20)
declare @WinAmount money=0
declare @WinAmountReel money=0
declare @WinAmountActive money=0
declare @TotalWinAmount money=0
declare @TotalWinAmountReel money=0
declare @ActiveHomeScore int
declare @ActiveAwayScore int
declare @ActiveGoal int
declare @CustomerTotalGoal int
declare @HomeScore int
declare @AwayScore int
declare @Fark int
declare @ActiveHomeFark int=0
declare @ActiveAwayFark int=0
declare @Reason  nvarchar(150)  
declare @BetStopReason  nvarchar(150)=''
declare @BetStopReasonId int=0
declare @OrgSpecialValue  nvarchar(150)  
declare @SlipScore nvarchar(20)
declare @TotalOddValue float=0
					declare @ProfitFactor float=1
					declare @ReelValue money=@Amount
					declare @LayRate float=0
					declare @CurrentOddValue float
					   declare @timestatu2 int
					   declare @OldOddTypeId int
					   declare @OldSpecialValue nvarchar(150)
declare @CurrentProb float
declare @CustomerId bigint
declare @SystemAmount money
select @CustomerId=CustomerId from Customer.Slip where SlipId=@SlipId
	declare @activetimestatuu int
		declare @activetimestatu int 
declare @TCashoutKey2 table (CashoutKeyId int not null,Value1 float not null,Value2 float not null,CashoutKey float not null)

declare @OldBetradarMatchId bigint=0
declare @TotalProbTickettime float=0
					declare @TotalProbCurrenTime float=0
					declare @ValueTicketTime float
					declare @TicketValueFactor float
					declare @ReductionFactor float
					declare @ExpectedProfit float
					declare @ProportionTicketTime float=50
					declare @DeltaProb float
					declare @CashoutValueTicketTime float
					declare @OverallEffect float
					declare @OverallEffectAbs float
					
					declare @LowerTicketValueLadder float
					declare @UpperTicketValueLadder float
					declare @LowerReductionFactor float
					declare @UpperReductionFactor float
					declare @Interpolation float
					declare @CashoutNoMargin money
					declare @CashoutLadder money
					declare @cashoutfactor decimal(18,3)
									declare @decfactor float=0
									declare @ticketvaluefack float=0
									declare @reducation float=0
									 
 
declare @TLiveEvent table (BetradarMatchId bigint not null,EventId bigint not null,ConnectionStatu int,TournamentId bigint)
declare @TLiveEvenDetail table (EventId bigint not null,BetStatus int,TimeStatu int,BetradarMatchId bigint,MatchTime bigint,Score nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,LegScore nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS ,IsActive bit,ReasonId int)
--declare @TArchiveLiveEvenDetail table (EventId bigint not null,BetStatus int,TimeStatu int,BetradarMatchId bigint,MatchTime bigint,Score nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,LegScore nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS )
declare @TLiveEventOdd table (BetradarMatchId bigint not null,MatchId bigint not null,ParameterOddId int,OutCome nvarchar(100),SpecialBetValue nvarchar(100),IsEvaluated bit,OddResult bit,IsCanceled bit,OddValue float,OddId bigint,IsActive bit,OddsTypeId int,OddProb float)

declare @TLiveEventOddResult table (BetradarMatchId bigint not null,OutCome nvarchar(100),SpecialBetValue nvarchar(100),IsEvaluated bit,OddResult bit,IsCanceled bit,OddId bigint)
declare @TLiveEventProb table (OddId bigint,OddsTypeId  int,OutCome nvarchar(100),SpecialBetValue nvarchar(100),ProbilityValue nvarchar(50),MatchId bigint,BettradarOddId bigint,ParameterOddId int,MarketStatus int,CashoutStatus int,BetradarTimeStamp datetime,UpdatedDate datetime,BetradarMatchId bigint,EvaluatedDate datetime,BetradarOddsTypeId  bigint,BetradarOddsSubTypeId bigint,OutcomeActive bit)

declare @TempSlip table (BetradarMatchId bigint not null)

declare @TempTable table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float,Reason nvarchar(150),CurrentProb float,BetStopReason nvarchar(150),BetStopReasonId int )
declare @TempTableNew table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float,OldOddProd float,Reason nvarchar(150))

declare @TempTable2 table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float,Reason nvarchar(150))
declare @TempTableSystem table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float,OldOddProb float,Reason nvarchar(150),CurrentProb float,OddTypeId int,OrgSpecialBetValue nvarchar(150),BetStopReason nvarchar(150),BetStopReasonId int,SlipStateId int)

declare @TempTableSystem2 table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float,OldOddProb float,Reason nvarchar(150),CurrentProb float,OddTypeId int,OrgSpecialBetValue nvarchar(150),BetStopReason nvarchar(150),BetStopReasonId int,SlipStateId int)






  

declare @ActiveFark int=-1

if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId<3 and SlipStateId=1  and (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0 /*and (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and SportId  in (4))=0 */ )
	begin
	 
declare @TCashoutKey3 table (TicketValueFactor float,DeductionFactor float)

insert @TCashoutKey3
select TicketValueFactor,DeductionFactor from Parameter.CashoutKey3 with (nolock)

insert @TempSlip
SELECT    Customer.SlipOdd.BetradarMatchId
	FROM         
						  Customer.SlipOdd with (nolock) 
	WHERE     (Customer.SlipOdd.SlipId = @SlipId) AND (Customer.SlipOdd.BetTypeId in (1,0))

	
		insert into @TLiveEvent
			select [BettingLive].Live.[Event].BetradarMatchId,[BettingLive].Live.[Event].EventId,[BettingLive].Live.[Event].ConnectionStatu,TournamentId 
			from [BettingLive].Live.[Event] with (nolock) --INNER JOIN @TempSlip as TS ON Live.[Event].BetradarMatchId=TS.BetradarMatchId
			 where [BettingLive].Live.[Event].BetradarMatchId in (Select BetradarMatchId from @TempSlip)

		insert into @TLiveEvenDetail
			select Live.EventDetail.EventId,Live.EventDetail.BetStatus,Live.EventDetail.TimeStatu,Live.EventDetail.BetradarMatchIds,MatchTime,Score,LegScore,IsActive,BetStopReasonId
			from Live.EventDetail with (nolock) -- INNER JOIN @TempSlip as TMP On Live.EventDetail.BetradarMatchIds=TMP.BetradarMatchId  
			 where Live.EventDetail.BetradarMatchIds in (Select BetradarMatchId from @TempSlip)

			--insert into @TArchiveLiveEvenDetail
			--select Archive.[Live.EventDetail].EventId,Archive.[Live.EventDetail].BetStatus,Archive.[Live.EventDetail].TimeStatu,Archive.[Live.EventDetail].BetradarMatchIds,MatchTime,Score,LegScore 
			--from Archive.[Live.EventDetail] with (nolock) where Archive.[Live.EventDetail].BetradarMatchIds in (Select BetradarMatchId from @TempSlip)

		insert into @TLiveEventOdd
		select Live.EventOdd.BetradarMatchId,Live.EventOdd.MatchId,Live.EventOdd.ParameterOddId,Live.EventOdd.OutCome
		,case when  Live.EventOdd.SpecialBetValue is null then '' else Live.EventOdd.SpecialBetValue end ,Live.EventOdd.IsEvaluated,Live.EventOdd.OddResult
		,Live.EventOdd.IsCanceled,Live.EventOdd.OddValue,Live.EventOdd.OddId,Live.EventOdd.IsActive,Live.EventOdd.OddsTypeId,Live.EventOdd.OddFactor
		from Live.[EventOdd] with (nolock) --INNER JOIN @TempSlip as TMP On Live.[EventOdd].BetradarMatchId=TMP.BetradarMatchId   
		 where Live.EventOdd.BetradarMatchId in (Select BetradarMatchId from @TempSlip)

			insert @TLiveEventProb
		SELECT OddId,[OddsTypeId],[OutCome],case when  SpecialBetValue is null then '' else SpecialBetValue end,[ProbilityValue],[MatchId],[BettradarOddId],[ParameterOddId],[MarketStatus],[CashoutStatus],[BetradarTimeStamp],[UpdatedDate]
		,[BettingLive].Live.[EventOddProb].[BetradarMatchId],[EvaluatedDate],[BetradarOddsTypeId],[BetradarOddsSubTypeId],[OutcomeActive]
		from [BettingLive].Live.[EventOddProb] with (nolock) --INNER JOIN @TempSlip as TMP On Live.EventOddProb.BetradarMatchId=TMP.BetradarMatchId 
		  where [BettingLive].Live.[EventOddProb].BetradarMatchId in (Select BetradarMatchId from @TempSlip) and CashoutStatus=1



		insert into @TLiveEventOddResult
		select [BettingLive].Live.[EventOddResult].BetradarMatchId,[BettingLive].Live.[EventOddResult].OutCome,case when  [BettingLive].Live.[EventOddResult].SpecialBetValue is null then '' else [BettingLive].Live.[EventOddResult].SpecialBetValue end
		,[BettingLive].Live.[EventOddResult].IsEvaluated,[BettingLive].Live.[EventOddResult].OddResult,[BettingLive].Live.[EventOddResult].IsCanceled,[BettingLive].Live.[EventOddResult].OddId
		from [BettingLive].Live.[EventOddResult] with (nolock) -- INNER JOIN @TempSlip as TMP On Live.[EventOddResult].BetradarMatchId=TMP.BetradarMatchId 
		 where [BettingLive].Live.[EventOddResult].BetradarMatchId in (Select BetradarMatchId from @TempSlip)
			
												declare @SlipFark int

set nocount on
					declare cur111 cursor local for(
					select SlipOddId,OddValue,Customer.Slip.Amount,BetTypeId,OutCome,MatchId,ParameterOddId,case when  SpecialBetValue is null then '' else  SpecialBetValue end 
					,EventDate,SportId,customer.SlipOdd.StateId,EventName,OddsTypeId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.MatchId,Customer.SlipOdd.Banko,Customer.SlipOdd.Score,OddProbValue
					from Customer.SlipOdd with (nolock) INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.SlipOdd.SlipId
					where Customer.SlipOdd.SlipId=@SlipId and Customer.Slip.SlipStateId=1
					
						)

					open cur111
					fetch next from cur111 into @SlipOddId,@OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore,@CurrentProb
					while @@fetch_status=0
						begin
							begin
							set @OddProfitfactor=0
						set @IsWon=0
							set @TimeStatu=null
							set @MatchTime=''
							set @CustomerOddValue=@OddValue
							set @CustomerOutCome=@Outcome
							set @Score=''
							set @BetStopReasonId=0
							set @BetStopReason=''
							set @LegScore=''
							  set @probodd=0
							 --set @OddKey=0
							set @LiveEventId=null
							set @IsLive=@BetType
							set @IsActive=0
							set @CustomerSpecialBetValue=@SpecialBetValue
							set @Reason='Cashout aktiv'
							set @ActiveAwayFark=0
							set @ActiveHomeFark=0
							--if(@OddTypeId=1481)
							--set @SpecialBetValue='-1'

if(@StateId=1)
begin
	
	if(@BetType=0) -- Pre Event Oynanmış
		begin
		select @OddType=ShortOddType from Language.[Parameter.OddsType] with (nolock) where OddsTypeId=@OddTypeId and LanguageId=@LangId
		if(@EventDate>=GETDATE() and (Select Count(*) from @TLiveEvenDetail where BetradarMatchId=@BetradarMatchId and TimeStatu<>1)=0) -- Daha Event Başlamamış
			begin
				
			 
			-- set @EventName=@EventName +'( '+ CAST(@EventDate as nvarchar(30))+' )'
				set @Remaningtime=DATEDIFF(MINUTE,GETDATE(),@EventDate)
				set @IsLive=0
				set @IsActive=1
				set @MatchTime=@EventDate
				 set @Reason='Cashout aktiv'
				  set @probodd=@CurrentProb 


					if exists (select Match.Match.BetradarMatchId from Match.Match with (nolock) INNER JOIN Parameter.Tournament with (nolock) On Match.TournamentId=Parameter.Tournament.TournamentId and CategoryId=654 and BetradarMatchId=@BetradarMatchId)
						begin
													set @IsActive=0
													set @Reason='Keine Cashout für E-Sports'
													end
			end				
		else --Pre Match Başlamış
			begin
			 
				
				  if not exists(select SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and SportId=6 and StateId=1)
				if exists (select BetradarMatchId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId  )  --Event Live da varmı diye bakılıyor
					if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId where BetradarMatchId=@BetradarMatchId and CategoryId=654 )
					begin
		 
						--select @LiveEventId=EventId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId   --Live Event Id alınıyor
			
						if exists (select OddsId from Parameter.Odds with (nolock) where OddsId=@ParameterOddId and LiveOddId is not null) --Pre oynanan marketin liveda karşılığı varmı diye bakılıyor
							begin
						
								select @ParameterOddId=LiveOddId,@Outcome=LiveOutcome 
								from Parameter.Odds with (nolock) where OddsId=@ParameterOddId

									if(@ParameterOddId in (26,27,28))
									set @SpecialBetValue='1'
 
							 
						 

								select  @OddTypeId=Live.[Parameter.Odds].OddTypeId 
								from Live.[Parameter.OddType] with (nolock) INNER JOIN 
								Live.[Parameter.Odds] with (nolock) ON Live.[Parameter.OddType].OddTypeId=Live.[Parameter.Odds].OddTypeId 
								where Live.[Parameter.Odds].OddsId=@ParameterOddId

							if exists (select LiveEventOdd.OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
								ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
								and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
								INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
								INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
								   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and  LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 
								)
									begin --Live da odd hala aktif mi diye bakılıyor
										select @probodd=ProbilityValue
										from @TLiveEventProb as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId   and (SpecialBetValue=@SpecialBetValue ) 
										 and LiveEventOdd.[CashoutStatus]=1 

									 
							 
											 
											 	select @OddValue=ISNULL(OddValue,1.01 )
										from @TLiveEventOdd as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
										and LiveEventOdd.OddValue>1




											set @IsLive=1
											set @IsActive=1

											if(@OddValue>9.90 or  CAST( @probodd as decimal(18,2))<=0.04)
											begin
												set @IsActive=0
												set @Reason='Cashout nicht moglich'
											end
									end
						   else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.MatchId=LiveEventDetail.EventId where LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 ) or (@StateId=3) 
									begin --Live da odd sonuçlanmış mı 
										select @OddValue=case when LiveEventOddResult.OddResult=1 then 1 else 0 end from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
											
										 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Cashout nicht moglich'

											if(@OddValue=1 or (@StateId=3) )
												begin
												 set @probodd=1
													set @IsWon=1
													set @IsActive=1
													set @Reason='Gewonnen'
												end
 

											  
									end
						   else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1  and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
										
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
											 
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatuu=TimeStatu
												 from  @TLiveEvenDetail as LiveEventDetail  
												 WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
																if @ActiveHomeScore>@ActiveAwayScore
																	set @ActiveFark=@ActiveHomeScore-@ActiveAwayScore
																else if @ActiveAwayScore>@ActiveHomeScore
																		set @ActiveFark=@ActiveAwayScore-@ActiveHomeScore
																else
																	set @ActiveFark=0
															end
												if(@HomeScore<>@AwayScore)
													begin
												if (@HomeScore>@AwayScore)
													begin
													set @Fark=@HomeScore-@AwayScore
													set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
														if(@OddTypeId=3)
															set @OddTypeId=709

													end
												else if (@AwayScore>@HomeScore)
													begin
														set @Fark=@AwayScore-@HomeScore
														set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
															if(@OddTypeId=3)
															set @OddTypeId=709
													end

														if(@Fark=@ActiveFark and (@ActiveHomeScore=0 or @ActiveAwayScore=0))
														begin
														set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
													
														end
												if(@OddTypeId=709)
												begin
												if @ParameterOddId=6
													set @ParameterOddId=3403
												else if @ParameterOddId=7
													set @ParameterOddId=3404
												else if @ParameterOddId=8
													set @ParameterOddId=3405
													end
												if (@OddTypeId=18 and @activetimestatuu<3)
													begin
														set @OddTypeId=95
													 if @ParameterOddId=50 
														set @ParameterOddId=276
													else if @ParameterOddId=51
														set @ParameterOddId=277
													else if @ParameterOddId=52
														set @ParameterOddId=278
												end
													--select @EventName,@SpecialBetValue,@Outcome,@OddTypeId
													if exists (select OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
														 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
														 and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.[CashoutStatus]=1 -- and LiveEventOdd.OddValue>1
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @probodd=[ProbilityValue],@TimeStatu=TimeStatu
																from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and CashoutStatus=1 --and LiveEventOdd.OddValue>1
								
															 	select @OddValue=ISNULL(OddValue,1.01 )
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1
												 
																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	end
													end
															else
															begin
																if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																		SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
																		 from  @TLiveEvenDetail as LiveEventDetail  
																		WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
																		if(@MatchScore<>'' and @MatchScore is not null)
																		begin
																			select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
																			if(@ActiveHomeScore>@HomeScore)
																				set @ActiveHomeFark=@ActiveHomeScore-@HomeScore
																			else if (@HomeScore>@ActiveHomeScore)
																				set @ActiveHomeFark=@HomeScore-@ActiveHomeScore

																			if(@ActiveAwayScore>@AwayScore)
																				set @ActiveAwayFark=@ActiveAwayScore-@AwayScore
																			else if (@HomeScore>@ActiveHomeScore)
																				set @ActiveAwayFark=@AwayScore-@ActiveAwayScore


																			if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																					begin
																					set @OddValue=1.05
																					set @IsActive=1
																							set @probodd=((1/@OddValue))
																 
																					end
																			else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																					begin
																					set @OddValue=1.05
																					set @IsActive=1
																							set @probodd=((1/@OddValue))
																 
																					end
																			else if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																					begin
																					set @OddValue=1.01
																					set @IsActive=1
																							set @probodd=((1/@OddValue))
																 
																					end
																			else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																					begin
																					set @OddValue=1.01
																					set @IsActive=1
																							set @probodd=((1/@OddValue))
																 
																					end
																			else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																					begin
																					set @OddValue=1.05
																					set @IsActive=1
																							set @probodd=((1/@OddValue))
																 
																					end
																			else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																					begin
																					set @OddValue=1.05
																					set @IsActive=1
																							set @probodd=((1/@OddValue))
																 
																					end
																			else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																					begin
																					set @OddValue=1.01
																					set @IsActive=1
																							set @probodd=((1/@OddValue))
																 
																					end
																			else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																					begin
																					set @OddValue=1.01
																					set @IsActive=1
																							set @probodd=((1/@OddValue))
																 
																					end
																			else
																				begin
																				set @IsLive=1
																				set @IsActive=0
																				set @probodd=0
																				set @Reason='Cashout nicht moglich'
																				end
																		end
																		else
																			begin
																			set @IsLive=1
																			set @IsActive=0
																			set @probodd=0
																			set @Reason='Cashout nicht moglich'
																			end
															end
																else
																	begin

																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	end
															end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
													begin
													if (@OddTypeId=3)
														set @OddTypeId=708
												 
												 if(@OddTypeId=18)
													set @OddTypeId=20

													if @ParameterOddId=6
														set @ParameterOddId=3400
													else if @ParameterOddId=7
														set @ParameterOddId=3401
													else if @ParameterOddId=8
														set @ParameterOddId=3402

												 else if @ParameterOddId=50
														begin
														set @OddTypeId=20
														set @ParameterOddId=55
														end
													else if @ParameterOddId=51
													begin
														set @OddTypeId=20
														set @ParameterOddId=56
														end
													else if @ParameterOddId=52
													begin
														set @OddTypeId=20
														set @ParameterOddId=57
														end


													set @SpecialBetValue=''

													if exists (select LiveEventOdd.OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
														ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
														and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
														INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
														INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
														   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and  LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 
														)
														begin
														select @probodd=[ProbilityValue],@TimeStatu=TimeStatu
																from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and CashoutStatus=1 
												 

												 	select @OddValue=ISNULL(OddValue,1.01 )
														from @TLiveEventOdd as LiveEventOdd
														where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome --and (SpecialBetValue=@SpecialBetValue ) 
														and LiveEventOdd.OddValue>1
										 
													if (@probodd is not null and @probodd>0 )
													begin
													 
														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	end
													end
													else
														begin
															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Cashout nicht moglich'
														end
													end
													else
														begin
														if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
														
																if( @ParameterOddId=55 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																			begin
																				set @OddValue=1.01
																				set @IsActive=1
																				set @probodd=((1/@OddValue))
																			end
																else if( @ParameterOddId=57 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																			begin
																				set @OddValue=1.01
																				set @IsActive=1
																				set @probodd=((1/@OddValue))
																			end
																else if( @ParameterOddId=3400 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																			begin
																				set @OddValue=1.01
																				set @IsActive=1
																				set @probodd=((1/@OddValue))
																			end
																else if( @ParameterOddId=3402 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																			begin
																				set @OddValue=1.01
																				set @IsActive=1
																				set @probodd=((1/@OddValue))
																			end
															end
														else
															begin
																set @IsLive=1
																set @IsActive=0
														        set @probodd=0
																set @OddValue=0
																set @Reason='Cashout nicht moglich'
															end
										 
													end
													end
										 end
								else -- Odd aktif değil
									begin
										set @IsLive=1
										set @IsActive=0
										 set @probodd=0
										set @Reason='Cashout nicht moglich'
									end
							end
						else
							begin -- Marketin Live da karşılığı yok
								set @IsLive=0
								set @IsActive=0
								 set @probodd=0
								 set @Reason='Diese Wettart ist nicht mehr verfügbar'
							end
					end
					else --Event Liveda yok
					begin
						set @IsLive=0
						set @IsActive=0
						 set @probodd=0
						 set @Reason='Dieses Spiel ist nicht als Livewette verfügbar'
					end
				else --Event Liveda yok
					begin
						set @IsLive=0
						set @IsActive=0
						 set @probodd=0
						set @Reason='Dieses Spiel ist nicht als Livewette verfügbar'
					end
			
			end	
	end
	else
		begin

			select @Outcome=Live.[Parameter.Odds].Outcomes from Live.[Parameter.Odds] with (nolock) where OddsId=@ParameterOddId
			select @OddType=Language.[Parameter.LiveOddType].ShortOddType from Language.[Parameter.LiveOddType] with (nolock)   
			where Language.[Parameter.LiveOddType].LanguageId=@LangId and  Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId
			
			if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId INNER JOIN Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId where BetradarMatchId=@BetradarMatchId and (Parameter.Category.CategoryId=654 or Parameter.Category.SportId=6 ))
			begin
					if (@BetradarMatchId>0)
						begin
								if exists (select LiveEventOdd.OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
								ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
								and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
								INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
								INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
								   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and  LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 
								)
									begin --Live da odd hala aktif mi diye bakılıyor
								
										select distinct @probodd= [ProbilityValue] from @TLiveEventProb as LiveEventOdd 
										where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1 and LiveEventOdd.ParameterOddId=@ParameterOddId
										and (LiveEventOdd.SpecialBetValue=@SpecialBetValue) 

										select @OddValue=ISNULL(OddValue,1.01 )
										from @TLiveEventOdd as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
										and LiveEventOdd.OddValue>1 and LiveEventOdd.IsActive=1

											set @IsLive=1
											set @IsActive=1

												if(@OddValue>9.9 or   CAST( @probodd as decimal(18,2))<=0.04)
													begin
													set @IsActive=0
													set @Reason='Cashout nur moglich bis Quote 9,90'
													end

									end
								
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId 
								where LiveEventDetail.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   
								and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1   and  (LiveEventOdd.OddValue is not null) and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  
								and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 )  or (@StateId=3)  
								begin --Live Odd sonuçlanmış mı
									select @OddValue= case when LiveEventOddResult.OddResult=1 then 1 else 0 end
										from @TLiveEventOdd as LiveEventOdd  INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
 
									 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Cashout nicht moglich'

												if(@OddValue=1 or @StateId=3)
												begin
													set @probodd=1
													set @IsWon=1
													set @IsActive=1
													set @Reason=''
												end
																					
								end
									else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
									
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
											
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatuu=TimeStatu
												 from  @TLiveEvenDetail as LiveEventDetail  
												 WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
																if @ActiveHomeScore>@ActiveAwayScore
																	set @ActiveFark=@ActiveHomeScore-@ActiveAwayScore
																else if @ActiveAwayScore>@ActiveHomeScore
																		set @ActiveFark=@ActiveAwayScore-@ActiveHomeScore
																else
																	set @ActiveFark=0
															end
												if(@HomeScore<>@AwayScore)
													begin
												if (@HomeScore>@AwayScore)
													begin
													set @Fark=@HomeScore-@AwayScore
													set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
														if(@OddTypeId=3)
															set @OddTypeId=709

													end
												else if (@AwayScore>@HomeScore)
													begin
														set @Fark=@AwayScore-@HomeScore
														set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
															if(@OddTypeId=3)
															set @OddTypeId=709
													end

													if(@Fark=@ActiveFark and (@ActiveHomeScore=0 or @ActiveAwayScore=0))
														begin
														set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
													
														end
												if(@OddTypeId=709)
												begin
												if @ParameterOddId=6
													set @ParameterOddId=3403
												else if @ParameterOddId=7
													set @ParameterOddId=3404
												else if @ParameterOddId=8
													set @ParameterOddId=3405
													end
												if (@OddTypeId=18 and @activetimestatuu<3)
													begin
														set @OddTypeId=95
													 if @ParameterOddId=50 
														set @ParameterOddId=276
													else if @ParameterOddId=51
														set @ParameterOddId=277
													else if @ParameterOddId=52
														set @ParameterOddId=278
												end
													 --select @EventName,@SpecialBetValue,@Outcome,@OddTypeId
													if exists (select OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
														 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
														 and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.[CashoutStatus]=1 -- and LiveEventOdd.OddValue>1
									
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @probodd=[ProbilityValue],@TimeStatu=TimeStatu
																from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and CashoutStatus=1 --and LiveEventOdd.OddValue>1
								
															 	select @OddValue=ISNULL(OddValue,1.01 )
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1
												 
																set @IsLive=1
																set @IsActive=1
																--select @OddValue,@probodd
															if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	end
													end
															else
															begin
																if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
																 from  @TLiveEvenDetail as LiveEventDetail  
																WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
																if(@ActiveHomeScore>@HomeScore)
																	set @ActiveHomeFark=@ActiveHomeScore-@HomeScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveHomeFark=@HomeScore-@ActiveHomeScore

																if(@ActiveAwayScore>@AwayScore)
																	set @ActiveAwayFark=@ActiveAwayScore-@AwayScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveAwayFark=@AwayScore-@ActiveAwayScore


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	end
																end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Cashout nicht moglich'
															end
														end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
													begin
													if (@OddTypeId=3)
														set @OddTypeId=708
												 
														 if(@OddTypeId=18)
															set @OddTypeId=20

															if @ParameterOddId=6
																set @ParameterOddId=3400
															else if @ParameterOddId=7
																set @ParameterOddId=3401
															else if @ParameterOddId=8
																set @ParameterOddId=3402

														 else if @ParameterOddId=50
																begin
																set @OddTypeId=20
																set @ParameterOddId=55
																end
															else if @ParameterOddId=51
															begin
																set @OddTypeId=20
																set @ParameterOddId=56
																end
															else if @ParameterOddId=52
															begin
																set @OddTypeId=20
																set @ParameterOddId=57
																end


													set @SpecialBetValue=''
												 if exists(select LiveEventOdd.OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
														ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
														and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
														INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
														INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
														   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and  LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 )
														begin
														select @probodd=[ProbilityValue],@TimeStatu=TimeStatu
																from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and CashoutStatus=1 
										 

												 					select @OddValue=ISNULL(OddValue,1.01 )
																	from @TLiveEventOdd as LiveEventOdd
																	where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome --and (SpecialBetValue=@SpecialBetValue ) 
																	and LiveEventOdd.OddValue>1
										  
													if (@probodd is not null and @probodd>0 )
													begin
													 
														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	end
													end
													else
														begin
															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Cashout nicht moglich'
														end
												end
												else
														begin
															if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
															select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
														
														if( @ParameterOddId=55 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
															 
																		end
																else if( @ParameterOddId=57 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3400 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3402 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
														else
															begin
															set @IsLive=1
															set @IsActive=0
															 set @probodd=0
															  set @OddValue=0
															set @Reason='Cashout nicht moglich'
															end
															end
															else
																	begin
																		set @IsLive=1
															set @IsActive=0
															 set @probodd=0
															  set @OddValue=0
															set @Reason='Cashout nicht moglich'
																	end
													end
											 end
										 end
								else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										 set @probodd=0
										  set @OddValue=0
										set @Reason='Cashout nicht moglich'

										
								    end
						end
						else
							begin
								if exists (select LiveEventOdd.OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
								ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
								and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
								INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
								INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.IsActive=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
								   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and  LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 
								)
									begin --Live da odd hala aktif mi diye bakılıyor
								
										--select distinct @probodd= [ProbilityValue] from @TLiveEventProb as LiveEventOdd 
										--where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1 and LiveEventOdd.ParameterOddId=@ParameterOddId
										--and (LiveEventOdd.SpecialBetValue=@SpecialBetValue) 

										select @OddValue=ISNULL(OddValue,1.01 ),@probodd=OddProb
										from @TLiveEventOdd as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
										and LiveEventOdd.OddValue>1 and LiveEventOdd.IsActive=1

											set @IsLive=1
											set @IsActive=1

												if(@OddValue>9.9 or   CAST( @probodd as decimal(18,2))<=0.04)
													begin
													set @IsActive=0
													set @Reason='Cashout nur moglich bis Quote 9,90'
													end

									end
								
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId 
								where LiveEventDetail.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   
								and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1   and  (LiveEventOdd.OddValue is not null) and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  
								and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 )  or (@StateId=3)  
								begin --Live Odd sonuçlanmış mı
									select @OddValue= case when LiveEventOddResult.OddResult=1 then 1 else 0 end
										from @TLiveEventOdd as LiveEventOdd  INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
 
									 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Cashout nicht moglich'

												if(@OddValue=1 or @StateId=3)
												begin
													set @probodd=1
													set @IsWon=1
													set @IsActive=1
													set @Reason=''
												end
																					
								end
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
									
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
											
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatuu=TimeStatu
												 from  @TLiveEvenDetail as LiveEventDetail  
												 WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
																if @ActiveHomeScore>@ActiveAwayScore
																	set @ActiveFark=@ActiveHomeScore-@ActiveAwayScore
																else if @ActiveAwayScore>@ActiveHomeScore
																		set @ActiveFark=@ActiveAwayScore-@ActiveHomeScore
																else
																	set @ActiveFark=0
															end
												if(@HomeScore<>@AwayScore)
													begin
												if (@HomeScore>@AwayScore)
													begin
													set @Fark=@HomeScore-@AwayScore
													set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
														if(@OddTypeId=3)
															set @OddTypeId=709

													end
												else if (@AwayScore>@HomeScore)
													begin
														set @Fark=@AwayScore-@HomeScore
														set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
															if(@OddTypeId=3)
															set @OddTypeId=709
													end

													if(@Fark=@ActiveFark and (@ActiveHomeScore=0 or @ActiveAwayScore=0))
														begin
														set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
													
														end
												if(@OddTypeId=709)
												begin
												if @ParameterOddId=6
													set @ParameterOddId=3403
												else if @ParameterOddId=7
													set @ParameterOddId=3404
												else if @ParameterOddId=8
													set @ParameterOddId=3405
													end
												if (@OddTypeId=18 and @activetimestatuu<3)
													begin
														set @OddTypeId=95
													 if @ParameterOddId=50 
														set @ParameterOddId=276
													else if @ParameterOddId=51
														set @ParameterOddId=277
													else if @ParameterOddId=52
														set @ParameterOddId=278
												end
													 --select @EventName,@SpecialBetValue,@Outcome,@OddTypeId
													if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
														 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
														 and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=1   and LiveEventOdd.OddValue>1 -- and LiveEventOdd.OddValue>1
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin
															 
															 	select @OddValue=ISNULL(OddValue,1.01 ),@probodd=OddProb
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1 and LiveEventOdd.IsActive=1
												 
																set @IsLive=1
																set @IsActive=1
																--select @OddValue,@probodd
															if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	end
													end
															else
															begin
																if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
																 from  @TLiveEvenDetail as LiveEventDetail  
																WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
																if(@ActiveHomeScore>@HomeScore)
																	set @ActiveHomeFark=@ActiveHomeScore-@HomeScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveHomeFark=@HomeScore-@ActiveHomeScore

																if(@ActiveAwayScore>@AwayScore)
																	set @ActiveAwayFark=@ActiveAwayScore-@AwayScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveAwayFark=@AwayScore-@ActiveAwayScore


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	end
																	end
																		else
																	begin
																		set @IsLive=1
															set @IsActive=0
															 set @probodd=0
															  set @OddValue=0
															set @Reason='Cashout nicht moglich'
																	end
															end
															else
																begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																end
														end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
													begin
													if (@OddTypeId=3)
														set @OddTypeId=708
												 
														 if(@OddTypeId=18)
															set @OddTypeId=20

															if @ParameterOddId=6
																set @ParameterOddId=3400
															else if @ParameterOddId=7
																set @ParameterOddId=3401
															else if @ParameterOddId=8
																set @ParameterOddId=3402

														 else if @ParameterOddId=50
																begin
																set @OddTypeId=20
																set @ParameterOddId=55
																end
															else if @ParameterOddId=51
															begin
																set @OddTypeId=20
																set @ParameterOddId=56
																end
															else if @ParameterOddId=52
															begin
																set @OddTypeId=20
																set @ParameterOddId=57
																end


													set @SpecialBetValue=''
												 if exists(select LiveEventOdd.OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
														ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
														and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
														INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
														INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.IsActive=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
														   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and  LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 )
														begin
												 					select @OddValue=ISNULL(OddValue,1.01 ),@probodd=OddProb
																	from @TLiveEventOdd as LiveEventOdd
																	where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome --and (SpecialBetValue=@SpecialBetValue ) 
																	and LiveEventOdd.OddValue>1
										  
													if (@probodd is not null and @probodd>0 )
													begin
													 
														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	end
													end
													else
														begin
															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Cashout nicht moglich'
														end
												end
												else
														begin
															if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
															select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
														
														if( @ParameterOddId=55 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
															 
																		end
																else if( @ParameterOddId=57 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3400 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3402 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
														else
															begin
															set @IsLive=1
															set @IsActive=0
															 set @probodd=0
															  set @OddValue=0
															set @Reason='Cashout nicht moglich'
															end
															end
																else
																	begin
																		set @IsLive=1
																		set @IsActive=0
																	    set @probodd=0
																		set @OddValue=0
																		set @Reason='Cashout nicht moglich'
																	end
													end
											 end
										 end
								else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										 set @probodd=0
										  set @OddValue=0
										set @Reason='Cashout nicht moglich'

										
								    end
							end
					end
			else
				begin
				set @IsActive=0
			    set @Reason='Cashout nicht moglich'
				 set @OddValue=0
				end

	end
end
else
begin
	if(@BetType=0)
		begin
			select @OddType=OddsType from Language.[Parameter.OddsType] with (nolock) where OddsTypeId=@OddTypeId and LanguageId=@LangId
		end
	else
		begin
			select @OddType=OddsType from Language.[Parameter.LiveOddType] with (nolock) where OddTypeId=@OddTypeId and LanguageId=@LangId
		end

	if(@StateId in (2,3,5))
		begin
		if @StateId=3
			begin
			set @OddValue=1
			set @IsWon=1
			set @Reason='Gewonnen'
			if @BetType=1
				select @OddType=Language.[Parameter.LiveOddType].ShortOddType 
				from Language.[Parameter.LiveOddType] with (nolock)   where Language.[Parameter.LiveOddType].LanguageId=@LangId and  Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId
			end
		else
			begin
			set @OddValue=0
			set @IsWon=0
			end
			set @IsActive=1
			set @IsLive=@BetType
			set @probodd=1
		end
	else
		begin
			set @IsActive=0
			set @IsLive=0
			set @probodd=0
			 set @OddValue=0
			set @Reason='Verloren'
		end
end

			if(@Score='' or @Score is null)
				begin
						SELECT  top 1 @Score= case when  LiveEventDetail.MatchTime is not null then  cast(  LiveEventDetail.MatchTime as nvarchar(50)) + ''' -' + RTRIM( LiveEventDetail.Score) else case when Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId>1 then cast(Language.[Parameter.LiveTimeStatu].TimeStatu as nvarchar(10))+ ' - ' + RTRIM( LiveEventDetail.Score) else '-' end end 
						,@LegScore=LegScore,@ActiveSportTime=MatchTime,@TimeStatu=LiveEventDetail.TimeStatu
						 from  @TLiveEvenDetail as LiveEventDetail  LEFT OUTER JOIN
                         Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId =  LiveEventDetail.TimeStatu
						WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId) AND (Language.[Parameter.LiveTimeStatu].LanguageId = 6)
					end
			if @Score is null or @Score=''
						set @Score='-'
					 
				if(@Remaningtime<@Remaningtime2)
					set @Remaningtime2=@Remaningtime

						select @OddProfitfactor=FactorValue from Parameter.CashoutProfitFactor with (nolock)  where ProfitValue1<@OddValue and ProfitValue2>=@OddValue

						--select  @Remaningtime2=ISNULL(RedCard1,0),@LegScore=ISNULL(RedCard2,0) from @TLiveEvenDetail as t1   where EventId=@EventId 

					 		select  @Remaningtime2=ISNULL(COUNT(*),0) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=1

						select  @LegScore=cast(ISNULL(COUNT(*),0) as nvarchar(20)) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=2

						Select @BetStopReasonId = ISNULL(T.ReasonId,0),@BetStopReason=ISNULL(Language.[Parameter.LiveBetStopReason].Reason,'') from @TLiveEvenDetail as T Inner JOIN Language.[Parameter.LiveBetStopReason] ON ISNULL(Language.[Parameter.LiveBetStopReason].ParameterReasonId,0)=T.ReasonId and LanguageId=@LangId
						and T.BetradarMatchId=@BetradarMatchId


					insert @TempTable
					select @SlipOddId,@OddValue,@Remaningtime2,@IsActive,@IsLive,@Amount,@Score,@LegScore,@EventName,@CustomerOddValue,@CustomerOutCome,case when @CustomerSpecialBetValue<>'-1' then @CustomerSpecialBetValue else '' end,@OddType,@EventDate,case when @OddValue=1 then  STR(@CustomerOddValue, 25, 2)   else STR(@OddValue, 25, 2) end,@IsWon,0,@OddProfitfactor,@BetradarMatchId,@EventId,@Banko,@CurrentProb,case when @Reason='' then 'Cashout Aktiv' else @Reason end,@probodd,ISNULL(@BetStopReason,''),ISNULL(@BetStopReasonId,0)

		end
							fetch next from cur111 into @SlipOddId, @OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore,@CurrentProb
			
						end
					close cur111
					deallocate cur111	

					 

					if not exists (select OddId from @TempTable where IsActive=0) and (select COUNT(*) from @TempTable)>0 and ((Select Count(*) from @TempTable where IsLive=1)>0 or (Select Count(*) from @TempTable where IsWon=1)>0)
					begin

					set @TotalOddValue =0
					set @ProfitFactor =1
					set @ReelValue =@Amount
					set @LayRate =0
					 set @TotalProb =0
					set @CurrentOddValue =0

					 
										 
									select @ReelValue=EXP(SUM(LOG(CustomerOddValue)))*MAX(Amount),@TotalProbCurrenTime=EXP(SUM(LOG(CurrentProb)))*100
									,@TotalProbTickettime=EXP(SUM(LOG(OddProb)))*100,@Amount=MAX(Amount) from @TempTable  
												if(Select Count(*) from @TempTable where IsWon=0 and IsActive=1)=1
										 	select  @TotalProbCurrenTime=EXP(SUM(LOG(CurrentProb)))*100
									,@TotalProbTickettime=EXP(SUM(LOG(OddProb)))*100,@Amount=MAX(Amount) from @TempTable  where IsWon=0
								 set @ValueTicketTime=(@TotalProbTickettime*@ReelValue)/100
								 set @TicketValueFactor=@TotalProbCurrenTime/@TotalProbTickettime

								 

								 select top 1 @LowerTicketValueLadder =TicketValueFactor ,@LowerReductionFactor=DeductionFactor/100
								 from @TCashoutKey3 where  TicketValueFactor<@TicketValueFactor order by TicketValueFactor desc

								 select top 1 @UpperTicketValueLadder =TicketValueFactor ,@UpperReductionFactor=DeductionFactor/100
								 from @TCashoutKey3 where TicketValueFactor>@TicketValueFactor order by TicketValueFactor asc

								 set @Interpolation=(@TicketValueFactor-@LowerTicketValueLadder)/(@UpperTicketValueLadder-@LowerTicketValueLadder)

								 set @Interpolation=1-@Interpolation
							 
								 set @ReductionFactor=@TicketValueFactor/(@Interpolation*@LowerTicketValueLadder/@LowerReductionFactor+(1-@Interpolation)*@UpperTicketValueLadder/@UpperReductionFactor)

								 set @CashoutNoMargin=(@ReelValue*@TotalProbCurrenTime)/100

								 set @CashoutLadder=@CashoutNoMargin/@ReductionFactor
								
								 set @ExpectedProfit=@Amount-(@ReelValue*(@TotalProbTickettime/100))
						 

								 if (@TotalProbCurrenTime<=@TotalProbTickettime)
									begin
										set @DeltaProb=(((@TotalProbCurrenTime/100)-0)/((@TotalProbTickettime/100)-0))*100
										 
									end
								else
										set @DeltaProb=(((@TotalProbCurrenTime/100)-1)/((@TotalProbTickettime/100)-1))*100

								
								set @CashoutValueTicketTime=(@ReelValue*(@TotalProbTickettime/100))/(110/100)+(@ExpectedProfit*(@ProportionTicketTime/100))

							--	select (@CashoutLadder+(@ExpectedProfit*(@ProportionTicketTime/100)*(@DeltaProb/100))),@CashoutValueTicketTime

				

								 if (@TotalProbCurrenTime>@TotalProbTickettime)
									begin
										if((@CashoutLadder+(@ExpectedProfit*(@ProportionTicketTime/100)*(@DeltaProb/100)))>@CashoutValueTicketTime)
											begin
										--	select 1
											set @CashOut=(@CashoutLadder+(@ExpectedProfit*(@ProportionTicketTime/100)*(@DeltaProb/100)))
									 
											end
										else
											begin
										--	select 11
											set @CashOut=(@CashoutValueTicketTime)
											end
										--	select 1, @CashoutLadder,@ExpectedProfit,@ProportionTicketTime,@DeltaProb,@CashoutValueTicketTime
									end
								else
									begin
									set @CashOut=@CashoutLadder+(@ExpectedProfit*(@ProportionTicketTime/100)*(@DeltaProb/100))
									end

				--select @CashOut as CashOut,@ReelValue as WinAmount,@TotalProbTickettime as ProbTicketTime,@TotalProbCurrenTime as ProbCurrentTime,@ValueTicketTime as ValueTicket
				--,@CashoutNoMargin as CashoutMargin,@TicketValueFactor as TicketValueFactor,@ReductionFactor as ReductionFactor,
				--@CashoutLadder as CashoutLadder,@ExpectedProfit as ExpectedProfit,@DeltaProb as DeltaProb,@LowerTicketValueLadder as LowerTicketValueLadder,@LowerReductionFactor as LowerReductionFactor
				--,@UpperTicketValueLadder as UpperTicketValueLadder,@UpperReductionFactor as UpperReductionFactor,@Interpolation as Interpolation
						if(Select Count(*) from @TempTable where IsWon=0 and IsActive=1)=1
								set @CashOut=@CashoutLadder

					--select @CurrentOddValue as CurrentOddValue,@TotalOddValue as TotalOdd,@ProfitFactor As ProfitFactor,@Amount as Amount,@ReelValue as RealValue,@LayRate as LayRate,@CashOut as CashOutOffer
						if(@CashOut>@ReelValue)
							set @CashOut=(@CurrentOddValue*@Amount) 
					end
					else if not exists (select OddId from @TempTable where IsActive=0)   and (select COUNT(*) from @TempTable)>0 and (select COUNT(*) from @TempTable where EvenDate<GETDATE())=0
					begin
						set @CashOut=@Amount
					end
					else
						set @CashOut=0

							if(@CashOut is null)
							set @CashOut=0
						
						if not exists(select OddId from @TempTable where IsWon=0)
								set @CashOut=@ReelValue

						if exists (select OddId from @TempTable where IsLive=1)
								begin
									if exists(select OddId from @TempTable where IsLive=0 and OddValue>9.90)
										begin
											update @TempTable set IsActive=0,Reason='Cashout nur moglich bis Quote 9,90' where IsLive=0 and OddValue>9.90
												set @CashOut=0
										end
								end

						--if(@CashOut<2.00)
						--begin
						--set @CashOut=0

						--end

						update @TempTable set CashOutValue=@CashOut

				select DISTINCT cast(0 as bigint) as OddId ,OddValue ,RemaningTime ,IsActive ,IsLive ,Amount ,Score ,LegScore ,EventName ,CustomerOddValue ,OutCome ,SpecialBetValue,OddType ,EvenDate ,MatchTime ,IsWon ,CashOutValue ,ProfitFactor,BetradarMatchId,EventId ,Banko,case when Reason='' then 'Cashout Aktiv' else Reason  end  as Reason,BetStopReason,BetStopReasonId
					from @TempTable Order by EvenDate,BetradarMatchId
end
 else if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=4 and SlipStateId=1  and  (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0		 and (Select Count(Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and SlipStateId=1 )<26   )
	begin

	declare @TCashoutKeySystem table (TicketValueFactor float,DeductionFactor float)

	insert @TCashoutKeySystem
select TicketValueFactor,DeductionFactor from Parameter.CashoutKeySystem with (nolock)



insert @TCashoutKey2
select * from Parameter.CashoutKey2

declare @Systems nvarchar(300)
	declare @SystemGain money					
		insert into @TempSlip
		SELECT DISTINCT Customer.SlipOdd.BetradarMatchId
							FROM	Customer.SlipOdd with (nolock) 
							WHERE  (Customer.SlipOdd.SlipId=@SlipId) and (Customer.SlipOdd.BetTypeId in (0,1))

				insert into @TLiveEvent
			select [BettingLive].Live.[Event].BetradarMatchId,[BettingLive].Live.[Event].EventId,[BettingLive].Live.[Event].ConnectionStatu,TournamentId 
			from [BettingLive].Live.[Event] with (nolock) 
			where [BettingLive].Live.[Event].BetradarMatchId in (Select DISTINCT BetradarMatchId from @TempSlip)

		insert into @TLiveEvenDetail
			select Live.EventDetail.EventId,Live.EventDetail.BetStatus,Live.EventDetail.TimeStatu,Live.EventDetail.BetradarMatchIds,MatchTime,Score,LegScore,IsActive,BetStopReasonId
			from Live.EventDetail with (nolock) 
			where Live.EventDetail.BetradarMatchIds in (Select DISTINCT BetradarMatchId from @TempSlip)

			--insert into @TArchiveLiveEvenDetail
			--select Archive.[Live.EventDetail].EventId,Archive.[Live.EventDetail].BetStatus,Archive.[Live.EventDetail].TimeStatu,Archive.[Live.EventDetail].BetradarMatchIds,MatchTime,Score,LegScore 
			--from Archive.[Live.EventDetail] with (nolock) where Archive.[Live.EventDetail].BetradarMatchIds in (Select BetradarMatchId from @TempSlip)

		insert into @TLiveEventOdd
		select Live.EventOdd.BetradarMatchId,Live.EventOdd.MatchId,Live.EventOdd.ParameterOddId,Live.EventOdd.OutCome
		,case when  Live.EventOdd.SpecialBetValue is null then '' else Live.EventOdd.SpecialBetValue end ,Live.EventOdd.IsEvaluated,Live.EventOdd.OddResult
		,Live.EventOdd.IsCanceled,Live.EventOdd.OddValue,Live.EventOdd.OddId,Live.EventOdd.IsActive,Live.EventOdd.OddsTypeId ,Live.EventOdd.OddFactor
		from Live.[EventOdd] with (nolock)  where Live.EventOdd.BetradarMatchId in (Select DISTINCT BetradarMatchId from @TempSlip)

			insert @TLiveEventProb
		SELECT OddId,[OddsTypeId],[OutCome],case when  SpecialBetValue is null then '' else SpecialBetValue end,[ProbilityValue],[MatchId],[BettradarOddId],[ParameterOddId],[MarketStatus],[CashoutStatus],[BetradarTimeStamp],[UpdatedDate]
		,[BettingLive].Live.[EventOddProb].[BetradarMatchId],[EvaluatedDate],[BetradarOddsTypeId],[BetradarOddsSubTypeId],[OutcomeActive]
		from [BettingLive].Live.[EventOddProb] with (nolock)  
		where [BettingLive].Live.[EventOddProb].BetradarMatchId in (Select DISTINCT BetradarMatchId from @TempSlip) and CashoutStatus=1



		insert into @TLiveEventOddResult
		select [BettingLive].Live.[EventOddResult].BetradarMatchId,[BettingLive].Live.[EventOddResult].OutCome,case when  [BettingLive].Live.[EventOddResult].SpecialBetValue is null then '' else [BettingLive].Live.[EventOddResult].SpecialBetValue end
		,[BettingLive].Live.[EventOddResult].IsEvaluated,[BettingLive].Live.[EventOddResult].OddResult,[BettingLive].Live.[EventOddResult].IsCanceled,[BettingLive].Live.[EventOddResult].OddId
		from [BettingLive].Live.[EventOddResult] with (nolock) where [BettingLive].Live.[EventOddResult].BetradarMatchId in (Select DISTINCT BetradarMatchId from @TempSlip)
		declare @CouponCount int

		select @SlipSystemCashOut=Customer.SlipSystem.Amount,@SystemAmount=Customer.SlipSystem.Amount,@Systems=Customer.SlipSystem.[System],@SystemGain=MaxGain,@CouponCount=CouponCount 
		from Customer.SlipSystem with (nolock) INNER JOIN Customer.SlipSystemSlip with (nolock) On Customer.SlipSystem.SystemSlipId=Customer.SlipSystemSlip.SystemSlipId where Customer.SlipSystemSlip.SlipId=@SlipId

set @IsCashout=1
set @SystemCashOut=0 
set nocount on
					declare cur111 cursor local for(
					select SlipOddId,OddValue,Customer.Slip.Amount,BetTypeId,OutCome,MatchId,ParameterOddId,case when  SpecialBetValue is null then '' else  SpecialBetValue end  ,EventDate,SportId,customer.SlipOdd.StateId,EventName,OddsTypeId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.MatchId,Customer.SlipOdd.Banko,Customer.SlipOdd.Score,OddProbValue
					from Customer.SlipOdd with (nolock) INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.SlipOdd.SlipId
					where Customer.SlipOdd.SlipId=@SlipId and Customer.Slip.SlipStateId=1
					
						)

					open cur111
					fetch next from cur111 into @SlipOddId,@OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore,@CurrentProb
					while @@fetch_status=0
						begin
							begin
							set @CustomerSpecialBetValue=@SpecialBetValue
							set @OddProfitfactor=0
						set @IsWon=0
							set @TimeStatu=null
							set @MatchTime=''
							set @CustomerOddValue=@OddValue
							set @CustomerOutCome=@Outcome
							set @Score=''
							set @LegScore=''
							  set @probodd=0
							  set @OldprobOdd=0
							  set @BetStopReasonId=0
							set @BetStopReason=''
						 --set @OddKey=1
							set @LiveEventId=null
							set @IsLive=@BetType
							set @IsActive=0
							set @Reason=''
							set @ActiveHomeFark=0
							set @ActiveAwayFark=0
							set @OrgSpecialValue=@SpecialBetValue
							--if(@OddTypeId=1481)
							--set @SpecialBetValue='-1'

if(@StateId=1)
begin
	
	if(@BetType=0) -- Pre Event Oynanmış
		begin
		select @OddType=OddsType from Language.[Parameter.OddsType] with (nolock) where OddsTypeId=@OddTypeId and LanguageId=@LangId
		if(@EventDate>=GETDATE() and (Select Count(*) from @TLiveEvenDetail where BetradarMatchId=@BetradarMatchId and TimeStatu<>1)=0) -- Daha Event Başlamamış
			begin
				
				
				 
				set @Remaningtime=DATEDIFF(MINUTE,GETDATE(),@EventDate)
				set @IsLive=0
				set @IsActive=1
				set @MatchTime=@EventDate
				 	set @Reason='Cashout aktiv'
										 
										set @probodd=@CurrentProb
										
												 if(@CustomerOddValue>9.90)
												 begin
													set @IsActive=0
													set @Reason='Cashout nur moglich bis Quote 9,90'
													set @StateId=4
												end
												if exists (select Match.Match.BetradarMatchId from Match.Match with (nolock) INNER JOIN Parameter.Tournament with (nolock) On Match.TournamentId=Parameter.Tournament.TournamentId and CategoryId=654 and BetradarMatchId=@BetradarMatchId)
													begin
													set @IsActive=0
													set @Reason='Keine Cashout für E-Sports'
													set @StateId=4
													end
			end	
		else --Pre Match Başlamış
			begin
			 
				
				 if not exists(select SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and SportId=6)
				if exists (select BetradarMatchId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId  ) --Event Live da varmı diye bakılıyor
				if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId where BetradarMatchId=@BetradarMatchId and CategoryId=654 )
					begin
		 
						--select @LiveEventId=EventId,@EventId=EventId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId   --Live Event Id alınıyor
			
						if exists (select OddsId from Parameter.Odds with (nolock) where OddsId=@ParameterOddId and LiveOddId is not null) --Pre oynanan marketin liveda karşılığı varmı diye bakılıyor
							begin
						 
								select @ParameterOddId=LiveOddId,@Outcome=LiveOutcome 
								from Parameter.Odds with (nolock) where OddsId=@ParameterOddId

								if(@ParameterOddId in (26,27,28))
									set @SpecialBetValue='1'

								 

								select @OddType=Language.[Parameter.LiveOddType].ShortOddType,@OddTypeId=Live.[Parameter.Odds].OddTypeId 
								from Language.[Parameter.LiveOddType] with (nolock) INNER JOIN 
								Live.[Parameter.Odds] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.Odds].OddTypeId and Language.[Parameter.LiveOddType].LanguageId=@LangId 
								where Live.[Parameter.Odds].OddsId=@ParameterOddId

								if exists (select LiveEventOdd.OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
								ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
								and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
								INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
								INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1    and LiveEventOdd.ParameterOddId=@ParameterOddId
								   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  
								)
									begin --Live da odd hala aktif mi diye bakılıyor
										select @probodd=ProbilityValue
										from @TLiveEventProb as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId   and (SpecialBetValue=@SpecialBetValue ) 
										 and LiveEventOdd.[CashoutStatus]=1  
											
											select @OddValue=ISNULL(OddValue,1.01 )
										from @TLiveEventOdd as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
										and LiveEventOdd.OddValue>1 and LiveEventOdd.IsActive=1
								  

											set @IsLive=1
											set @IsActive=1

											if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
												begin
												set @Reason='Cashout nur moglich bis Quote 9,90'
												set @IsActive=0
												set @StateId=4
												end
 
									end
							   else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.MatchId=LiveEventDetail.EventId where LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 ) or (@StateId=3) 
									begin --Live da odd sonuçlanmış mı 
										select @OddValue=case when LiveEventOddResult.OddResult=1 then 1 else 0 end from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
											
										 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Cashout nicht moglich'

											if(@OddValue=1 or (@StateId=3) )
												begin
												 set @probodd=1
													set @IsWon=1
													set @IsActive=1
														set @Reason=''
												end
 

											  
									end
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
										
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
											 
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatuu=TimeStatu
												 from  @TLiveEvenDetail as LiveEventDetail  
												 WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
																if @ActiveHomeScore>@ActiveAwayScore
																	set @ActiveFark=@ActiveHomeScore-@ActiveAwayScore
																else if @ActiveAwayScore>@ActiveHomeScore
																		set @ActiveFark=@ActiveAwayScore-@ActiveHomeScore
																else
																	set @ActiveFark=0
															end
												if(@HomeScore<>@AwayScore)
													begin
												if (@HomeScore>@AwayScore)
													begin
													set @Fark=@HomeScore-@AwayScore
													set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
														if(@OddTypeId=3)
															set @OddTypeId=709

													end
												else if (@AwayScore>@HomeScore)
													begin
														set @Fark=@AwayScore-@HomeScore
														set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
															if(@OddTypeId=3)
															set @OddTypeId=709
													end

														if(@Fark=@ActiveFark and (@ActiveHomeScore=0 or @ActiveAwayScore=0))
														begin
														set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
													
														end
												if(@OddTypeId=709)
												begin
												if @ParameterOddId=6
													set @ParameterOddId=3403
												else if @ParameterOddId=7
													set @ParameterOddId=3404
												else if @ParameterOddId=8
													set @ParameterOddId=3405
													end
												if (@OddTypeId=18 and @activetimestatuu<3)
													begin
														set @OddTypeId=95
													 if @ParameterOddId=50 
														set @ParameterOddId=276
													else if @ParameterOddId=51
														set @ParameterOddId=277
													else if @ParameterOddId=52
														set @ParameterOddId=278
												end
													--select @EventName,@SpecialBetValue,@Outcome,@OddTypeId
													if exists (select OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
														 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
														 and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1  and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.[CashoutStatus]=1 -- and LiveEventOdd.OddValue>1
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @probodd=[ProbilityValue],@TimeStatu=TimeStatu
																from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and CashoutStatus=1 --and LiveEventOdd.OddValue>1
								
															 	select @OddValue=ISNULL(OddValue,1.01 )
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1
												 
																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	set @StateId=4
																	end
													end
															else
															begin
																if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
																 from  @TLiveEvenDetail as LiveEventDetail  
																WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
																if(@ActiveHomeScore>@HomeScore)
																	set @ActiveHomeFark=@ActiveHomeScore-@HomeScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveHomeFark=@HomeScore-@ActiveHomeScore

																if(@ActiveAwayScore>@AwayScore)
																	set @ActiveAwayFark=@ActiveAwayScore-@AwayScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveAwayFark=@AwayScore-@ActiveAwayScore


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
																	end
																		else
																	begin
																		set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Cashout nicht moglich'
															set @StateId=4
															end
														end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
													begin
													if (@OddTypeId=3)
														set @OddTypeId=708
												 
												 if(@OddTypeId=18)
													set @OddTypeId=20

													if @ParameterOddId=6
														set @ParameterOddId=3400
													else if @ParameterOddId=7
														set @ParameterOddId=3401
													else if @ParameterOddId=8
														set @ParameterOddId=3402

												 else if @ParameterOddId=50
														begin
														set @OddTypeId=20
														set @ParameterOddId=55
														end
													else if @ParameterOddId=51
													begin
														set @OddTypeId=20
														set @ParameterOddId=56
														end
													else if @ParameterOddId=52
													begin
														set @OddTypeId=20
														set @ParameterOddId=57
														end


													set @SpecialBetValue=''

													if exists (select LiveEventOdd.OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
														ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
														and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
														INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
														INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1    and LiveEventOdd.ParameterOddId=@ParameterOddId
														   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  
														)
															begin
																select @probodd=[ProbilityValue],@TimeStatu=TimeStatu
																from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and CashoutStatus=1
												 

												 				select @OddValue=ISNULL(OddValue,1.01 )
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome --and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1
										 
																if (@probodd is not null and @probodd>0 )
																	begin
													 
																	set @IsLive=1
																	set @IsActive=1

																		if(@OddValue>9.9 or   CAST( @probodd as decimal(18,2))<=0.04)
																		begin
																				set @IsActive=0
																				set @Reason='Cashout nur moglich bis Quote 9,90'
																				set @StateId=4
																				end
																end
																else
																	begin
																		set @IsLive=1
																		set @IsActive=0
																		set @probodd=0
																		set @Reason='Cashout nicht moglich'
																		set @StateId=4
																	end
													end
													else -- Odd aktif değil
														begin
															if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																		select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
														
																	if( @ParameterOddId=55 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																	else if( @ParameterOddId=57 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																	else if( @ParameterOddId=3400 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																	else if( @ParameterOddId=3402 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
														else
															begin
															--set @OddKey=1.10
															set @IsLive=1
															set @IsActive=0
															set @Reason='Cashout nicht moglich'
															set @StateId=4
															 set @probodd=0
															 set @Oldprobodd=((1/@CustomerOddValue))
															select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
															end
															
															end
																else
																	begin
																		set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
														end
												end
										 end
								else -- Odd aktif değil
									begin
										--set @OddKey=1.10
										set @IsLive=1
										set @IsActive=0
										set @Reason='Cashout nicht moglich'
										set @StateId=4
										 set @probodd=0
										 set @Oldprobodd=((1/@CustomerOddValue))
										select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
									end
							end
						else
							begin -- Marketin Live da karşılığı yok
								set @IsLive=0
								set @IsActive=0
								set @Reason='Diese Wettart ist nicht mehr verfügbar'
								set @StateId=4
								 set @probodd=0
								 --	set @OddKey=1.10
								 set @Oldprobodd=0
							end
					end
				else --Event Liveda yok
					begin
						set @IsLive=0
						set @IsActive=0
						set @Reason='Dieses Spiel ist nicht als Livewette verfügbar'
						set @StateId=4
						 set @probodd=0
						-- 	set @OddKey=1.10
						 set @Oldprobodd=0
					end
				else --Event Liveda yok
					begin
						set @IsLive=0
						set @IsActive=0
						set @Reason='Dieses Spiel ist nicht als Livewette verfügbar'
						set @StateId=4
						 set @probodd=0
						-- 	set @OddKey=1.10
						 set @Oldprobodd=0
					end
			
			end	
	end
	else
		begin
		
			select @Outcome=Live.[Parameter.Odds].Outcomes from Live.[Parameter.Odds] with (nolock) where OddsId=@ParameterOddId
			select @OddType=Language.[Parameter.LiveOddType].ShortOddType from Language.[Parameter.LiveOddType] with (nolock)   where Language.[Parameter.LiveOddType].LanguageId=@LangId and  Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId
			if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId INNER JOIN Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId where BetradarMatchId=@BetradarMatchId and (Parameter.Category.CategoryId=654 or Parameter.Category.SportId=6 ))
			begin
							if(@BetradarMatchId>0)
								begin
								if exists (select LiveEventOdd.OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
								ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
								and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
								INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId 
								INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
								   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 
								)
									begin --Live da odd hala aktif mi diye bakılıyor
										
										select distinct @probodd= [ProbilityValue] from @TLiveEventProb as LiveEventOdd 
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1 and LiveEventOdd.ParameterOddId=@ParameterOddId
										 and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)

										select @OddValue=OddValue,@TimeStatu=TimeStatu
										from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
										and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventOdd.OddValue>1 and  LiveEventOdd.IsActive=1
										 
											set @IsLive=1
											set @IsActive=1

												if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
												begin
													set @IsActive=0
													set @Reason='Cashout nur moglich bis Quote 9,90'
													set @StateId=4
												end
									end
								
										else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId 
										where LiveEventDetail.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   
										and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1  and  (LiveEventOdd.OddValue is not null) and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  
										and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 )  or (@StateId=3)  
										begin --Live Odd sonuçlanmış mı
											select @OddValue= case when LiveEventOddResult.OddResult=1 then 1 else 0 end
												from @TLiveEventOdd as LiveEventOdd  INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
												 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
												and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
 
									 			set @Remaningtime=9999
													set @IsLive=1
													set @IsActive=0
													set @Reason='Cashout nicht moglich'
														if(@OddValue=1 or @StateId=3)
														begin
															set @probodd=1
															set @Oldprobodd=((1/@CustomerOddValue))
															select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
															set @IsWon=1
															set @IsActive=1
															set @Reason=''
														end
																					
										end
									else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1  and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
										
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
										 
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatuu=TimeStatu
												 from  @TLiveEvenDetail as LiveEventDetail  
												 WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
																if @ActiveHomeScore>@ActiveAwayScore
																	set @ActiveFark=@ActiveHomeScore-@ActiveAwayScore
																else if @ActiveAwayScore>@ActiveHomeScore
																		set @ActiveFark=@ActiveAwayScore-@ActiveHomeScore
																else
																	set @ActiveFark=0
															end
												if(@HomeScore<>@AwayScore)
													begin
												if (@HomeScore>@AwayScore)
													begin
													set @Fark=@HomeScore-@AwayScore
													set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
														if(@OddTypeId=3)
															set @OddTypeId=709

													end
												else if (@AwayScore>@HomeScore)
													begin
														set @Fark=@AwayScore-@HomeScore
														set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
															if(@OddTypeId=3)
															set @OddTypeId=709
													end

													if(@Fark=@ActiveFark and (@ActiveHomeScore=0 or @ActiveAwayScore=0))
														begin
														set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
													
														end
												if(@OddTypeId=709)
												begin
												if @ParameterOddId=6
													set @ParameterOddId=3403
												else if @ParameterOddId=7
													set @ParameterOddId=3404
												else if @ParameterOddId=8
													set @ParameterOddId=3405
													end
												if (@OddTypeId=18 and @activetimestatuu<3)
													begin
														set @OddTypeId=95
													 if @ParameterOddId=50 
														set @ParameterOddId=276
													else if @ParameterOddId=51
														set @ParameterOddId=277
													else if @ParameterOddId=52
														set @ParameterOddId=278
												end
													--select @EventName,@SpecialBetValue,@Outcome,@OddTypeId
													if exists (select OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
														 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
														 and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.[CashoutStatus]=1 -- and LiveEventOdd.OddValue>1
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @probodd=[ProbilityValue],@TimeStatu=TimeStatu
																from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId 
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and CashoutStatus=1 --and LiveEventOdd.OddValue>1
								
															 	select @OddValue=ISNULL(OddValue,1.01 )
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1
												 
																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	set @StateId=4
																	end
													end
															else
															begin
																if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
																 from  @TLiveEvenDetail as LiveEventDetail  
																WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
																if(@ActiveHomeScore>@HomeScore)
																	set @ActiveHomeFark=@ActiveHomeScore-@HomeScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveHomeFark=@HomeScore-@ActiveHomeScore

																if(@ActiveAwayScore>@AwayScore)
																	set @ActiveAwayFark=@ActiveAwayScore-@AwayScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveAwayFark=@AwayScore-@ActiveAwayScore


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Cashout nicht moglich'
															set @StateId=4
															end
															end
																else
																	begin
																		set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
														end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
													begin
													if (@OddTypeId=3)
														set @OddTypeId=708
												 
												 if(@OddTypeId=18)
													set @OddTypeId=20

													if @ParameterOddId=6
														set @ParameterOddId=3400
													else if @ParameterOddId=7
														set @ParameterOddId=3401
													else if @ParameterOddId=8
														set @ParameterOddId=3402

												 else if @ParameterOddId=50
														begin
														set @OddTypeId=20
														set @ParameterOddId=55
														end
													else if @ParameterOddId=51
													begin
														set @OddTypeId=20
														set @ParameterOddId=56
														end
													else if @ParameterOddId=52
													begin
														set @OddTypeId=20
														set @ParameterOddId=57
														end


													set @SpecialBetValue=''
													if exists (select LiveEventOdd.OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
														ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
														and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
														INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
														INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1    and LiveEventOdd.ParameterOddId=@ParameterOddId
														   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  
														)
															begin
																select @probodd=[ProbilityValue],@TimeStatu=TimeStatu
																from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId 
																and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and CashoutStatus=1
												 

												 				select @OddValue=ISNULL(OddValue,1.01 )
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome --and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1
										 
																if (@probodd is not null and @probodd>0 )
																	begin
													 
																	set @IsLive=1
																	set @IsActive=1

																		if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
																		begin
																				set @IsActive=0
																				set @Reason='Cashout nur moglich bis Quote 9,90'
																				set @StateId=4
																				end
																end
																else
																	begin
																		set @IsLive=1
																		set @IsActive=0
																		set @probodd=0
																		set @Reason='Cashout nicht moglich'
																		set @StateId=4
																	end
															end
															else -- Odd aktif değil
																begin
																	if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																	select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
														
														if( @ParameterOddId=55 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=57 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3400 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3402 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
														else
															begin
																	set @IsLive=1
																	set @IsActive=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	set @probodd=0
																	set @Oldprobodd=0
															end
																	end
																		else
																	begin
																		set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
																end
												end
										 end
									
										 	
								else -- Odd aktif değil
									begin
										set @IsLive=1
										set @IsActive=0
										set @Reason='Cashout nicht moglich'
										set @StateId=4
								        set @probodd=0
										set @Oldprobodd=0
								    end
								end
								else
									begin
								if exists (select LiveEventOdd.OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
								ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
								and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
								INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
								INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.IsActive=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
								   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and  LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 
								)
									begin --Live da odd hala aktif mi diye bakılıyor
										select @OddValue=ISNULL(OddValue,1.01 ),@probodd=OddProb
										from @TLiveEventOdd as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
										and LiveEventOdd.OddValue>1 and LiveEventOdd.IsActive=1

											set @IsLive=1
											set @IsActive=1

												if(@OddValue>9.9 or   CAST( @probodd as decimal(18,2))<=0.04)
													begin
													set @IsActive=0
													set @Reason='Cashout nur moglich bis Quote 9,90'
													end

									end
								
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId 
								where LiveEventDetail.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   
								and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1   and  (LiveEventOdd.OddValue is not null) and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  
								and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 )  or (@StateId=3)  
								begin --Live Odd sonuçlanmış mı
									select @OddValue= case when LiveEventOddResult.OddResult=1 then 1 else 0 end
										from @TLiveEventOdd as LiveEventOdd  INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
 
									 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Cashout nicht moglich'

												if(@OddValue=1 or @StateId=3)
												begin
													set @probodd=1
													set @IsWon=1
													set @IsActive=1
													set @Reason=''
												end
																					
								end
									else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
									
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
											
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatuu=TimeStatu
												 from  @TLiveEvenDetail as LiveEventDetail  
												 WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
																if @ActiveHomeScore>@ActiveAwayScore
																	set @ActiveFark=@ActiveHomeScore-@ActiveAwayScore
																else if @ActiveAwayScore>@ActiveHomeScore
																		set @ActiveFark=@ActiveAwayScore-@ActiveHomeScore
																else
																	set @ActiveFark=0
															end
												if(@HomeScore<>@AwayScore)
													begin
												if (@HomeScore>@AwayScore)
													begin
													set @Fark=@HomeScore-@AwayScore
													set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
														if(@OddTypeId=3)
															set @OddTypeId=709

													end
												else if (@AwayScore>@HomeScore)
													begin
														set @Fark=@AwayScore-@HomeScore
														set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
															if(@OddTypeId=3)
															set @OddTypeId=709
													end

													if(@Fark=@ActiveFark and (@ActiveHomeScore=0 or @ActiveAwayScore=0))
														begin
														set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
													
														end
												if(@OddTypeId=709)
												begin
												if @ParameterOddId=6
													set @ParameterOddId=3403
												else if @ParameterOddId=7
													set @ParameterOddId=3404
												else if @ParameterOddId=8
													set @ParameterOddId=3405
													end
												if (@OddTypeId=18 and @activetimestatuu<3)
													begin
														set @OddTypeId=95
													 if @ParameterOddId=50 
														set @ParameterOddId=276
													else if @ParameterOddId=51
														set @ParameterOddId=277
													else if @ParameterOddId=52
														set @ParameterOddId=278
												end
													 --select @EventName,@SpecialBetValue,@Outcome,@OddTypeId
													if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
														 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
														 and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=1   and LiveEventOdd.OddValue>1 -- and LiveEventOdd.OddValue>1
									
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin
															 
															 	select @OddValue=ISNULL(OddValue,1.01 ),@probodd=OddProb
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1 and LiveEventOdd.IsActive=1
												 
																set @IsLive=1
																set @IsActive=1
																--select @OddValue,@probodd
															if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	end
													end
															else
															begin
																if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
																 from  @TLiveEvenDetail as LiveEventDetail  
																WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
																if(@ActiveHomeScore>@HomeScore)
																	set @ActiveHomeFark=@ActiveHomeScore-@HomeScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveHomeFark=@HomeScore-@ActiveHomeScore

																if(@ActiveAwayScore>@AwayScore)
																	set @ActiveAwayFark=@ActiveAwayScore-@AwayScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveAwayFark=@AwayScore-@ActiveAwayScore


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	end
																	end
																		else
																	begin
																		set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Cashout nicht moglich'
															end
														end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
													begin
													if (@OddTypeId=3)
														set @OddTypeId=708
												 
														 if(@OddTypeId=18)
															set @OddTypeId=20

															if @ParameterOddId=6
																set @ParameterOddId=3400
															else if @ParameterOddId=7
																set @ParameterOddId=3401
															else if @ParameterOddId=8
																set @ParameterOddId=3402

														 else if @ParameterOddId=50
																begin
																set @OddTypeId=20
																set @ParameterOddId=55
																end
															else if @ParameterOddId=51
															begin
																set @OddTypeId=20
																set @ParameterOddId=56
																end
															else if @ParameterOddId=52
															begin
																set @OddTypeId=20
																set @ParameterOddId=57
																end


													set @SpecialBetValue=''
												 if exists(select LiveEventOdd.OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
														ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
														and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
														INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
														INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.IsActive=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
														   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and  LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 )
														begin
												

												 					select @OddValue=ISNULL(OddValue,1.01 ),@probodd=OddProb
																	from @TLiveEventOdd as LiveEventOdd
																	where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome --and (SpecialBetValue=@SpecialBetValue ) 
																	and LiveEventOdd.OddValue>1
										  
													if (@probodd is not null and @probodd>0 )
													begin
													 
														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	end
													end
													else
														begin
															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Cashout nicht moglich'
														end
												end
												else
														begin
														if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
															select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
														
														if( @ParameterOddId=55 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
															 
																		end
																else if( @ParameterOddId=57 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3400 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3402 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
														else
															begin
															set @IsLive=1
															set @IsActive=0
															 set @probodd=0
															  set @OddValue=0
															set @Reason='Cashout nicht moglich'
															end
															end
																else
																	begin
																		set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
													end
											 end
										 end
								else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										 set @probodd=0
										  set @OddValue=0
										set @Reason='Cashout nicht moglich'

										
								    end
							end
			end
			else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										set @Reason='Cashout nicht moglich'
										set @StateId=4
									    set @probodd=0
										set @Oldprobodd=0
									
								    end

	end
end
else
begin
	if(@BetType=0)
		begin
			select @OddType=ShortOddType from Language.[Parameter.OddsType] with (nolock) where OddsTypeId=@OddTypeId and LanguageId=@LangId
		end
	else
		begin
			select @OddType=ShortOddType from Language.[Parameter.LiveOddType] with (nolock) where OddTypeId=@OddTypeId and LanguageId=@LangId
		end

	if(@StateId in (2,3,5))
		begin
			if @StateId=3
			begin
				set @OddValue=1
				set @IsWon=1
				set @Reason='Gewonnen'
				set @probodd=1
			end
		else
			begin
				if(@StateId<>2 and @EventDate>=GETDATE() and (Select Count(*) from @TLiveEvenDetail where BetradarMatchId=@BetradarMatchId and TimeStatu<>1)=0) -- Daha Event Başlamamış
					begin
						set @probodd=@CurrentProb
					end
				else
					set @probodd=1
			set @OddValue=0
			set @IsWon=0
			end
			set @IsActive=1
			set @IsLive=@BetType
			
 
					 
		end
	else
		begin
			if(@StateId<>4)
				begin
				set @IsActive=0
				set @Reason='Cashout nicht moglich'
				end
			else
				begin
				set @IsActive=-1
				set @Reason=''
				end
			set @IsLive=0
			set @Reason='Verloren'
			set @probodd=0
				--set @OddKey=1.10
			set @Oldprobodd=0
		end
end

			if(@Score='' or @Score is null)
				begin
						SELECT  top 1 @Score= case when  LiveEventDetail.MatchTime is not null then  cast(  LiveEventDetail.MatchTime as nvarchar(50)) + ''' -' + RTRIM( LiveEventDetail.Score) else 
						case when Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId>1 then cast(Language.[Parameter.LiveTimeStatu].TimeStatu as nvarchar(10))+ ' - ' + RTRIM( LiveEventDetail.Score) else '-' end end 
						,@LegScore=LegScore,@ActiveSportTime=MatchTime,@TimeStatu=LiveEventDetail.TimeStatu
						 from  @TLiveEvenDetail as LiveEventDetail  LEFT OUTER JOIN
                         Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId =  LiveEventDetail.TimeStatu
						WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId) AND (Language.[Parameter.LiveTimeStatu].LanguageId = 6)
					end

			--if(@Score='' or @Score is null)
			--	begin
			--			SELECT  top 1 @Score= case when ArchiveLiveEventDetail.MatchTime is not null then  cast( ArchiveLiveEventDetail.MatchTime as nvarchar(50)) + ''' -' + RTRIM(ArchiveLiveEventDetail.Score) else case when Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId>1 then cast(Language.[Parameter.LiveTimeStatu].TimeStatu as nvarchar(10))+ ' - ' + RTRIM(ArchiveLiveEventDetail.Score) else '-' end end 
			--			,@LegScore=LegScore,@ActiveSportTime=MatchTime,@TimeStatu=ArchiveLiveEventDetail.TimeStatu
			--			from @TArchiveLiveEvenDetail as ArchiveLiveEventDetail  LEFT OUTER JOIN
			--			Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId = ArchiveLiveEventDetail.TimeStatu
			--			WHERE        (ArchiveLiveEventDetail.BetradarMatchId = @BetradarMatchId) AND (Language.[Parameter.LiveTimeStatu].LanguageId = 6)
			--		end
			if @Score is null or @Score=''
						set @Score='-'
					 
		 
									set @OddProfitfactor=((@probodd*100)/(@CurrentProb*100))

									 select top 1 @LowerTicketValueLadder =TicketValueFactor ,@LowerReductionFactor=DeductionFactor/100
									from @TCashoutKeySystem where  TicketValueFactor<@OddProfitfactor order by TicketValueFactor desc

								 select top 1 @UpperTicketValueLadder =TicketValueFactor ,@UpperReductionFactor=DeductionFactor/100
									from @TCashoutKeySystem where TicketValueFactor>@OddProfitfactor order by TicketValueFactor asc
								 if (@IsActive=1  and @probodd>0)
								 begin
									 

									set @ticketvaluefack=(@probodd)/(@CurrentProb)

									set @decfactor=1-(@ticketvaluefack-@LowerTicketValueLadder)/(@UpperTicketValueLadder-@LowerTicketValueLadder)
									set @reducation=(((@probodd*100)/(@CurrentProb*100))/((@decfactor*@LowerTicketValueLadder/@LowerReductionFactor+(1-@decfactor)*@UpperTicketValueLadder/@UpperReductionFactor)))
									set @cashoutfactor=1/@reducation
									set @cashoutfactor=@cashoutfactor*@ticketvaluefack
								end
								else
									set @cashoutfactor=0

										select  @Remaningtime2=ISNULL(COUNT(*),0) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=1

						select  @LegScore=cast(ISNULL(COUNT(*),0) as nvarchar(20)) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=2
						Select @BetStopReasonId = ISNULL(T.ReasonId,0),@BetStopReason=ISNULL(Language.[Parameter.LiveBetStopReason].Reason,'') from @TLiveEvenDetail as T Inner JOIN Language.[Parameter.LiveBetStopReason] ON ISNULL(Language.[Parameter.LiveBetStopReason].ParameterReasonId,0)=T.ReasonId and LanguageId=@LangId
						and T.BetradarMatchId=@BetradarMatchId

								-- select @reducation as reducation,@ticketvaluefack as ticketvaluefactor,@decfactor as interpolo, @cashoutfactor,@LowerReductionFactor as LowerRed,@UpperReductionFactor as UpperRed,@LowerTicketValueLadder as LowerTic,@UpperTicketValueLadder as UpperTic,@probodd as Currents,@CurrentProb as TicketTime,@EventName,@IsActive,@OddValue
					insert @TempTableSystem
					select @SlipOddId,@OddValue,@Remaningtime2,@IsActive,@IsLive,@Amount,@Score,@LegScore,@EventName,@CustomerOddValue,@CustomerOutCome,case when @CustomerSpecialBetValue<>'-1' then @CustomerSpecialBetValue else '' end,@OddType,@EventDate,case when @OddValue=1 then  STR(@CustomerOddValue, 25, 2)   else STR(@OddValue, 25, 2) end,@IsWon,0,@OddProfitfactor,@BetradarMatchId,@EventId,@Banko,@probodd,1,case when @Reason='' then 'Cashout Aktiv' else @Reason end,@cashoutfactor,@OddTypeId,@OrgSpecialValue,ISNULL(@BetStopReason,''),ISNULL(@BetStopReasonId,0),@StateId


		end
							fetch next from cur111 into @SlipOddId, @OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore,@CurrentProb
			
						end
					close cur111
					deallocate cur111	
					 
					if not exists ((select IsActive from @TempTableSystem where IsActive=0))
						if exists (select IsActive from @TempTableSystem where IsLive=1) or (select COUNT(*) from @TempTableSystem where IsWon=1)>0
							begin

								DECLARE @Delimeter char(1)
								SET @Delimeter = ','
								declare @sayac int=0
								DECLARE @tblOdd TABLE( SystemCount nvarchar(10))
								DECLARE @tbltemp TABLE(Id int)
								DECLARE @ak nvarchar(10)
								DECLARE @StartPos int, @Length int
								WHILE LEN(@Systems) > 0
								  BEGIN
									SET @StartPos = CHARINDEX(@Delimeter, @Systems)
									IF @StartPos < 0 SET @StartPos = 0
									SET @Length = LEN(@Systems) - @StartPos - 1
									IF @Length < 0 SET @Length = 0
									IF @StartPos > 0
									  BEGIN
										SET @ak = SUBSTRING(@Systems, 1, @StartPos - 1)
										SET @Systems = SUBSTRING(@Systems, @StartPos + 1, LEN(@Systems) - @StartPos)
										set @sayac=@sayac+1
									  END
									ELSE
									  BEGIN
										SET @ak = @Systems
										SET @Systems = ''
										set @sayac=@sayac+1
									  END
									INSERT @tblOdd ( SystemCount) VALUES(@ak)
								END

								declare @SystemCount int

 
		declare @Odds nvarchar(300)=''
		declare @ActiveOdds nvarchar(300)=''
		declare @CustomerOdds nvarchar(300)=''
		declare @say int=0
		declare @BankoOddValue float =1
		declare @BankoActiveOddValue float =1
		declare @BankoCustomerOddValue float =1
		 declare @pf float
		 declare @Oldpf float
		 declare @IsBanko int
		 declare @CustomerSlipOdd float
		declare @ActiveProb float
		set @ReelValue=0
		set nocount on
							declare cur1112 cursor local for(
							select SystemCount From @tblOdd 

								)
							order by cast( SystemCount as int)
							open cur1112
							fetch next from cur1112 into @SystemCount
							while @@fetch_status=0
								begin
									begin
									set @say=@say+1
							
					
									 
												   if  not exists(Select OddId from @TempTableSystem where SlipStateId=4 and Banko=1 ) 
													 if ((Select Count(*) from @TempTableSystem where IsActive=1 and CurrentProb>0 and SlipStateId in (1,2,3,5)  )>=@SystemCount)
												 begin
														set @BankoOddValue=1
															set nocount on
																	declare cur11123 cursor local for(
																	select CurrentProb,Banko,CustomerOddValue,OddProb From @TempTableSystem where IsActive=1 and CurrentProb>0 and SlipStateId in (1,2,3,5)

																		)

																	open cur11123
																	fetch next from cur11123 into @pf,@IsBanko,@CustomerSlipOdd,@ActiveProb
																	while @@fetch_status=0
																		begin
																			begin
																				if(@IsBanko=0)
																					begin
																					 
																					set @Odds=@Odds+cast(@pf as nvarchar(10))+';'
																					set @ActiveOdds=@ActiveOdds+cast(@ActiveProb as nvarchar(10))+';'
																					set @CustomerOdds=@CustomerOdds+cast(@CustomerSlipOdd as nvarchar(10))+';'
																					end
																				else
																				begin
																				--set @Odds=@Odds+cast('1' as nvarchar(10))+';'
																					set @BankoOddValue=@BankoOddValue*@pf
																					set @BankoActiveOddValue=@BankoActiveOddValue*@ActiveProb
																					set @BankoCustomerOddValue=@BankoCustomerOddValue*@CustomerSlipOdd
																					end
																			end
																			fetch next from cur11123 into @pf,@IsBanko,@CustomerSlipOdd,@ActiveProb
			
																		end
																	close cur11123
																	deallocate cur11123
																	if(Len(@Odds)>1)
																	begin
																		set @Odds=SUBSTRING(@Odds,1,LEN(@Odds)-1)
																		set @CustomerOdds=SUBSTRING(@CustomerOdds,1,LEN(@CustomerOdds)-1)
																		set @ActiveOdds=SUBSTRING(@ActiveOdds,1,LEN(@ActiveOdds)-1)
																	 
															
																		--select @WinAmountActive=[RiskManagement].[FuncSlipSystemEvaluateCashOut]   (@SystemCount,@ActiveOdds,1)
																		select @WinAmountReel=[RiskManagement].[FuncSlipSystemEvaluateCashOut]   (@SystemCount,@CustomerOdds,@Amount)
																
																		select @WinAmount=[RiskManagement].[FuncSlipSystemEvaluateCashOut]   (@SystemCount,@Odds,@Amount)
																 
																		set @TotalProbTickettime=@TotalProbTickettime+ (@WinAmount)
																		--set @TotalProbCurrenTime=@TotalProbCurrenTime+ (@WinAmountActive)
																		set @ReelValue=@ReelValue+ (@WinAmountReel)
																		set @Odds=''
																		set @CustomerOdds=''
																		set @ActiveOdds=''
																	end
												end
											 
									 
								 
							 
								 
									end
									fetch next from cur1112 into @SystemCount
			
								end
							close cur1112
							deallocate cur1112

							if (@TotalProbTickettime>0)
							begin
							set  @TotalProbTickettime=@TotalProbTickettime*@BankoOddValue
							set @ReelValue=@ReelValue*@BankoCustomerOddValue
								set @TotalOddValue =0
								set @ProfitFactor =1
				 
								set @LayRate =0
								set @TotalProb =0
								set @CurrentOddValue =0
				
								set @CashOut=@TotalProbTickettime
							end
									if not exists(Select OddId from @TempTableSystem where IsWon=0) --Kuponda kaybeden maç yoksa kuponun değeri veriliyor
									set @CashOut=@ReelValue
							if(@CashOut>@ReelValue)
								set @CashOut=@SystemAmount


				 
							end
							else if not exists (select OddId from @TempTableSystem where IsActive=0)   and (select COUNT(*) from @TempTableSystem)>0 and (select COUNT(*) from @TempTableSystem where EvenDate<GETDATE())=0
							begin
					 
								set @CashOut=@SystemAmount
							end
							else
								set @CashOut=0

							if(@CashOut<0.01)
							set @CashOut=0
						if exists ((select IsActive from @TempTableSystem where IsActive=0))
							if(@CashOut>@TotalWinAmountReel)
							begin
								set @CashOut=0
							 end

							 	if(@CashOut is null)
							set @CashOut=0

						update @TempTableSystem set CashOutValue=@CashOut

		 
					 	select DISTINCT cast(0 as bigint) as OddId ,OddValue ,RemaningTime ,IsActive ,IsLive ,Amount ,Score ,LegScore ,EventName ,CustomerOddValue ,OutCome ,SpecialBetValue,OddType ,EvenDate ,MatchTime ,IsWon ,CashOutValue ,ProfitFactor,BetradarMatchId,EventId ,Banko,case when Reason='' then 'Cashout Aktiv' else Reason  end  as Reason ,BetStopReason,BetStopReasonId
					from @TempTableSystem Order by EvenDate,BetradarMatchId
							--from @TempTableSystem2
						end
 else if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=5 and SlipStateId=1  and  (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and (BetTypeId  in (2) or OddsTypeId in (14)))=0  and (Select Count(Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and SlipStateId=1 )<26   )
	begin
	
 declare @TCashoutKeyMulti table (TicketValueFactor float,DeductionFactor float)
 
insert @TCashoutKeyMulti
select TicketValueFactor,DeductionFactor from [Parameter].[CashoutKeyMulti] with (nolock)



insert @TCashoutKey2
select * from Parameter.CashoutKey2

declare @EventPerBet nvarchar(300)
	declare @MultiGain money					
		insert into @TempSlip
		SELECT DISTINCT Customer.SlipOdd.BetradarMatchId
							FROM	Customer.SlipOdd with (nolock) 
							WHERE  (Customer.SlipOdd.SlipId=@SlipId) and (Customer.SlipOdd.BetTypeId in (0,1))
	insert into @TLiveEvent
			select [BettingLive].Live.[Event].BetradarMatchId,[BettingLive].Live.[Event].EventId,[BettingLive].Live.[Event].ConnectionStatu,TournamentId 
			from [BettingLive].Live.[Event] with (nolock) where  [BettingLive].Live.[Event].BetradarMatchId in (Select DISTINCT BetradarMatchId from @TempSlip)

		insert into @TLiveEvenDetail
			select Live.EventDetail.EventId,Live.EventDetail.BetStatus,Live.EventDetail.TimeStatu,Live.EventDetail.BetradarMatchIds,MatchTime,Score,LegScore,IsActive,BetStopReasonId
			from Live.EventDetail with (nolock) 
			where Live.EventDetail.BetradarMatchIds in (Select DISTINCT BetradarMatchId from @TempSlip)

			--insert into @TArchiveLiveEvenDetail
			--select Archive.[Live.EventDetail].EventId,Archive.[Live.EventDetail].BetStatus,Archive.[Live.EventDetail].TimeStatu,Archive.[Live.EventDetail].BetradarMatchIds,MatchTime,Score,LegScore 
			--from Archive.[Live.EventDetail] with (nolock) where Archive.[Live.EventDetail].BetradarMatchIds in (Select BetradarMatchId from @TempSlip)

		insert into @TLiveEventOdd
		select Live.EventOdd.BetradarMatchId,Live.EventOdd.MatchId,Live.EventOdd.ParameterOddId,Live.EventOdd.OutCome
		,case when  Live.EventOdd.SpecialBetValue is null then '' else Live.EventOdd.SpecialBetValue end ,Live.EventOdd.IsEvaluated,Live.EventOdd.OddResult
		,Live.EventOdd.IsCanceled,Live.EventOdd.OddValue,Live.EventOdd.OddId,Live.EventOdd.IsActive,Live.EventOdd.OddsTypeId ,Live.EventOdd.OddFactor
		from Live.[EventOdd] with (nolock)  where Live.EventOdd.BetradarMatchId in (Select DISTINCT BetradarMatchId from @TempSlip)

			insert @TLiveEventProb
		SELECT OddId,[OddsTypeId],[OutCome],case when  SpecialBetValue is null then '' else SpecialBetValue end,[ProbilityValue],[MatchId],[BettradarOddId],[ParameterOddId],[MarketStatus],[CashoutStatus],[BetradarTimeStamp],[UpdatedDate]
		,[BettingLive].Live.[EventOddProb].[BetradarMatchId],[EvaluatedDate],[BetradarOddsTypeId],[BetradarOddsSubTypeId],[OutcomeActive]
		from [BettingLive].Live.[EventOddProb] with (nolock) 
	where [BettingLive].Live.[EventOddProb].BetradarMatchId in (Select DISTINCT BetradarMatchId from @TempSlip) and CashoutStatus=1



		insert into @TLiveEventOddResult
		select [BettingLive].Live.[EventOddResult].BetradarMatchId,[BettingLive].Live.[EventOddResult].OutCome,case when  [BettingLive].Live.[EventOddResult].SpecialBetValue is null then '' else [BettingLive].Live.[EventOddResult].SpecialBetValue end
		,[BettingLive].Live.[EventOddResult].IsEvaluated,[BettingLive].Live.[EventOddResult].OddResult,[BettingLive].Live.[EventOddResult].IsCanceled,[BettingLive].Live.[EventOddResult].OddId
		from [BettingLive].Live.[EventOddResult] with (nolock) where [BettingLive].Live.[EventOddResult].BetradarMatchId in (Select DISTINCT BetradarMatchId from @TempSlip)

		select @SlipSystemCashOut=Customer.SlipSystem.Amount,@SystemAmount=Amount,@EventPerBet=Customer.SlipSystem.[System],@MultiGain=MaxGain 
			from Customer.SlipSystem with (nolock) INNER JOIN Customer.SlipSystemSlip with (nolock) On Customer.SlipSystem.SystemSlipId=Customer.SlipSystemSlip.SystemSlipId 
			where Customer.SlipSystemSlip.SlipId=@SlipId

		 

set @IsCashout=1
set @SystemCashOut=0 
set nocount on
					declare cur111 cursor local for(
					select SlipOddId,OddValue,Customer.Slip.Amount,BetTypeId,OutCome,MatchId,ParameterOddId,case when  SpecialBetValue is null then '' else  SpecialBetValue end  ,EventDate,SportId,customer.SlipOdd.StateId,EventName,OddsTypeId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.MatchId,Customer.SlipOdd.Banko,Customer.SlipOdd.Score,OddProbValue
					from Customer.SlipOdd with (nolock) INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.SlipOdd.SlipId
					where Customer.SlipOdd.SlipId=@SlipId and Customer.Slip.SlipStateId=1
					
						)
						Order by BetradarMatchId
					open cur111
					fetch next from cur111 into @SlipOddId,@OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore,@CurrentProb
					while @@fetch_status=0
						begin
							begin
							set @CustomerSpecialBetValue=@SpecialBetValue
							set @OddProfitfactor=0
							set @IsWon=0
							set @TimeStatu=null
							set @MatchTime=''
							set @CustomerOddValue=@OddValue
							set @CustomerOutCome=@Outcome
							set @Score=''
							set @LegScore=''
							set @probodd=0
							set @BetStopReasonId=0
							set @BetStopReason=''
							set @OldprobOdd=0
							set @LiveEventId=null
							set @IsLive=@BetType
							set @IsActive=0
							set @Reason='Cashout Aktiv'
							set @ActiveHomeFark=0
							set @ActiveAwayFark=0
							set @OrgSpecialValue=@SpecialBetValue

if(@StateId=1)
begin
	
	if(@BetType=0) -- Pre Event Oynanmış
		begin
		select @OddType=ShortOddType from Language.[Parameter.OddsType] with (nolock) where OddsTypeId=@OddTypeId and LanguageId=@LangId
		if(@EventDate>=GETDATE() and (Select Count(*) from @TLiveEvenDetail where BetradarMatchId=@BetradarMatchId and TimeStatu<>1)=0) -- Daha Event Başlamamış
			begin
				
				

				set @Remaningtime=DATEDIFF(MINUTE,GETDATE(),@EventDate)
				set @IsLive=0
				set @IsActive=1
				set @MatchTime=@EventDate
				set @Reason='Cashout aktiv'
				set @probodd=@CurrentProb
									

											if(@CustomerOddValue>9.90)
												begin
												set @IsActive=0
												set @Reason='Cashout nur moglich bis Quote 9,90'
												set @StateId=4
												end

													if exists (select Match.Match.BetradarMatchId from Match.Match with (nolock) INNER JOIN Parameter.Tournament with (nolock) On Match.TournamentId=Parameter.Tournament.TournamentId and CategoryId=654 and BetradarMatchId=@BetradarMatchId)
													begin
													set @Reason='Keine Cashout für E-Sports'
													set @IsActive=0
													set @StateId=4
													end
			end	
		else --Pre Match Başlamış
			begin
			 
				
				 if not exists(select SlipOddId from Customer.SlipOdd with (nolock) where SlipId=@SlipId and SportId=6)
				if exists (select BetradarMatchId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId  ) --Event Live da varmı diye bakılıyor
					if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId where BetradarMatchId=@BetradarMatchId and CategoryId=654 )
					begin
		 
					--	select @LiveEventId=EventId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId   --Live Event Id alınıyor
			
						if exists (select OddsId from Parameter.Odds with (nolock) where OddsId=@ParameterOddId and LiveOddId is not null) --Pre oynanan marketin liveda karşılığı varmı diye bakılıyor
							begin
						 
								select @ParameterOddId=LiveOddId,@Outcome=LiveOutcome 
								from Parameter.Odds with (nolock) where OddsId=@ParameterOddId

								if(@ParameterOddId in (26,27,28))
									set @SpecialBetValue='1'

								 
							 
								select @OddType=Language.[Parameter.LiveOddType].ShortOddType,@OddTypeId=Live.[Parameter.Odds].OddTypeId 
								from Language.[Parameter.LiveOddType] with (nolock) INNER JOIN 
								Live.[Parameter.Odds] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.Odds].OddTypeId and Language.[Parameter.LiveOddType].LanguageId=@LangId 
								where Live.[Parameter.Odds].OddsId=@ParameterOddId

								if exists (select LiveEventOdd.OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
								ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
								and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
								INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
								INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
								   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue) and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 
								)
									begin --Live da odd hala aktif mi diye bakılıyor
										select @probodd=ProbilityValue
										from @TLiveEventProb as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId   and (SpecialBetValue=@SpecialBetValue ) 
										 and LiveEventOdd.[CashoutStatus]=1 
											
											select @OddValue=ISNULL(OddValue,1.01 )
										from @TLiveEventOdd as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
										and LiveEventOdd.OddValue>1 and  LiveEventOdd.IsActive=1
								  

											set @IsLive=1
											set @IsActive=1

											if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
												begin
												set @Reason='Cashout nur moglich bis Quote 9,90'
												set @IsActive=0
												set @StateId=4
												end
 
									end
							   else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.MatchId=LiveEventDetail.EventId where LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 ) or (@StateId=3) 
									begin --Live da odd sonuçlanmış mı 
										select @OddValue=case when LiveEventOddResult.OddResult=1 then 1 else 0 end from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
											
										 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Cashout nicht moglich'

											if(@OddValue=1 or (@StateId=3) )
												begin
												 set @probodd=1
													set @IsWon=1
													set @IsActive=1
												end
 

											  
									end
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1  and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
										
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
											 
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatuu=TimeStatu
												 from  @TLiveEvenDetail as LiveEventDetail  
												 WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
																if @ActiveHomeScore>@ActiveAwayScore
																	set @ActiveFark=@ActiveHomeScore-@ActiveAwayScore
																else if @ActiveAwayScore>@ActiveHomeScore
																		set @ActiveFark=@ActiveAwayScore-@ActiveHomeScore
																else
																	set @ActiveFark=0
															end
												if(@HomeScore<>@AwayScore)
													begin
												if (@HomeScore>@AwayScore)
													begin
													set @Fark=@HomeScore-@AwayScore
													set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
														if(@OddTypeId=3)
															set @OddTypeId=709

													end
												else if (@AwayScore>@HomeScore)
													begin
														set @Fark=@AwayScore-@HomeScore
														set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
															if(@OddTypeId=3)
															set @OddTypeId=709
													end

														if(@Fark=@ActiveFark and (@ActiveHomeScore=0 or @ActiveAwayScore=0))
														begin
														set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
													
														end
												if(@OddTypeId=709)
												begin
												if @ParameterOddId=6
													set @ParameterOddId=3403
												else if @ParameterOddId=7
													set @ParameterOddId=3404
												else if @ParameterOddId=8
													set @ParameterOddId=3405
													end
												if (@OddTypeId=18 and @activetimestatuu<3)
													begin
														set @OddTypeId=95
													 if @ParameterOddId=50 
														set @ParameterOddId=276
													else if @ParameterOddId=51
														set @ParameterOddId=277
													else if @ParameterOddId=52
														set @ParameterOddId=278
												end
													--select @EventName,@SpecialBetValue,@Outcome,@OddTypeId
													if exists (select OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
														 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
														 and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.[CashoutStatus]=1 -- and LiveEventOdd.OddValue>1
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @probodd=[ProbilityValue],@TimeStatu=TimeStatu
																from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1 and CashoutStatus=1 --and LiveEventOdd.OddValue>1
								
															 	select @OddValue=ISNULL(OddValue,1.01 )
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1
												 
																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	set @StateId=4
																	end
													end
															else
															begin
															if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
																 from  @TLiveEvenDetail as LiveEventDetail  
																WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
																if(@ActiveHomeScore>@HomeScore)
																	set @ActiveHomeFark=@ActiveHomeScore-@HomeScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveHomeFark=@HomeScore-@ActiveHomeScore

																if(@ActiveAwayScore>@AwayScore)
																	set @ActiveAwayFark=@ActiveAwayScore-@AwayScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveAwayFark=@AwayScore-@ActiveAwayScore


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
																	end
																		else
																	begin
																		set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @StateId=4
															set @Reason='Cashout nicht moglich'
															end
														end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
													begin
													if (@OddTypeId=3)
														set @OddTypeId=708
												 
												 if(@OddTypeId=18)
													set @OddTypeId=20

													if @ParameterOddId=6
														set @ParameterOddId=3400
													else if @ParameterOddId=7
														set @ParameterOddId=3401
													else if @ParameterOddId=8
														set @ParameterOddId=3402

												 else if @ParameterOddId=50
														begin
														set @OddTypeId=20
														set @ParameterOddId=55
														end
													else if @ParameterOddId=51
													begin
														set @OddTypeId=20
														set @ParameterOddId=56
														end
													else if @ParameterOddId=52
													begin
														set @OddTypeId=20
														set @ParameterOddId=57
														end


													set @SpecialBetValue=''

														if exists (select LiveEventOdd.OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
														ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
														and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
														INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
														INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1    and LiveEventOdd.ParameterOddId=@ParameterOddId
														   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  
														)
															begin
																select @probodd=[ProbilityValue],@TimeStatu=TimeStatu
																from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and CashoutStatus=1
												 

												 				select @OddValue=ISNULL(OddValue,1.01 )
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome --and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1
										 
																if (@probodd is not null and @probodd>0 )
																	begin
													 
																	set @IsLive=1
																	set @IsActive=1

																		if(@OddValue>9.9)
																		begin
																				set @IsActive=0
																				set @Reason='Cashout nur moglich bis Quote 9,90'
																				set @StateId=4
																				end
																end
																else
																	begin
																		set @IsLive=1
																		set @IsActive=0
																		set @probodd=0
																		set @Reason='Cashout nicht moglich'
																		set @StateId=4
																	end
															end
															else -- Odd aktif değil
																begin
																if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																		select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
														
														if( @ParameterOddId=55 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=57 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3400 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3402 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
														else
															begin
																	
																		--set @OddKey=1.10
																		set @IsLive=1
																		set @IsActive=0
																		set @Reason='Cashout nicht moglich'
																		set @StateId=4
																		 set @probodd=0
																		 set @Oldprobodd=0
															end
															end
																else
																	begin
																		set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end

										
												 --set @probodd=1
													--set @IsWon=1
													--set @IsActive=1
										



									end
												end
										 end
								else -- Odd aktif değil
									begin
										--set @OddKey=1.10
										set @IsLive=1
										set @IsActive=0
										set @Reason='Cashout nicht moglich'
										set @StateId=4
										 set @probodd=0
										 set @Oldprobodd=0
										
												 --set @probodd=1
													--set @IsWon=1
													--set @IsActive=1
										



									end
							end
						else
							begin -- Marketin Live da karşılığı yok
								set @IsLive=0
								set @IsActive=0
								set @Reason='Diese Wettart ist nicht mehr verfügbar'
								set @StateId=4
								 set @probodd=0
								 	--set @OddKey=1.10
								 set @Oldprobodd=0
							end
					end
					else --Event Liveda yok
					begin
						set @IsLive=0
						set @IsActive=0
						set @Reason='Dieses Spiel ist nicht als Livewette verfügbar'
						set @StateId=4
						 set @probodd=0
						-- 	set @OddKey=1.10
						 set @Oldprobodd=0
					end
				else --Event Liveda yok
					begin
						set @IsLive=0
						set @IsActive=0
						 set @probodd=0
						-- 	set @OddKey=1.10
						 set @Oldprobodd=0
					end
			
			end	
	end
	else
		begin
		
			select @Outcome=Live.[Parameter.Odds].Outcomes from Live.[Parameter.Odds] with (nolock) where OddsId=@ParameterOddId
			select @OddType=Language.[Parameter.LiveOddType].ShortOddType from Language.[Parameter.LiveOddType] with (nolock)   
			where Language.[Parameter.LiveOddType].LanguageId=@LangId and  Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId
				if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId INNER JOIN Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId where BetradarMatchId=@BetradarMatchId and (Parameter.Category.CategoryId=654 or Parameter.Category.SportId=6 ))
			begin
							if (@BetradarMatchId>0)
						begin
								if exists (select LiveEventOdd.OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
								ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
								and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
								INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
								INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
								   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue) and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 
								)
									begin --Live da odd hala aktif mi diye bakılıyor
										
										select distinct @probodd= [ProbilityValue] from @TLiveEventProb as LiveEventOdd 
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1 and LiveEventOdd.ParameterOddId=@ParameterOddId
										 and (LiveEventOdd.SpecialBetValue=@SpecialBetValue) 

										select @OddValue=OddValue,@TimeStatu=TimeStatu
										from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
										and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventOdd.OddValue>1 and  LiveEventOdd.IsActive=1
										 
											set @IsLive=1
											set @IsActive=1

												if(@OddValue>9.9)
												begin
												
													set @IsActive=0
													set @Reason='Cashout nur moglich bis Quote 9,90'
													set @StateId=4
												end
									end
								
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId 
								where LiveEventDetail.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   
								and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1   and  (LiveEventOdd.OddValue is not null) and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  
								and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 )  or (@StateId=3)  
									begin --Live Odd sonuçlanmış mı
									select @OddValue= case when LiveEventOddResult.OddResult=1 then 1 else 0 end
										from @TLiveEventOdd as LiveEventOdd  INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
 
									 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Cashout nicht moglich'
												if(@OddValue=1 or @StateId=3)
												begin
													set @probodd=1
													set @Oldprobodd=((1/@CustomerOddValue))
													select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
													set @IsWon=1
													set @IsActive=1
													set @Reason=''
												end
																					
								end
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
										
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
											 
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatuu=TimeStatu
												 from  @TLiveEvenDetail as LiveEventDetail  
												 WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
																if @ActiveHomeScore>@ActiveAwayScore
																	set @ActiveFark=@ActiveHomeScore-@ActiveAwayScore
																else if @ActiveAwayScore>@ActiveHomeScore
																		set @ActiveFark=@ActiveAwayScore-@ActiveHomeScore
																else
																	set @ActiveFark=0
															end
												if(@HomeScore<>@AwayScore)
													begin
												if (@HomeScore>@AwayScore)
													begin
													set @Fark=@HomeScore-@AwayScore
													set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
														if(@OddTypeId=3)
															set @OddTypeId=709

													end
												else if (@AwayScore>@HomeScore)
													begin
														set @Fark=@AwayScore-@HomeScore
														set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
															if(@OddTypeId=3)
															set @OddTypeId=709
													end

													if(@Fark=@ActiveFark and (@ActiveHomeScore=0 or @ActiveAwayScore=0))
														begin
														set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
													
														end
												if(@OddTypeId=709)
												begin
												if @ParameterOddId=6
													set @ParameterOddId=3403
												else if @ParameterOddId=7
													set @ParameterOddId=3404
												else if @ParameterOddId=8
													set @ParameterOddId=3405
													end
												if (@OddTypeId=18 and @activetimestatuu<3)
													begin
														set @OddTypeId=95
													 if @ParameterOddId=50 
														set @ParameterOddId=276
													else if @ParameterOddId=51
														set @ParameterOddId=277
													else if @ParameterOddId=52
														set @ParameterOddId=278
												end
													--select @EventName,@SpecialBetValue,@Outcome,@OddTypeId
													if exists (select OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
														 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
														 and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.[CashoutStatus]=1 -- and LiveEventOdd.OddValue>1
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @probodd=[ProbilityValue],@TimeStatu=TimeStatu
																from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1 and CashoutStatus=1 --and LiveEventOdd.OddValue>1
								
															 	select @OddValue=ISNULL(OddValue,1.01 )
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1
												 
																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	set @StateId=4
																	end
													end
															else
															begin
															if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
																 from  @TLiveEvenDetail as LiveEventDetail  
																WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
																if(@ActiveHomeScore>@HomeScore)
																	set @ActiveHomeFark=@ActiveHomeScore-@HomeScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveHomeFark=@HomeScore-@ActiveHomeScore

																if(@ActiveAwayScore>@AwayScore)
																	set @ActiveAwayFark=@ActiveAwayScore-@AwayScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveAwayFark=@AwayScore-@ActiveAwayScore


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
																	end
																		else
																	begin
																		set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Cashout nicht moglich'
															set @StateId=4
															end
														end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
													begin
													if (@OddTypeId=3)
														set @OddTypeId=708
												 
												 if(@OddTypeId=18)
													set @OddTypeId=20

													if @ParameterOddId=6
														set @ParameterOddId=3400
													else if @ParameterOddId=7
														set @ParameterOddId=3401
													else if @ParameterOddId=8
														set @ParameterOddId=3402

												 else if @ParameterOddId=50
														begin
														set @OddTypeId=20
														set @ParameterOddId=55
														end
													else if @ParameterOddId=51
													begin
														set @OddTypeId=20
														set @ParameterOddId=56
														end
													else if @ParameterOddId=52
													begin
														set @OddTypeId=20
														set @ParameterOddId=57
														end


													set @SpecialBetValue=''
													if exists (select LiveEventOdd.OddId from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
														ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
														and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
														INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
														INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1    and LiveEventOdd.ParameterOddId=@ParameterOddId
														   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  
														)
															begin
																select @probodd=[ProbilityValue],@TimeStatu=TimeStatu
																from @TLiveEventProb as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and CashoutStatus=1
												 

												 				select @OddValue=ISNULL(OddValue,1.01 ) 
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome --and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1
										 
															if (@probodd is not null and @probodd>0 )
																begin
													 
														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	set @StateId=4
																	end
													end
															else
																begin
															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Cashout nicht moglich'
															set @StateId=4
														end
													end
													else -- Odd aktif değil
														begin
														if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																	select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
														
														if( @ParameterOddId=55 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=57 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3400 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3402 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																			else
																	begin
																		set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	set @StateId=4
																	end
																		end

														else
															begin
																	
																					set @IsLive=1
															set @IsActive=0
															set @Reason='Cashout nicht moglich'
															set @StateId=4
															 set @probodd=0
															 set @Oldprobodd=0
															end
										
										
								    end
												end
										 end 	
								else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										set @Reason='Cashout nicht moglich'
										set @StateId=4
										 set @probodd=0
										 set @Oldprobodd=0
										
								    end
							end
								else
							begin
								
								if exists (select LiveEventOdd.OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
								ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
								and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
								INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
								INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.IsActive=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
								   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and  LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 
								)
									begin --Live da odd hala aktif mi diye bakılıyor
							
										--select distinct @probodd= [ProbilityValue] from @TLiveEventProb as LiveEventOdd 
										--where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.[CashoutStatus]=1 and LiveEventOdd.ParameterOddId=@ParameterOddId
										--and (LiveEventOdd.SpecialBetValue=@SpecialBetValue) 

										select @OddValue=ISNULL(OddValue,1.01 ),@probodd=OddProb
										from @TLiveEventOdd as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
										and LiveEventOdd.OddValue>1 and LiveEventOdd.IsActive=1

											set @IsLive=1
											set @IsActive=1

												if(@OddValue>9.9 or   CAST( @probodd as decimal(18,2))<=0.04)
													begin
													set @IsActive=0
													set @Reason='Cashout nur moglich bis Quote 9,90'
													end

									end
								
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId 
								where LiveEventDetail.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   
								and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1   and  (LiveEventOdd.OddValue is not null) and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  
								and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 )  or (@StateId=3)  
								begin --Live Odd sonuçlanmış mı
									select @OddValue= case when LiveEventOddResult.OddResult=1 then 1 else 0 end
										from @TLiveEventOdd as LiveEventOdd  INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
 
									 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Cashout nicht moglich'

												if(@OddValue=1 or @StateId=3)
												begin
													set @probodd=1
													set @IsWon=1
													set @IsActive=1
													set @Reason=''
												end
																					
								end
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2  and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
									
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
											
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatuu=TimeStatu
												 from  @TLiveEvenDetail as LiveEventDetail  
												 WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
																if @ActiveHomeScore>@ActiveAwayScore
																	set @ActiveFark=@ActiveHomeScore-@ActiveAwayScore
																else if @ActiveAwayScore>@ActiveHomeScore
																		set @ActiveFark=@ActiveAwayScore-@ActiveHomeScore
																else
																	set @ActiveFark=0
															end
												if(@HomeScore<>@AwayScore)
													begin
												if (@HomeScore>@AwayScore)
													begin
													set @Fark=@HomeScore-@AwayScore
													set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
														if(@OddTypeId=3)
															set @OddTypeId=709

													end
												else if (@AwayScore>@HomeScore)
													begin
														set @Fark=@AwayScore-@HomeScore
														set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
															if(@OddTypeId=3)
															set @OddTypeId=709
													end

													if(@Fark=@ActiveFark and (@ActiveHomeScore=0 or @ActiveAwayScore=0))
														begin
														set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
													
														end
												if(@OddTypeId=709)
												begin
												if @ParameterOddId=6
													set @ParameterOddId=3403
												else if @ParameterOddId=7
													set @ParameterOddId=3404
												else if @ParameterOddId=8
													set @ParameterOddId=3405
													end
												if (@OddTypeId=18 and @activetimestatuu<3)
													begin
														set @OddTypeId=95
													 if @ParameterOddId=50 
														set @ParameterOddId=276
													else if @ParameterOddId=51
														set @ParameterOddId=277
													else if @ParameterOddId=52
														set @ParameterOddId=278
												end
													 --select @EventName,@SpecialBetValue,@Outcome,@OddTypeId
													if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
														 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
														 and LiveEventDetail.BetStatus=2 and LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=1   and LiveEventOdd.OddValue>1 -- and LiveEventOdd.OddValue>1
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin
															 
															 	select @OddValue=ISNULL(OddValue,1.01 ),@probodd=OddProb
																from @TLiveEventOdd as LiveEventOdd
																where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
																and LiveEventOdd.OddValue>1 and LiveEventOdd.IsActive=1
												 
																set @IsLive=1
																set @IsActive=1
																--select @OddValue,@probodd
															if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	end
													end
															else
															begin
																if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
																SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
																 from  @TLiveEvenDetail as LiveEventDetail  
																WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
																if(@ActiveHomeScore>@HomeScore)
																	set @ActiveHomeFark=@ActiveHomeScore-@HomeScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveHomeFark=@HomeScore-@ActiveHomeScore

																if(@ActiveAwayScore>@AwayScore)
																	set @ActiveAwayFark=@ActiveAwayScore-@AwayScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveAwayFark=@AwayScore-@ActiveAwayScore


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)=2)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=276 and (@ActiveHomeFark-@ActiveAwayFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=278 and (@ActiveAwayFark-@ActiveHomeFark)>2)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																	end
																	end
																		else
																	begin
																		set @IsLive=1
															set @IsActive=0
															 set @probodd=0
															  set @OddValue=0
															set @Reason='Cashout nicht moglich'
																	end
															end
															else
																begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Cashout nicht moglich'
																end
														end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
													begin
													if (@OddTypeId=3)
														set @OddTypeId=708
												 
														 if(@OddTypeId=18)
															set @OddTypeId=20

															if @ParameterOddId=6
																set @ParameterOddId=3400
															else if @ParameterOddId=7
																set @ParameterOddId=3401
															else if @ParameterOddId=8
																set @ParameterOddId=3402

														 else if @ParameterOddId=50
																begin
																set @OddTypeId=20
																set @ParameterOddId=55
																end
															else if @ParameterOddId=51
															begin
																set @OddTypeId=20
																set @ParameterOddId=56
																end
															else if @ParameterOddId=52
															begin
																set @OddTypeId=20
																set @ParameterOddId=57
																end


													set @SpecialBetValue=''
												 if exists(select LiveEventOdd.OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOdd as LiveOdd 
														ON LiveEventOdd.BetradarMatchId=LiveOdd.BetradarMatchId and LiveEventOdd.OddsTypeId=LiveOdd.OddsTypeId
														and LiveEventOdd.ParameterOddId=LiveOdd.ParameterOddId and LiveOdd.SpecialBetValue=LiveEventOdd.SpecialBetValue 
														INNER JOIN @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventOdd.BetradarMatchId
														INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId and LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId
														 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.IsActive=1   and LiveEventOdd.ParameterOddId=@ParameterOddId
														   and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  and LiveEventDetail.BetStatus=2 and  LiveEventDetail.IsActive=1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2 )
														begin
												 					select @OddValue=ISNULL(OddValue,1.01 ),@probodd=OddProb
																	from @TLiveEventOdd as LiveEventOdd
																	where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome --and (SpecialBetValue=@SpecialBetValue ) 
																	and LiveEventOdd.OddValue>1
										  
													if (@probodd is not null and @probodd>0 )
													begin
													 
														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9 or  CAST( @probodd as decimal(18,2))<=0.04)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	end
													end
													else
														begin
															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Cashout nicht moglich'
														end
												end
												else
														begin
															if exists( Select TEO.OddId from @TLiveEventOdd as TEO where TEO.BetradarMatchId=@BetradarMatchId and TEO.IsActive=1)
																	begin
															select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
															
														
														if( @ParameterOddId=55 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
															 
																		end
																else if( @ParameterOddId=57 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3400 and (@ActiveHomeScore-@ActiveAwayScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
																else if( @ParameterOddId=3402 and (@ActiveAwayScore-@ActiveHomeScore)>0)
																		begin
																		set @OddValue=1.01
																		set @IsActive=1
																		set @probodd=((1/@OddValue))
																 
																		end
														else
															begin
															set @IsLive=1
															set @IsActive=0
															 set @probodd=0
															  set @OddValue=0
															set @Reason='Cashout nicht moglich'
															end
															end
																else
																	begin
																		set @IsLive=1
																		set @IsActive=0
																	    set @probodd=0
																		set @OddValue=0
																		set @Reason='Cashout nicht moglich'
																	end
													end
											 end
										 end
								else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										 set @probodd=0
										  set @OddValue=0
										set @Reason='Cashout nicht moglich'

										
								    end
							end
					end
					else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										set @Reason='Cashout nicht moglich'
										set @StateId=4
										 set @probodd=0
										 set @Oldprobodd=0
										
								    end
	end
end
else
begin
	if(@BetType=0)
		begin
			select @OddType=ShortOddType from Language.[Parameter.OddsType] with (nolock) where OddsTypeId=@OddTypeId and LanguageId=@LangId
		end
	else
		begin
			select @OddType=ShortOddType from Language.[Parameter.LiveOddType] with (nolock) where OddTypeId=@OddTypeId and LanguageId=@LangId
		end

	if(@StateId=3)
		begin
			set @OddValue=1
			set @IsWon=1
			set @IsActive=1
			set @IsLive=@BetType
			set @probodd=1
	 
			set @Reason='Gewonnen'
			--set @OddKey=1.10
			set @Oldprobodd=((1/@CustomerOddValue)/((1/@CustomerOddValue)/100))/100
			select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
		end
	else
		begin
			if (select COUNT(*) from @TempTableSystem where BetradarMatchId=@BetradarMatchId)>1
				set @IsActive=-1
			if(@StateId in (2,5))
					begin
					set @IsActive=1
					set @probodd=1
					end
				else
				begin
				set @IsActive=0
				set @probodd=0
				end
			set @IsLive=0
			if(@StateId=4)
				set @Reason='Verloren'
			else if (@StateId=2)
				set @Reason='Storno'
			--	set @OddKey=1.10
			set @Oldprobodd=0
		end
end

			if(@Score='' or @Score is null)
				begin
						SELECT  top 1 @Score= case when  LiveEventDetail.MatchTime is not null then  cast(  LiveEventDetail.MatchTime as nvarchar(50)) + ''' -' + RTRIM( LiveEventDetail.Score) else 
						case when Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId>1 then cast(Language.[Parameter.LiveTimeStatu].TimeStatu as nvarchar(10))+ ' - ' + RTRIM( LiveEventDetail.Score) else '-' end end 
						,@LegScore=LegScore,@ActiveSportTime=MatchTime,@TimeStatu=LiveEventDetail.TimeStatu
						 from  @TLiveEvenDetail as LiveEventDetail  LEFT OUTER JOIN
                         Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId =  LiveEventDetail.TimeStatu
						WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId) AND (Language.[Parameter.LiveTimeStatu].LanguageId = 6)
					end

			--if(@Score='' or @Score is null)
			--	begin
			--			SELECT  top 1 @Score= case when ArchiveLiveEventDetail.MatchTime is not null then  cast( ArchiveLiveEventDetail.MatchTime as nvarchar(50)) + ''' -' + RTRIM(ArchiveLiveEventDetail.Score) else 
			--			case when Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId>1 then cast(Language.[Parameter.LiveTimeStatu].TimeStatu as nvarchar(10))+ ' - ' + RTRIM(ArchiveLiveEventDetail.Score) else '-' end end 
			--			,@LegScore=LegScore,@ActiveSportTime=MatchTime,@TimeStatu=ArchiveLiveEventDetail.TimeStatu
			--			from @TArchiveLiveEvenDetail as ArchiveLiveEventDetail  LEFT OUTER JOIN
			--			Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId = ArchiveLiveEventDetail.TimeStatu
			--			WHERE        (ArchiveLiveEventDetail.BetradarMatchId = @BetradarMatchId) AND (Language.[Parameter.LiveTimeStatu].LanguageId = 6)
			--		end
			if @Score is null or @Score=''
						set @Score='-'

						 

						set @TotalProbTickettime =0
					set @TotalProbCurrenTime =0
					set @ValueTicketTime =0
					set @TicketValueFactor =0
					set @ReductionFactor =0
					set @ExpectedProfit =0
					set @ProportionTicketTime =50
					set @DeltaProb =0
					set @CashoutValueTicketTime =0
					set @OverallEffect =0
					set @OverallEffectAbs =0
					
					set @LowerTicketValueLadder =0
					set @UpperTicketValueLadder =0
					set @LowerReductionFactor =0
					set @UpperReductionFactor =0
					set @Interpolation =0
					set @CashoutNoMargin =0
					set @CashoutLadder =0
					set @cashoutfactor =0
									set @decfactor =0
									set @ticketvaluefack =0
									set @reducation =0
							
										 if (@IsActive<>0 and @probodd>0)
								 begin
								 
					 	set @OddProfitfactor=((@probodd*100)/(@CurrentProb*100))

									 select top 1 @LowerTicketValueLadder =TicketValueFactor ,@LowerReductionFactor=DeductionFactor/100
									from @TCashoutKeyMulti where  TicketValueFactor<@OddProfitfactor order by TicketValueFactor desc

								 select top 1 @UpperTicketValueLadder =TicketValueFactor ,@UpperReductionFactor=DeductionFactor/100
									from @TCashoutKeyMulti where TicketValueFactor>@OddProfitfactor order by TicketValueFactor asc
									
									 
							if(@LowerTicketValueLadder<>0 and @UpperTicketValueLadder<>0)
							begin
									set @ticketvaluefack=(@probodd)/(@CurrentProb)

									set @decfactor=1-(@ticketvaluefack-@LowerTicketValueLadder)/(@UpperTicketValueLadder-@LowerTicketValueLadder)
										--	select @EventName,@probodd,@CurrentProb,@decfactor,@LowerTicketValueLadder,@UpperTicketValueLadder,@OddProfitfactor
									set @reducation=(((@probodd*100)/(@CurrentProb*100))/((@decfactor*@LowerTicketValueLadder/@LowerReductionFactor+(1-@decfactor)*@UpperTicketValueLadder/@UpperReductionFactor)))
									set @cashoutfactor=1/@reducation
									--select @cashoutfactor
									set @cashoutfactor=@cashoutfactor*@ticketvaluefack
									end
									else
									set @cashoutfactor=0
								end
								else
									set @cashoutfactor=0
		select  @Remaningtime2=ISNULL(COUNT(*),0) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=1

						select  @LegScore=cast(ISNULL(COUNT(*),0) as nvarchar(20)) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=2

						Select @BetStopReasonId =ISNULL(T.ReasonId,0),@BetStopReason=ISNULL(Language.[Parameter.LiveBetStopReason].Reason,'') from @TLiveEvenDetail as T Inner JOIN Language.[Parameter.LiveBetStopReason] ON ISNULL(Language.[Parameter.LiveBetStopReason].ParameterReasonId,0)=T.ReasonId and LanguageId=@LangId
						and T.BetradarMatchId=@BetradarMatchId
								 --select @reducation as reducation,@ticketvaluefack as ticketvaluefactor,@decfactor as interpolo, @cashoutfactor as cashoutfactor,@LowerReductionFactor as LowerRed,@UpperReductionFactor as UpperRed,@LowerTicketValueLadder as LowerTic,@UpperTicketValueLadder as UpperTic,@probodd as Currents,@CurrentProb as TicketTime,@EventName,@IsActive,@OddValue,@CustomerOddValue
					insert @TempTableSystem
					select @SlipOddId,@OddValue,@Remaningtime2,@IsActive,@IsLive,@Amount,@Score,@LegScore,@EventName,@CustomerOddValue,@CustomerOutCome,case when @CustomerSpecialBetValue<>'-1' then @CustomerSpecialBetValue else '' end,@OddType,@EventDate,case when @OddValue=1 then  STR(@CustomerOddValue, 25, 2)   else STR(@OddValue, 25, 2) end,@IsWon,0,@OddProfitfactor,@BetradarMatchId,@EventId,@Banko,@probodd,1,case when @Reason='' then 'Cashout Aktiv' else @Reason end,@cashoutfactor,@OddTypeId,@OrgSpecialValue,ISNULL(@BetStopReason,''),ISNULL(@BetStopReasonId,0),@StateId

		end
							fetch next from cur111 into @SlipOddId, @OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore,@CurrentProb
			
						end
					close cur111
					deallocate cur111	
			 

					insert @TempTableSystem2
					select * from @TempTableSystem

					set @TotalWinAmount=0
				declare @OldMatchId bigint
				declare @OddMatchId bigint	
				declare @OldOddValue float
			 
				 declare @Multipf float
				 declare @MultiOdds nvarchar(300)=''
				 declare @MultiCustomerOdds nvarchar(300)=''
					 select @EventPerBet= COUNT(distinct BetradarMatchId) from @TempTableSystem 

					

						if  (((select COUNT(*) from @TempTableSystem where IsActive=0)=0 or (select COUNT(*) from @TempTableSystem where BetradarMatchId in (select BetradarMatchId from @TempTableSystem where IsActive=0) and IsActive=1)>0 ) and (((select COUNT(*) from @TempTableSystem where IsLive=1)>0) or ((select COUNT(*) from @TempTableSystem where IsWon=1)>0)  or (select COUNT(*) from @TempTableSystem where Score like '%beendet%')>0) )   
						begin
					 

						set @OldMatchId=0
						set @OldOddTypeId=0
					   set @OldSpecialValue =''
					   set @OldOddValue=0
					   set @OldOutCome=''
					   
					   	--set nocount on
									--						declare cur1000 cursor local for(
									--						select CurrentProb,CustomerOddValue,BetradarMatchId,OddValue,OddTypeId,OrgSpecialBetValue,OutCome From @TempTableSystem2 where IsActive=1 and CurrentProb>0 

									--							)
									--							order by BetradarMatchId
									--						open cur1000
									--						fetch next from cur1000 into @Multipf,@CustomerOddValue,@OddMatchId,@OddValue,@OddTypeId,@SpecialBetValue,@CustomerOutCome
									--						while @@fetch_status=0
									--							begin
									--								begin
														 
																		
									--								 if(@OldMatchId=@OddMatchId and @OldOddTypeId=@OddTypeId and @OldSpecialValue=@SpecialBetValue)
									--								 begin
																
									--									if (@OldOddValue>@OddValue)
									--										begin
									--											--select @OldMatchId,@OldOddTypeId,@OldSpecialValue,@OldOddValue
									--										    update @TempTableSystem2 set IsActive=0 where BetradarMatchId=@OldMatchId and OddTypeId=@OldOddTypeId and SpecialBetValue=@OldSpecialValue and OutCome=@OldOutCome
									--										end
									--									else
									--										begin
									--											--select @OddMatchId,@OldOddTypeId,@OldSpecialValue,@OldOddValue
									--										    update @TempTableSystem2 set IsActive=0 where BetradarMatchId=@OddMatchId and OddTypeId=@OddTypeId and SpecialBetValue=@SpecialBetValue and OutCome=@CustomerOutCome
									--										end
									--								 end

									--								 set @OldMatchId=@OddMatchId
									--								 set @OldSpecialValue=@SpecialBetValue
									--								 set @OldOddTypeId=@OddTypeId
									--								set @OldOddValue=@OddValue
									--								set @OldOutCome=@CustomerOutCome
									--								--- 
									--								end
									--								fetch next from cur1000 into @Multipf,@CustomerOddValue,@OddMatchId,@OddValue,@OddTypeId,@SpecialBetValue,@CustomerOutCome
			
									--							end
									--						close cur1000
									--						deallocate cur1000

 

									set @OldMatchId=0
													set nocount on
															declare cur11123 cursor local for(
															select CurrentProb,CustomerOddValue,BetradarMatchId,OddValue,@OddTypeId,@OrgSpecialValue From @TempTableSystem2 where IsActive=1 and CurrentProb>0  and SlipStateId in (1,2,3,5)

																)
																order by BetradarMatchId
															open cur11123
															fetch next from cur11123 into @Multipf,@CustomerOddValue,@OddMatchId,@OddValue,@OddTypeId,@SpecialBetValue
															while @@fetch_status=0
																begin
																	begin
														 
																		
																	 if(@OldMatchId<>@OddMatchId)
																	 begin
																		set @MultiOdds=@MultiOdds+';'
																		set @MultiCustomerOdds=@MultiCustomerOdds+';'
																		end
																	else
																		begin
																		
																		set @MultiOdds=@MultiOdds+','
																			set @MultiCustomerOdds=@MultiCustomerOdds+','
																		end
																		 set @MultiOdds=@MultiOdds+cast(@Multipf as nvarchar(10))
																		 set @MultiCustomerOdds=@MultiCustomerOdds+cast(@CustomerOddValue as nvarchar(30))
																		set @OldMatchId=@OddMatchId

																	end
																	fetch next from cur11123 into @Multipf,@CustomerOddValue,@OddMatchId,@OddValue,@OddTypeId,@SpecialBetValue
			
																end
															close cur11123
															deallocate cur11123

															set @MultiOdds=SUBSTRING(@MultiOdds,2,LEN(@MultiOdds))
															set @MultiCustomerOdds=SUBSTRING(@MultiCustomerOdds,2,LEN(@MultiCustomerOdds))
															select @WinAmount=[RiskManagement].[FuncSlipMultiEvaluateCashOut]     (@EventPerBet,@MultiOdds,@Amount)
												 
														  select @WinAmountReel=[RiskManagement].[FuncSlipMultiEvaluate]     (@EventPerBet,@MultiCustomerOdds,@Amount)
														 
																set @TotalWinAmount=@TotalWinAmount+ (@WinAmount)
															set @TotalWinAmountReel=@TotalWinAmountReel+ (@WinAmountReel)
														 
															set @Multipf=''
--														
				
						set @CashOut=@TotalWinAmount

						 

				 
					end
					else if not exists (select OddId from @TempTableSystem where IsActive=0) and (select COUNT(*) from @TempTableSystem)>0 and (select COUNT(*) from @TempTableSystem where EvenDate<GETDATE())=0
					begin
							set @CashOut=@SystemAmount
					end
					else
						set @CashOut=0

						if(@CashOut>=@MultiGain)
						begin
					 
							set @CashOut=0
					 end
					 if(Select count(*) from @TempTableSystem where CustomerOddValue=1)>0
						if(@CashOut>=@WinAmountReel)
							begin
					 
							set @CashOut=0
						end
					 	if(@CashOut is null)
							set @CashOut=0
						update @TempTableSystem set CashOutValue=@CashOut

				select DISTINCT cast(0 as bigint) as OddId ,OddValue ,RemaningTime ,IsActive ,IsLive ,Amount ,Score ,LegScore ,EventName ,CustomerOddValue ,OutCome ,SpecialBetValue,OddType ,EvenDate ,MatchTime ,IsWon ,CashOutValue ,ProfitFactor,BetradarMatchId,EventId ,Banko ,Reason,BetStopReason,BetStopReasonId
					from @TempTableSystem Order by EvenDate,BetradarMatchId
					 
							--from @TempTableSystem2
						end
 else
	begin

						set @SystemCashOut=0
						if (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0
								select DISTINCT cast(0 as bigint) as OddId 
								,OddValue as OddValue ,0 as RemaningTime , cast(1 as bit ) as IsActive ,cast(0 as bit ) as IsLive ,cast(0 as money) as Amount 
								,'' as Score ,'' as LegScore ,EventName as EventName ,OddValue as  CustomerOddValue ,OutCome as OutCome 
								,SpecialBetValue as SpecialBetValue,case when Customer.SlipOdd.BetTypeId=0 
								then (Select Language.[Parameter.OddsType].OddsType  COLLATE SQL_Latin1_General_CP1_CI_AS from Language.[Parameter.OddsType] where Language.[Parameter.OddsType].OddsTypeId=Customer.SlipOdd.OddsTypeId and LanguageId=@LangId) 
								else (Select Language.[Parameter.LiveOddType].ShortOddType from  Language.[Parameter.LiveOddType] where Language.[Parameter.LiveOddType].OddTypeId=Customer.SlipOdd.OddsTypeId and LanguageId=@LangId) end as OddType ,EventDate as  EvenDate ,'' as MatchTime ,cast(0 as bit ) as IsWon 
								,@SystemCashOut as CashOutValue ,cast(0 as float ) as ProfitFactor,BetradarMatchId,MatchId as  EventId  ,Banko,''  COLLATE SQL_Latin1_General_CP1_CI_AS as Reason,'' as BetStopReason,cast(0 as int) as BetStopReasonId
							from Customer.SlipOdd with (nolock)  where SlipId=@SlipId
							--from @TempTable2
					else
						select DISTINCT cast(0 as bigint) as OddId 
								,OddValue as OddValue ,0 as RemaningTime , cast(1 as bit ) as IsActive ,cast(0 as bit ) as IsLive ,Customer.SlipOdd.Amount  as Amount 
								,'-' as Score ,'0' as LegScore ,EventName as EventName ,OddValue as  CustomerOddValue ,OutCome as OutCome 
								,'' as SpecialBetValue
								 ,'' as OddType ,EventDate as  EvenDate ,'1.00' as MatchTime ,cast(0 as bit ) as IsWon 
								,cast(0 as money) as CashOutValue ,cast(1 as float ) as ProfitFactor,BetradarMatchId,MatchId as  EventId  ,Banko,''  COLLATE SQL_Latin1_General_CP1_CI_AS as Reason,'' as BetStopReason,cast(0 as int) as BetStopReasonId
							from Customer.SlipOdd with (nolock)  where SlipId=@SlipId

						end


	
					
				


GO
