USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCashOutSlipDetail_OLD]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcCashOutSlipDetail_OLD] 
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
declare @Score nvarchar(20)
declare @LegScore nvarchar(20)
declare @EventName nvarchar(200)
declare @CustomerOddValue float
declare @CustomerOutCome nvarchar(150)
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
declare @probodd decimal(18,2)=0
declare @Oldprobodd decimal(18,2)=0
declare @CashOutKey float=1.015
 declare @TotalProb float=0
 declare @CustomerSpecialBetValue nvarchar(200)
 	declare @MatchScore nvarchar(20)
	 declare @WinAmount money=0
declare @WinAmountReel money=0
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
declare @Reason nvarchar(150)
 declare @SlipScore nvarchar(20)
 	declare @TotalOddValue float=0
					declare @ProfitFactor float=1
					declare @ReelValue money=@Amount
					declare @LayRate float=0
					declare @CurrentOddValue float
					   declare @timestatu2 int

declare @CustomerId bigint
declare @SystemAmount money
select @CustomerId=CustomerId from Customer.Slip where SlipId=@SlipId

declare @TCashoutKey table (CashoutKeyId int not null,Value1 float not null,Value2 float not null,CashoutKey float not null)
declare @TCashoutKey2 table (CashoutKeyId int not null,Value1 float not null,Value2 float not null,CashoutKey float not null)

declare @TLiveEvent table (BetradarMatchId bigint not null,EventId bigint not null,ConnectionStatu int,TournamentId bigint)
declare @TLiveEvenDetail table (EventId bigint not null,BetStatus int,TimeStatu int,BetradarMatchId bigint,MatchTime bigint,Score nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,LegScore nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS )
declare @TArchiveLiveEvenDetail table (EventId bigint not null,BetStatus int,TimeStatu int,BetradarMatchId bigint,MatchTime bigint,Score nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS,LegScore nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS )
declare @TLiveEventOdd table (BetradarMatchId bigint not null,MatchId bigint not null,ParameterOddId int,OutCome nvarchar(100),SpecialBetValue nvarchar(100),IsEvaluated bit,OddResult bit,IsCanceled bit,OddValue float,OddId bigint,IsActive bit,OddsTypeId int)

declare @TLiveEventOddResult table (BetradarMatchId bigint not null,OutCome nvarchar(100),SpecialBetValue nvarchar(100),IsEvaluated bit,OddResult bit,IsCanceled bit,OddId bigint)

declare @TempSlip table (BetradarMatchId bigint not null)

declare @TempTable table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float,Reason nvarchar(150) )
declare @TempTableNew table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float,OldOddProd float,Reason nvarchar(150))

declare @TempTable2 table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float,Reason nvarchar(150))
declare @TempTableSystem table (OddId bigint,OddValue float,RemaningTime int,IsActive bit,IsLive bit,Amount money,Score nvarchar(50),LegScore nvarchar(20),EventName nvarchar(200),CustomerOddValue float,OutCome nvarchar(150),SpecialBetValue nvarchar(150),OddType nvarchar(100),EvenDate datetime,MatchTime nvarchar(50),IsWon bit,CashOutValue money,ProfitFactor float,BetradarMatchId bigint,EventId bigint,Banko int,OddProb float,OldOddProb float,Reason nvarchar(150))

insert @TCashoutKey
select * from Parameter.CashoutKey

insert @TCashoutKey2
select * from Parameter.CashoutKey2

declare @ActiveFark int=-1



if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId<3 and SlipStateId=1  and (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0 and (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and SportId  in (4))=0  )
	begin


insert @TempSlip
SELECT    Customer.SlipOdd.BetradarMatchId
	FROM         
						  Customer.SlipOdd with (nolock) 
	WHERE     (Customer.SlipOdd.SlipId = @SlipId) AND (Customer.SlipOdd.BetTypeId in (1,0))

	
		insert into @TLiveEvent
			select Live.[Event].BetradarMatchId,Live.[Event].EventId,Live.[Event].ConnectionStatu,TournamentId from Live.[Event] with (nolock) INNER JOIN @TempSlip as TS ON Live.[Event].BetradarMatchId=TS.BetradarMatchId

		insert into @TLiveEvenDetail
			select Live.EventDetail.EventId,Live.EventDetail.BetStatus,Live.EventDetail.TimeStatu,Live.EventDetail.BetradarMatchIds,MatchTime,Score,LegScore from Live.EventDetail with (nolock) INNER JOIN @TempSlip as TS ON Live.EventDetail.BetradarMatchIds=TS.BetradarMatchId

			insert into @TArchiveLiveEvenDetail
			select Archive.[Live.EventDetail].EventId,Archive.[Live.EventDetail].BetStatus,Archive.[Live.EventDetail].TimeStatu,Archive.[Live.EventDetail].BetradarMatchIds,MatchTime,Score,LegScore from Archive.[Live.EventDetail] with (nolock) INNER JOIN @TempSlip as TS ON Archive.[Live.EventDetail].BetradarMatchIds=TS.BetradarMatchId

		insert into @TLiveEventOdd
		select Live.EventOdd.BetradarMatchId,Live.EventOdd.MatchId,Live.EventOdd.ParameterOddId,Live.EventOdd.OutCome,case when  Live.EventOdd.SpecialBetValue is null then '' else Live.EventOdd.SpecialBetValue end ,Live.EventOdd.IsEvaluated,Live.EventOdd.OddResult,Live.EventOdd.IsCanceled,Live.EventOdd.OddValue,Live.EventOdd.OddId,Live.EventOdd.IsActive,Live.EventOdd.OddsTypeId 
		from Live.[EventOdd] with (nolock) INNER JOIN @TempSlip as TS ON Live.EventOdd.BetradarMatchId=TS.BetradarMatchId

			insert into @TLiveEventOddResult
		select [BettingLive].Live.[EventOddResult].BetradarMatchId,[BettingLive].Live.[EventOddResult].OutCome,case when  [BettingLive].Live.[EventOddResult].SpecialBetValue is null then '' else [BettingLive].Live.[EventOddResult].SpecialBetValue end
		,[BettingLive].Live.[EventOddResult].IsEvaluated,[BettingLive].Live.[EventOddResult].OddResult,[BettingLive].Live.[EventOddResult].IsCanceled,[BettingLive].Live.[EventOddResult].OddId
		from [BettingLive].Live.[EventOddResult] with (nolock) -- INNER JOIN @TempSlip as TMP On Live.[EventOddResult].BetradarMatchId=TMP.BetradarMatchId 
		 where [BettingLive].Live.[EventOddResult].BetradarMatchId in (Select BetradarMatchId from @TempSlip)
			
												declare @SlipFark int

set nocount on
					declare cur111 cursor local for(
					select SlipOddId,OddValue,Customer.Slip.Amount,BetTypeId,OutCome,MatchId,ParameterOddId,case when  SpecialBetValue is null then '' else  SpecialBetValue end ,EventDate,SportId,customer.SlipOdd.StateId,EventName,OddsTypeId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.MatchId,Customer.SlipOdd.Banko,Customer.SlipOdd.Score
					from Customer.SlipOdd with (nolock) INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.SlipOdd.SlipId
					where Customer.SlipOdd.SlipId=@SlipId and Customer.Slip.SlipStateId=1
					
						)

					open cur111
					fetch next from cur111 into @SlipOddId,@OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore
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
				
				

				set @Remaningtime=DATEDIFF(MINUTE,GETDATE(),@EventDate)
				set @IsLive=0
				set @IsActive=1
				set @MatchTime=@EventDate
				 set @Reason='Cashout aktiv'
				 ----select @OddKey=SUM(1/(OddValue))
					----					from Match.Odd with (nolock) 
					----					 where MatchId=@MatchId and OddsTypeId=@OddTypeId
					----					and   ( SpecialBetValue=@SpecialBetValue or  SpecialBetValue is null) 
										-- set @OddKey=1.10
										set @probodd=((1/@CustomerOddValue))
											select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd


											if exists (select Match.Match.BetradarMatchId from Match.Match with (nolock) INNER JOIN Parameter.Tournament with (nolock) On Match.TournamentId=Parameter.Tournament.TournamentId and CategoryId=654 and BetradarMatchId=@BetradarMatchId)
													begin
													set @IsActive=0
													set @Reason='Keine Cashout für E-Sports'
													end
			end				
		else --Pre Match Başlamış
			begin
			 
				-- if not exists(select * from Customer.SlipOdd with (nolock) where SlipId=@SlipId and SportId<>6)
				if exists (select BetradarMatchId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId  )  --Event Live da varmı diye bakılıyor
					if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId where BetradarMatchId=@BetradarMatchId and CategoryId=654 )
					begin
		 
						select @LiveEventId=EventId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId   --Live Event Id alınıyor
			
						if exists (select OddsId from Parameter.Odds with (nolock) where OddsId=@ParameterOddId and LiveOddId is not null) --Pre oynanan marketin liveda karşılığı varmı diye bakılıyor
							begin
						 
								select @ParameterOddId=LiveOddId,@Outcome=LiveOutcome 
								from Parameter.Odds with (nolock) where OddsId=@ParameterOddId

									if(@ParameterOddId in (26,27,28))
									set @SpecialBetValue='0:0'

									--	if(@ParameterOddId in (80,81,82))
									--set @SpecialBetValue='-1'
							 
								

								select  @OddTypeId=Live.[Parameter.Odds].OddTypeId 
								from Language.[Parameter.LiveOddType] with (nolock) INNER JOIN 
								Live.[Parameter.Odds] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.Odds].OddTypeId and Language.[Parameter.LiveOddType].LanguageId=@LangId 
								where Live.[Parameter.Odds].OddsId=@ParameterOddId

							if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
							 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
							 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue  )  
							 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and  (LiveEventOdd.OddValue is not null and OddValue>1) and LiveEventOdd.IsActive=1 
							  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0)
									begin --Live da odd hala aktif mi diye bakılıyor
										select @OddValue=ISNULL(OddValue,1.01 )
										from @TLiveEventOdd as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
										and LiveEventOdd.OddValue>1
										 --and IsEvaluated IS NULL and OddResult is null  
											
										--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
										--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
										--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) and OddValue is not null and IsActive=1
										--and LiveEventDetail.BetStatus=2
										--set @OddKey=1.10
										set @probodd=((1/@OddValue))
											select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

											set @IsLive=1
											set @IsActive=1

											if(@OddValue>9.90)
											begin
												set @IsActive=0
												set @Reason='Keine Quoten.           Cashout nicht moglich'
											end
									end
						   else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.MatchId=LiveEventDetail.EventId where LiveEventDetail.BetStatus=2 and LiveEventDetail.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 ) or (@StateId=3) 
									begin --Live da odd sonuçlanmış mı 
										select @OddValue=case when LiveEventOddResult.OddResult=1 then 1 else 0 end from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
											
										 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Keine Quoten.           Cashout nicht moglich'

											if(@OddValue=1 or (@StateId=3) )
												begin
												 set @probodd=1
													set @IsWon=1
													set @IsActive=1
												end
 

											  
									end
										else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue  )  
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
										
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
												declare @activetimestatu int
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatu=TimeStatu
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

													if(@Fark=@ActiveFark)
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
													if (@OddTypeId=18 and @activetimestatu<3)
													begin
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
														 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and IsActive=1  and LiveEventOdd.OddValue>1
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @OddValue=  case when OddValue>0 then ISNULL(OddValue,1.01) else 1.01 end,@TimeStatu=TimeStatu
																from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
								
															 
																set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9)
																begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																end

													end
															else
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


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Keine Quoten.           Cashout nicht moglich'
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															end
														end
												end
									else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
												begin

													set @OddTypeId=708

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
													set @SpecialBetValue=null

													select @OddValue=OddValue,@TimeStatu=TimeStatu
													from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
													and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													and LiveEventDetail.BetStatus=2   and LiveEventOdd.OddValue>1
													
													if (@OddValue is not null and @OddValue>1)
													begin
													--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
													--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
													--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													--and LiveEventDetail.BetStatus=2  
													--set @OddKey=1.10
													set @probodd=((1/@OddValue))
														select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9)
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
															set @Reason='Keine Quoten.           Cashout nicht moglich'
														end
												end
										 end
										 
							  else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId  and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (708,20))
										  begin --Tip oynanmış ancak müşterinin oranı artık kapanmış
										
														SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@timestatu2=TimeStatu
														 from  @TLiveEvenDetail as LiveEventDetail  
														WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														
													if(@MatchScore<>'' and @MatchScore is not null)
													begin
														select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)

														set @ActiveGoal=@ActiveHomeScore+@ActiveAwayScore

														--set @CustomerTotalGoal=cast( SUBSTRING(@SpecialBetValue,0, CHARINDEX('.', @SpecialBetValue)) as int)
													 
															if((@ParameterOddId=3400 and @ActiveHomeScore>@ActiveAwayScore) or (@ParameterOddId=3402 and @ActiveAwayScore>@ActiveHomeScore)  or (@ParameterOddId=57 and @ActiveAwayScore>@ActiveHomeScore and @timestatu2<3) or (@ParameterOddId=55 and @ActiveHomeScore>@ActiveAwayScore  and @timestatu2<3) )
														begin
													 

															set @OddValue= 1.01
															
														 if(@OddValue<1.2 and @OddValue>1.01)
															set @OddValue= @OddValue
 
												--set @OddKey=1.10
												set @probodd=((1/@OddValue))
												set @Oldprobodd=((1/@CustomerOddValue))
												select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
													select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

													set @IsLive=1
													set @IsActive=1
												
														if(@OddValue*1.05>4)
															begin
															set @IsActive=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															end
													end
													else -- Odd aktif degil
													begin
							
														set @IsLive=1
														set @IsActive=0
														 set @probodd=0
														 set @Reason='Keine Quoten.           Cashout nicht moglich'
														 --	set @OddKey=1.10
														 set @Oldprobodd=((1/@CustomerOddValue))/100
														select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
													end
												end
												else -- Odd aktif degil
													begin
							
														set @IsLive=1
														set @IsActive=0
														 set @probodd=0
														 set @Reason='Keine Quoten.           Cashout nicht moglich'
														 	---set @OddKey=1.10
														 set @Oldprobodd=((1/@CustomerOddValue))
														select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
													end
										  end
							   --else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										-- @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										-- and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										--  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										--  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 )
										--  begin --Oran kapanmış 1.01 olduğu içinse
										
										--		select @OddValue= OddValue
										--from @TLiveEventOdd as LiveEventOdd
										--where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue or SpecialBetValue is null) 
									
								
										--				 if(@OddValue<1.2 and @OddValue>=1.01)
										--				 begin
										--					set @OddValue= @OddValue
										
										--		--set @OddKey=1.10
										--		set @probodd=((1/@OddValue))
										--		--set @Oldprobodd=((1/@CustomerOddValue))
										--		select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										--			select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

										--			set @IsLive=1
										--			set @IsActive=1
												
										--				if(@OddValue*1.05>4)
										--				begin
										--					set @IsActive=0
										--					set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				end
										--					end
										--		else -- Odd aktif degil
										--			begin
							
										--				set @IsLive=1
										--				set @IsActive=0
										--				set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				 set @probodd=0
										--				 	---set @OddKey=1.10
										--				 set @Oldprobodd=((1/@CustomerOddValue))
										--				select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
										--			end
										--  end
								else -- Odd aktif değil
									begin
										set @IsLive=1
										set @IsActive=0
										 set @probodd=0
										set @Reason='Keine Quoten.           Cashout nicht moglich'
												 --set @probodd=1
													--set @IsWon=1
													--set @IsActive=1
										



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
		--select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId where BetradarMatchId=@BetradarMatchId and CategoryId=654 
		
			select @Outcome=Live.[Parameter.Odds].Outcomes from Live.[Parameter.Odds] with (nolock) where OddsId=@ParameterOddId
			select @OddType=Language.[Parameter.LiveOddType].ShortOddType from Language.[Parameter.LiveOddType] with (nolock)   where Language.[Parameter.LiveOddType].LanguageId=@LangId and  Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId

			if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId INNER JOIN Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId where BetradarMatchId=@BetradarMatchId and (Parameter.Category.CategoryId=654 or Parameter.Category.SportId=6 ))
			begin
								if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
								 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddValue>1 and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  
								 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and  (LiveEventOdd.OddValue is not null) and LiveEventOdd.IsActive=1
								  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0)
									begin --Live da odd hala aktif mi diye bakılıyor
								
										select @OddValue=OddValue,@TimeStatu=TimeStatu
										from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue  ) 
										and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
								
										--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
										--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
										--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) and OddValue is not null and IsActive=1
										--and LiveEventDetail.BetStatus=2
										--set @OddKey=1.10
										set @probodd=((1/@OddValue))
										  
										select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
										 
											set @IsLive=1
											set @IsActive=1

												if(@OddValue>9.9)
													begin
													set @IsActive=0
													set @Reason='Cashout nur moglich bis Quote 9,90'
													end

									end
								
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId 
								where LiveEventDetail.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   
								and LiveEventDetail.BetStatus=2   and  (LiveEventOdd.OddValue is not null) and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  
								and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 )  or (@StateId=3)  
								begin --Live Odd sonuçlanmış mı
									select @OddValue= case when LiveEventOddResult.OddResult=1 then 1 else 0 end
										from @TLiveEventOdd as LiveEventOdd  INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
 
									 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Keine Quoten.           Cashout nicht moglich'

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
										 and LiveEventDetail.BetStatus=2  and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
										
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
												declare @activetimestatuu int
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

													if(@Fark=@ActiveFark)
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
														 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and IsActive=1 -- and LiveEventOdd.OddValue>1
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @OddValue=  case when OddValue>0 then ISNULL(OddValue,1.01) else 1.01 end,@TimeStatu=TimeStatu
																from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 --and LiveEventOdd.OddValue>1
								
															 
															 
																set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	end
													end
															else
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


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Keine Quoten.           Cashout nicht moglich'
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															end
														end
												end
									else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
												begin
													if (@OddTypeId=3)
														set @OddTypeId=708
												 

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


													set @SpecialBetValue=null

													
													select @OddValue=OddValue,@TimeStatu=TimeStatu
													from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
													and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													and LiveEventDetail.BetStatus=2   and LiveEventOdd.OddValue>1
												 
													if (@OddValue is not null and @OddValue>1)
													begin
													--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
													--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
													--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													--and LiveEventDetail.BetStatus=2  
													--set @OddKey=1.10
													set @probodd=((1/@OddValue))
														select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9)
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
															set @Reason='Keine Quoten.           Cashout nicht moglich'
														end
												end
										 end
								--else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
								--		 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
								--		 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue)  
								--		 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
								--		  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (709))
								--		  begin --  OddType Handicap ise restsite a çevriliyor.
										
								--				select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
											 
								--				SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatuu=TimeStatu
								--								 from  @TLiveEvenDetail as LiveEventDetail  
								--								WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
								--							if(@MatchScore<>'' and @MatchScore is not null)
								--							begin
								--								select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
								--								if @ActiveHomeScore>=@ActiveAwayScore
								--									set @ActiveFark=@ActiveHomeScore-@ActiveAwayScore
								--								else if @ActiveAwayScore>@ActiveHomeScore
								--										set @ActiveFark=@ActiveAwayScore-@ActiveHomeScore
								--								else
								--									set @ActiveFark=0
								--							end

								--							if (@HomeScore>=@AwayScore)
								--								begin
								--								set @Fark=@HomeScore-@AwayScore
								--								--set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
								--								--set @OddTypeId=709

								--								end
								--							else if (@AwayScore>@HomeScore)
								--								begin
								--									set @Fark=@AwayScore-@HomeScore
								--									--set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
								--									--set @OddTypeId=709
								--								end

								--					declare @GenelFark int

								--					if (@Fark>@ActiveFark)
								--					begin
								--					set @GenelFark=@Fark-@ActiveFark
								--					--set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
								--					--set @OddTypeId=709

								--					end
								--				else if (@ActiveFark>@Fark)
								--					begin
								--						set @GenelFark=@ActiveFark-@Fark
								--						--set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
								--						--set @OddTypeId=709
								--					end

								--				if(@GenelFark)=1
								--				begin
								--					set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
								--						set @OddTypeId=3
								--					if(@ParameterOddId=3403)
								--						set @ParameterOddId=6
								--					else if(@ParameterOddId=3404)
								--						set @ParameterOddId=7
								--					else if(@ParameterOddId=3405)
								--						set @ParameterOddId=8

								--					if(@Fark=@ActiveFark)
								--						begin
								--						set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
								--						set @OddTypeId=3
								--						end
												
											 
								--					--select @EventName,@SpecialBetValue,@Outcome,@OddTypeId
								--						if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
								--						 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
								--						 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
								--						 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and IsActive=1 
								--						 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
								--						 )
								--							begin

								--								select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
								--								from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
								--								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
								--								and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue) 
								--								and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
								
															 
								--								set @probodd=((1/@OddValue))
								--									select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

								--								set @IsLive=1
								--								set @IsActive=1

								--							if(@OddValue>9.9)
								--							begin
								--									set @IsActive=0
								--									set @Reason='Cashout nur moglich bis Quote 9,90'
								--									end
								--					end
													 
								--				end
							
								--		 end
								--else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
								--		 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
								--		 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
								--		 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
								--		  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
								--		  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (710,134))
								--		  begin 
										   
								--						SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
								--						 from  @TLiveEvenDetail as LiveEventDetail  
								--						WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														
								--					if(@MatchScore<>'' and @MatchScore is not null)
								--					begin
								--						select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)

								--						set @ActiveGoal=@ActiveHomeScore+@ActiveAwayScore

								--						set @CustomerTotalGoal=cast( SUBSTRING(@SpecialBetValue,0, CHARINDEX('.', @SpecialBetValue)) as int)
																																						
								--						if((@ParameterOddId=3407 and @CustomerTotalGoal>=@ActiveGoal) or (@ParameterOddId=3406 and @CustomerTotalGoal<@ActiveGoal) or (@ParameterOddId=479 and  @CustomerTotalGoal>=@ActiveHomeScore) )
								--						begin
													 

								--							select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
								--				from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
								--				 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
								--				and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  --and LiveEventOdd.IsActive=1
								--				and LiveEventDetail.BetStatus=2 
															
								--						 if(@OddValue<1.2 and @OddValue>1.01)
								--							set @OddValue= 1.01

								--				--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
								--				--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
								--				-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
								--				--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
								--				--and LiveEventDetail.BetStatus=2
								--				--set @OddKey=1.10
								--				set @probodd=((1/@OddValue))
								--					select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

								--					set @IsLive=1
								--					set @IsActive=1
												
								--						if(@OddValue*1.05>4)
								--						begin
								--							set @IsActive=0
								--							set @Reason='Keine Quoten.           Cashout nicht moglich'
								--						end
								--					end
								--					else -- Odd aktif degil
								--					begin
							
								--						set @IsLive=1
								--						set @IsActive=0
								--						 set @probodd=0
								--						  set @OddValue=0
								--						set @Reason='Keine Quoten.           Cashout nicht moglich'
								--					end
								--				end
								--				else -- Odd aktif degil
								--					begin
							
								--						set @IsLive=1
								--						set @IsActive=0
								--						 set @probodd=0
								--						 set @OddValue=0
								--						 set @Reason='Keine Quoten.           Cashout nicht moglich'
										
								--					end
								--		  end
										 --   else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 --@TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 --where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 --and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										 -- and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										 -- and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (708,20))
										 -- begin 
										   
											--			SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@timestatu2=TimeStatu
											--			 from  @TLiveEvenDetail as LiveEventDetail  
											--			WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														
											--		if(@MatchScore<>'' and @MatchScore is not null)
											--		begin
											--			select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)

											--			set @ActiveGoal=@ActiveHomeScore+@ActiveAwayScore

											--			--set @CustomerTotalGoal=cast( SUBSTRING(@SpecialBetValue,0, CHARINDEX('.', @SpecialBetValue)) as int)
													 
											--				if((@ParameterOddId=3400 and @ActiveHomeScore>@ActiveAwayScore) or (@ParameterOddId=3402 and @ActiveAwayScore>@ActiveHomeScore)  or (@ParameterOddId=57 and @ActiveAwayScore>@ActiveHomeScore and @timestatu2<3) or (@ParameterOddId=55 and @ActiveHomeScore>@ActiveAwayScore  and @timestatu2<3) )
											--			begin
													 

											--				set @OddValue= 1.01
															
											--			 if(@OddValue<1.2 and @OddValue>1.01)
											--				set @OddValue= @OddValue
 
											--	--set @OddKey=1.10
											--	set @probodd=((1/@OddValue))
											--	set @Oldprobodd=((1/@CustomerOddValue))
											--	select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
											--		select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

											--		set @IsLive=1
											--		set @IsActive=1
												
											--			if(@OddValue*1.05>4)
											--			begin
											--				set @IsActive=0
											--				set @Reason='Keine Quoten.           Cashout nicht moglich'
											--			end
											--		end
											--		else -- Odd aktif degil
											--		begin
							
											--			set @IsLive=1
											--			set @IsActive=0
											--			 set @probodd=0
											--			 set @OddValue=0
											--			set @Reason='Keine Quoten.           Cashout nicht moglich'
											--			 	--set @OddKey=1.10
											--			 set @Oldprobodd=((1/@CustomerOddValue))
											--			select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
											--		end
											--	end
											--	else -- Odd aktif degil
											--		begin
							
											--			set @IsLive=1
											--			set @IsActive=0
											--			 set @probodd=0
											--			  set @OddValue=0
											--			set @Reason='Keine Quoten.           Cashout nicht moglich'
											--			 	--set @OddKey=1.10
											--			 set @Oldprobodd=((1/@CustomerOddValue))
											--			select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
											--		end
										 -- end
										--  else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										-- @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										-- and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										--  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										--  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 )
										--  begin --Oran kapanmış 1.01 olduğu içinse
										
										--		select @OddValue= OddValue
										--from @TLiveEventOdd as LiveEventOdd
										--where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue or SpecialBetValue is null) 
									
								
										--				 if(@OddValue<1.2 and @OddValue>=1.01)
										--				 begin
										--					set @OddValue= @OddValue
										
										--		--set @OddKey=1.10
										--		set @probodd=((1/@OddValue))
										--		--set @Oldprobodd=((1/@CustomerOddValue))
										--		select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										--			select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

										--			set @IsLive=1
										--			set @IsActive=1
												
										--				if(@OddValue*1.05>4)
										--				begin
										--					set @IsActive=0
										--					set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				end
										--					end
										--		else -- Odd aktif degil
										--			begin
							
										--				set @IsLive=1
										--				set @IsActive=0
										--				 set @probodd=0
										--				  set @OddValue=0
										--				 set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				 	---set @OddKey=1.10
										--				 set @Oldprobodd=((1/@CustomerOddValue))
										--				select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
										--			end
										--  end
								else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										 set @probodd=0
										  set @OddValue=0
										set @Reason='Keine Quoten.           Cashout nicht moglich'
										
								    end
					end
			else
				begin
				set @IsActive=0
			    set @Reason='Keine Quoten.           Cashout nicht moglich'
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

	if(@StateId in (2,3))
		begin
		if @StateId=3
			begin
			set @OddValue=1
			set @IsWon=1
			set @Reason='Gewonnen'
			if @BetType=1
				select @OddType=Language.[Parameter.LiveOddType].ShortOddType from Language.[Parameter.LiveOddType] with (nolock)   where Language.[Parameter.LiveOddType].LanguageId=@LangId and  Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId
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

			if(@Score='' or @Score is null)
				begin
						SELECT  top 1 @Score= case when ArchiveLiveEventDetail.MatchTime is not null then  cast( ArchiveLiveEventDetail.MatchTime as nvarchar(50)) + ''' -' + RTRIM(ArchiveLiveEventDetail.Score) else case when Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId>1 then cast(Language.[Parameter.LiveTimeStatu].TimeStatu as nvarchar(10))+ ' - ' + RTRIM(ArchiveLiveEventDetail.Score) else '-' end end 
						,@LegScore=LegScore,@ActiveSportTime=MatchTime,@TimeStatu=ArchiveLiveEventDetail.TimeStatu
						from @TArchiveLiveEvenDetail as ArchiveLiveEventDetail  LEFT OUTER JOIN
						Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId = ArchiveLiveEventDetail.TimeStatu
						WHERE        (ArchiveLiveEventDetail.BetradarMatchId = @BetradarMatchId) AND (Language.[Parameter.LiveTimeStatu].LanguageId = 6)
					end
			if @Score is null or @Score=''
						set @Score='-'
					 
				if(@Remaningtime<@Remaningtime2)
					set @Remaningtime2=@Remaningtime

						select @OddProfitfactor=FactorValue from Parameter.CashoutProfitFactor with (nolock)  where ProfitValue1<@OddValue and ProfitValue2>=@OddValue
						select  @LegScore=cast(ISNULL(COUNT(*),0) as nvarchar(20)) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=2
						select  @Remaningtime2=ISNULL(COUNT(*),0) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=1

					insert @TempTable
					select @SlipOddId,@OddValue,@Remaningtime2,@IsActive,@IsLive,@Amount,@Score,@LegScore,@EventName,@CustomerOddValue,@CustomerOutCome,case when @CustomerSpecialBetValue<>'-1' then @CustomerSpecialBetValue else '' end,@OddType,@EventDate,case when @OddValue=1 then  STR(@CustomerOddValue, 25, 2)   else STR(@OddValue, 25, 2) end,@IsWon,0,@OddProfitfactor,@BetradarMatchId,@EventId,@Banko,@probodd,case when @Reason='' then 'Cashout Aktiv' else @Reason end

		end
							fetch next from cur111 into @SlipOddId, @OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore
			
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
						if exists (select OddId from @TempTable where IsWon=1)
									begin
									select @ReelValue=EXP(SUM(LOG(CustomerOddValue)))*MAX(Amount) from @TempTable where IsWon=1
										if exists (select OddId from @TempTable where IsWon=0) --Eğer kuponda kazanan event varsa ve hala kazanmayan başka bir event varsa cashoutkey düşürülüyor.
											set @CashOutKey=0.95
									end
									else
										set @CashOutKey=0.95

					
					select @TotalOddValue=EXP(SUM(LOG(OddValue))),@CurrentOddValue=EXP(SUM(LOG(CustomerOddValue))),@ProfitFactor=EXP(SUM(LOG(ProfitFactor))) from @TempTable   where OddValue>0
					Begin TRY
						select @TotalProb=EXP(SUM(LOG(OddProb))) from @TempTable   where OddValue>0
					end try
					BEGIN CATCH 
						set @TotalProb=0
					END CATCH 
						
						
						--set @LayRate=(@ProfitFactor*@TotalOddValue)
						
						--if(@LayRate>1)
						--set @LayRate=@LayRate+5

						--set @CashOut=case when @LayRate<=1000 then ((@Amount*@CurrentOddValue)/@ReelValue)*(@ReelValue/@LayRate) else 0 end
						--set @CashOut=(@CurrentOddValue*@Amount*@TotalProb) --*@CashOutKey
						--if(select COUNT(*) from @TempTable)=1
							set @CashOut=(@CurrentOddValue*@Amount*@TotalProb) --*@CashOutKey
						--else
						--set @CashOut=(@CurrentOddValue*@Amount/(@TotalOddValue))*0.81 --*@CashOutKey


					--select @CurrentOddValue as CurrentOddValue,@TotalOddValue as TotalOdd,@ProfitFactor As ProfitFactor,@Amount as Amount,@ReelValue as RealValue,@LayRate as LayRate,@CashOut as CashOutOffer
						if(@CashOut>@CurrentOddValue*@Amount)
							set @CashOut=(@CurrentOddValue*@Amount) 
					end
					else if not exists (select OddId from @TempTable where IsActive=0)   and (select COUNT(*) from @TempTable)>0 and (select COUNT(*) from @TempTable where EvenDate<GETDATE())=0
					begin
						set @CashOut=@Amount
					end
					else
						set @CashOut=0

						
						
						--if(@CashOut<2.00)
						--begin
						--set @CashOut=0

						--end

						update @TempTable set CashOutValue=@CashOut

				select DISTINCT cast(0 as bigint) as OddId ,OddValue ,RemaningTime ,IsActive ,IsLive ,Amount ,Score ,LegScore ,EventName ,CustomerOddValue ,OutCome ,SpecialBetValue,OddType ,EvenDate ,MatchTime ,IsWon ,CashOutValue ,ProfitFactor,BetradarMatchId,EventId ,Banko,case when Reason='' then 'Cashout Aktiv' else Reason  end  as Reason 
					from @TempTable Order by EvenDate,BetradarMatchId
end
else if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId<3 and SlipStateId=1  and (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0   )
	begin


insert @TempSlip
SELECT    Customer.SlipOdd.BetradarMatchId
	FROM         
						  Customer.SlipOdd with (nolock) 
	WHERE     (Customer.SlipOdd.SlipId = @SlipId) AND (Customer.SlipOdd.BetTypeId in (1,0))

	
		insert into @TLiveEvent
			select Live.[Event].BetradarMatchId,Live.[Event].EventId,Live.[Event].ConnectionStatu,TournamentId from Live.[Event] with (nolock) INNER JOIN @TempSlip as TS ON Live.[Event].BetradarMatchId=TS.BetradarMatchId

		insert into @TLiveEvenDetail
			select Live.EventDetail.EventId,Live.EventDetail.BetStatus,Live.EventDetail.TimeStatu,Live.EventDetail.BetradarMatchIds,MatchTime,Score,LegScore from Live.EventDetail with (nolock) INNER JOIN @TempSlip as TS ON Live.EventDetail.BetradarMatchIds=TS.BetradarMatchId

			insert into @TArchiveLiveEvenDetail
			select Archive.[Live.EventDetail].EventId,Archive.[Live.EventDetail].BetStatus,Archive.[Live.EventDetail].TimeStatu,Archive.[Live.EventDetail].BetradarMatchIds,MatchTime,Score,LegScore from Archive.[Live.EventDetail] with (nolock) INNER JOIN @TempSlip as TS ON Archive.[Live.EventDetail].BetradarMatchIds=TS.BetradarMatchId

		insert into @TLiveEventOdd
		select Live.EventOdd.BetradarMatchId,Live.EventOdd.MatchId,Live.EventOdd.ParameterOddId,Live.EventOdd.OutCome,Live.EventOdd.SpecialBetValue,Live.EventOdd.IsEvaluated,Live.EventOdd.OddResult,Live.EventOdd.IsCanceled,Live.EventOdd.OddValue,Live.EventOdd.OddId,Live.EventOdd.IsActive,Live.EventOdd.OddsTypeId 
		from Live.[EventOdd] with (nolock) INNER JOIN @TempSlip as TS ON Live.EventOdd.BetradarMatchId=TS.BetradarMatchId

		insert into @TLiveEventOddResult
		select [BettingLive].Live.[EventOddResult].BetradarMatchId,[BettingLive].Live.[EventOddResult].OutCome,case when  [BettingLive].Live.[EventOddResult].SpecialBetValue is null then '' else [BettingLive].Live.[EventOddResult].SpecialBetValue end
		,[BettingLive].Live.[EventOddResult].IsEvaluated,[BettingLive].Live.[EventOddResult].OddResult,[BettingLive].Live.[EventOddResult].IsCanceled,[BettingLive].Live.[EventOddResult].OddId
		from [BettingLive].Live.[EventOddResult] with (nolock) -- INNER JOIN @TempSlip as TMP On Live.[EventOddResult].BetradarMatchId=TMP.BetradarMatchId 
		 where [BettingLive].Live.[EventOddResult].BetradarMatchId in (Select BetradarMatchId from @TempSlip)
			
											 

set nocount on
					declare cur11122 cursor local for(
					select SlipOddId,OddValue,Customer.Slip.Amount,BetTypeId,OutCome,MatchId,ParameterOddId,SpecialBetValue ,EventDate,SportId,customer.SlipOdd.StateId,EventName,OddsTypeId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.MatchId,Customer.SlipOdd.Banko,Customer.SlipOdd.Score
					from Customer.SlipOdd with (nolock) INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.SlipOdd.SlipId
					where Customer.SlipOdd.SlipId=@SlipId and Customer.Slip.SlipStateId=1
					
						)

					open cur11122
					fetch next from cur11122 into @SlipOddId,@OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore
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
							set @LegScore=''
							  set @probodd=0
							 --set @OddKey=0
							set @LiveEventId=null
							set @IsLive=@BetType
							set @IsActive=0
							set @CustomerSpecialBetValue=@SpecialBetValue
							set @Reason='Cashout aktiv'
							--if(@OddTypeId=1481)
							--set @SpecialBetValue='-1'

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
				 ----select @OddKey=SUM(1/(OddValue))
					----					from Match.Odd with (nolock) 
					----					 where MatchId=@MatchId and OddsTypeId=@OddTypeId
					----					and   ( SpecialBetValue=@SpecialBetValue or  SpecialBetValue is null) 
										-- set @OddKey=1.10
										set @probodd=((1/@CustomerOddValue))
											select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd


											if exists (select Match.Match.BetradarMatchId from Match.Match with (nolock) INNER JOIN Parameter.Tournament with (nolock) On Match.TournamentId=Parameter.Tournament.TournamentId and CategoryId=654 and BetradarMatchId=@BetradarMatchId)
													begin
													set @IsActive=0
													set @Reason='Keine Cashout für E-Sports'
													end
			end				
		else --Pre Match Başlamış
			begin
			 
				
				
				if exists (select BetradarMatchId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId  )  --Event Live da varmı diye bakılıyor
					if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId where BetradarMatchId=@BetradarMatchId and CategoryId=654 )
					begin
		 
						select @LiveEventId=EventId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId   --Live Event Id alınıyor
			
						if exists (select OddsId from Parameter.Odds with (nolock) where OddsId=@ParameterOddId and LiveOddId is not null) --Pre oynanan marketin liveda karşılığı varmı diye bakılıyor
							begin
						 
								select @ParameterOddId=LiveOddId,@Outcome=LiveOutcome 
								from Parameter.Odds with (nolock) where OddsId=@ParameterOddId

									if(@ParameterOddId in (26,27,28))
									set @SpecialBetValue='0:0'

									--	if(@ParameterOddId in (80,81,82))
									--set @SpecialBetValue='-1' 


								select  @OddTypeId=Live.[Parameter.Odds].OddTypeId 
								from Language.[Parameter.LiveOddType] with (nolock) INNER JOIN 
								Live.[Parameter.Odds] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.Odds].OddTypeId and Language.[Parameter.LiveOddType].LanguageId=@LangId 
								where Live.[Parameter.Odds].OddsId=@ParameterOddId

							if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
							 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
							 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
							 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and  (LiveEventOdd.OddValue is not null) and LiveEventOdd.IsActive=1
							  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0)
									begin --Live da odd hala aktif mi diye bakılıyor
										select @OddValue=ISNULL(OddValue,1.01 )
										from @TLiveEventOdd as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue) 
										and LiveEventOdd.OddValue>1 --and IsEvaluated IS NULL and OddResult is null  
											
										--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
										--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
										--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) and OddValue is not null and IsActive=1
										--and LiveEventDetail.BetStatus=2
										--set @OddKey=1.10
										set @probodd=((1/@OddValue))
											select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

											set @IsLive=1
											set @IsActive=1

											if(@OddValue>9.90)
											begin
												set @IsActive=0
												set @Reason='Keine Quoten.           Cashout nicht moglich'
											end
									end
						   else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.MatchId=LiveEventDetail.EventId where LiveEventDetail.BetStatus=2 and LiveEventDetail.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 ) or (@StateId=3) 
									begin --Live da odd sonuçlanmış mı 
										select @OddValue=case when LiveEventOddResult.OddResult=1 then 1 else 0 end from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
											
										 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Keine Quoten.           Cashout nicht moglich'

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
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
										
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
												declare @activetimestatu22 int
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatu22=TimeStatu
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

													if(@Fark=@ActiveFark)
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
													if (@OddTypeId=18 and @activetimestatu22<3)
													begin
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
														and LiveEventOdd.OddValue>1 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and IsActive=1 
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
																from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OddValue>1 and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2
								
															 
																set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9)
																begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																end

													end
															else
															begin
																SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
																 from  @TLiveEvenDetail as LiveEventDetail  
																WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
															if(@MatchScore<>'' and @MatchScore is not null)
															begin
																select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
																set @ActiveAwayFark=0
																set @ActiveHomeFark=0
																if(@ActiveHomeScore>@HomeScore)
																	set @ActiveHomeFark=@ActiveHomeScore-@HomeScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveHomeFark=@HomeScore-@ActiveHomeScore

																if(@ActiveAwayScore>@AwayScore)
																	set @ActiveAwayFark=@ActiveAwayScore-@AwayScore
																else if (@HomeScore>@ActiveHomeScore)
																	set @ActiveAwayFark=@AwayScore-@ActiveAwayScore


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Keine Quoten.           Cashout nicht moglich'
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															end
														end
												end
									else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
												begin

													set @OddTypeId=708

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
													set @SpecialBetValue=null

													
													select @OddValue=OddValue,@TimeStatu=TimeStatu
													from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
													and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													and LiveEventDetail.BetStatus=2   and LiveEventOdd.OddValue>1
													
													if (@OddValue is not null and @OddValue>1)
													begin
													--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
													--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
													--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													--and LiveEventDetail.BetStatus=2  
													--set @OddKey=1.10
													set @probodd=((1/@OddValue))
														select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9)
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
															set @Reason='Keine Quoten.           Cashout nicht moglich'
														end
												end
										 end
										 
							  else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (708,20))
										  begin --Tip oynanmış ancak müşterinin oranı artık kapanmış
										
														SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@timestatu2=TimeStatu
														 from  @TLiveEvenDetail as LiveEventDetail  
														WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														
													if(@MatchScore<>'' and @MatchScore is not null)
													begin
														select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)

														set @ActiveGoal=@ActiveHomeScore+@ActiveAwayScore

														--set @CustomerTotalGoal=cast( SUBSTRING(@SpecialBetValue,0, CHARINDEX('.', @SpecialBetValue)) as int)
													 
															if((@ParameterOddId=3400 and @ActiveHomeScore>@ActiveAwayScore) or (@ParameterOddId=3402 and @ActiveAwayScore>@ActiveHomeScore)  or (@ParameterOddId=57 and @ActiveAwayScore>@ActiveHomeScore and @timestatu2<3) or (@ParameterOddId=55 and @ActiveHomeScore>@ActiveAwayScore  and @timestatu2<3) )
														begin
													 

															set @OddValue= 1.01
															
														 if(@OddValue<1.2 and @OddValue>1.01)
															set @OddValue= @OddValue
 
												--set @OddKey=1.10
												set @probodd=((1/@OddValue))
												set @Oldprobodd=((1/@CustomerOddValue))
												select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
													select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

													set @IsLive=1
													set @IsActive=1
												
														if(@OddValue*1.05>4)
															begin
															set @IsActive=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															end
													end
													else -- Odd aktif degil
													begin
							
														set @IsLive=1
														set @IsActive=0
														 set @probodd=0
														 set @Reason='Keine Quoten.           Cashout nicht moglich'
														 --	set @OddKey=1.10
														 set @Oldprobodd=((1/@CustomerOddValue))/100
														select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
													end
												end
												else -- Odd aktif degil
													begin
							
														set @IsLive=1
														set @IsActive=0
														 set @probodd=0
														 set @Reason='Keine Quoten.           Cashout nicht moglich'
														 	---set @OddKey=1.10
														 set @Oldprobodd=((1/@CustomerOddValue))
														select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
													end
										  end
							   --else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										-- @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										-- and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										--  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										--  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 )
										--  begin --Oran kapanmış 1.01 olduğu içinse
										
										--		select @OddValue= OddValue
										--from @TLiveEventOdd as LiveEventOdd
										--where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue or SpecialBetValue is null) 
									
								
										--				 if(@OddValue<1.2 and @OddValue>=1.01)
										--				 begin
										--					set @OddValue= @OddValue
										
										--		--set @OddKey=1.10
										--		set @probodd=((1/@OddValue))
										--		--set @Oldprobodd=((1/@CustomerOddValue))
										--		select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										--			select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

										--			set @IsLive=1
										--			set @IsActive=1
												
										--				if(@OddValue*1.05>4)
										--				begin
										--					set @IsActive=0
										--					set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				end
										--					end
										--		else -- Odd aktif degil
										--			begin
							
										--				set @IsLive=1
										--				set @IsActive=0
										--				set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				 set @probodd=0
										--				 	---set @OddKey=1.10
										--				 set @Oldprobodd=((1/@CustomerOddValue))
										--				select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
										--			end
										--  end
								else -- Odd aktif değil
									begin
										set @IsLive=1
										set @IsActive=0
										 set @probodd=0
										set @Reason='Keine Quoten.           Cashout nicht moglich'
												 --set @probodd=1
													--set @IsWon=1
													--set @IsActive=1
										



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
		--select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId where BetradarMatchId=@BetradarMatchId and CategoryId=654 
		
			select @Outcome=Live.[Parameter.Odds].Outcomes from Live.[Parameter.Odds] with (nolock) where OddsId=@ParameterOddId
			select @OddType=Language.[Parameter.LiveOddType].ShortOddType from Language.[Parameter.LiveOddType] with (nolock)   where Language.[Parameter.LiveOddType].LanguageId=@LangId and  Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId
			if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId where BetradarMatchId=@BetradarMatchId and CategoryId=654 )
			begin
								if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
								 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
								 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and  (LiveEventOdd.OddValue is not null) and LiveEventOdd.IsActive=1
								  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0)
									begin --Live da odd hala aktif mi diye bakılıyor
								
										select @OddValue=OddValue,@TimeStatu=TimeStatu
										from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
										and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
								
										--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
										--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
										--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) and OddValue is not null and IsActive=1
										--and LiveEventDetail.BetStatus=2
										--set @OddKey=1.10
										set @probodd=((1/@OddValue))
										  
										select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
										 
											set @IsLive=1
											set @IsActive=1

												if(@OddValue>9.9)
													begin
													set @IsActive=0
													set @Reason='Cashout nur moglich bis Quote 9,90'
													end

									end
								
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId 
								where LiveEventDetail.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   
								and LiveEventDetail.BetStatus=2   and  (LiveEventOdd.OddValue is not null) and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  
								and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 )  or (@StateId=3)  
								begin --Live Odd sonuçlanmış mı
									select @OddValue= case when LiveEventOddResult.OddResult=1 then 1 else 0 end
										from @TLiveEventOdd as LiveEventOdd  INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
 
									 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Keine Quoten.           Cashout nicht moglich'

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
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
										
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
												declare @activetimestatuu33 int
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatuu33=TimeStatu
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

													if(@Fark=@ActiveFark)
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
													if (@OddTypeId=18 and @activetimestatuu33<3)
													begin
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
														 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and IsActive=1 
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
																from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
								
															 
																set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																	end
													end
															else
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


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Keine Quoten.           Cashout nicht moglich'
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															end
														end
												end
									else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
												begin
													if (@OddTypeId=3)
														set @OddTypeId=708
												 

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


													set @SpecialBetValue=null

												
													select @OddValue=OddValue,@TimeStatu=TimeStatu
													from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
													and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													and LiveEventDetail.BetStatus=2   and LiveEventOdd.OddValue>1
													
													if (@OddValue is not null and @OddValue>1)
													begin
													--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
													--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
													--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													--and LiveEventDetail.BetStatus=2  
													--set @OddKey=1.10
													set @probodd=((1/@OddValue))
														select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9)
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
															set @Reason='Keine Quoten.           Cashout nicht moglich'
														end
												end
										 end
								--else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
								--		 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
								--		 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
								--		 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
								--		  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (709))
								--		  begin --  OddType Handicap ise restsite a çevriliyor.
										
								--				select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
											 
								--				SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@activetimestatuu33=TimeStatu
								--								 from  @TLiveEvenDetail as LiveEventDetail  
								--								WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														 
								--							if(@MatchScore<>'' and @MatchScore is not null)
								--							begin
								--								select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)
								--								if @ActiveHomeScore>=@ActiveAwayScore
								--									set @ActiveFark=@ActiveHomeScore-@ActiveAwayScore
								--								else if @ActiveAwayScore>@ActiveHomeScore
								--										set @ActiveFark=@ActiveAwayScore-@ActiveHomeScore
								--								else
								--									set @ActiveFark=0
								--							end

								--							if (@HomeScore>=@AwayScore)
								--								begin
								--								set @Fark=@HomeScore-@AwayScore
								--								--set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
								--								--set @OddTypeId=709

								--								end
								--							else if (@AwayScore>@HomeScore)
								--								begin
								--									set @Fark=@AwayScore-@HomeScore
								--									--set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
								--									--set @OddTypeId=709
								--								end

								--					declare @GenelFark2 int

								--					if (@Fark>@ActiveFark)
								--					begin
								--					set @GenelFark2=@Fark-@ActiveFark
								--					--set @SpecialBetValue='0:'+cast(@Fark as nvarchar(3))
								--					--set @OddTypeId=709

								--					end
								--				else if (@ActiveFark>@Fark)
								--					begin
								--						set @GenelFark2=@ActiveFark-@Fark
								--						--set @SpecialBetValue=cast(@Fark as nvarchar(3))+':0'
								--						--set @OddTypeId=709
								--					end

								--				if(@GenelFark2)=1
								--				begin
								--					set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
								--						set @OddTypeId=3
								--					if(@ParameterOddId=3403)
								--						set @ParameterOddId=6
								--					else if(@ParameterOddId=3404)
								--						set @ParameterOddId=7
								--					else if(@ParameterOddId=3405)
								--						set @ParameterOddId=8

								--					if(@Fark=@ActiveFark)
								--						begin
								--						set @SpecialBetValue=cast(@ActiveHomeScore as nvarchar(3))+':'+cast(@ActiveAwayScore as nvarchar(3))
								--						set @OddTypeId=3
								--						end
												
											 
								--					--select @EventName,@SpecialBetValue,@Outcome,@OddTypeId
								--						if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
								--						 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
								--						 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
								--						 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and IsActive=1 
								--						 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
								--						 )
								--							begin

								--								select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
								--								from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
								--								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
								--								and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
								--								and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
								
															 
								--								set @probodd=((1/@OddValue))
								--									select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

								--								set @IsLive=1
								--								set @IsActive=1

								--							if(@OddValue>9.9)
								--							begin
								--									set @IsActive=0
								--									set @Reason='Cashout nur moglich bis Quote 9,90'
								--									end
								--					end
													 
								--				end
							
								--		 end
								--else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
								--		 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
								--		 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
								--		 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
								--		  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
								--		  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (710,134))
								--		  begin 
										   
								--						SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
								--						 from  @TLiveEvenDetail as LiveEventDetail  
								--						WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														
								--					if(@MatchScore<>'' and @MatchScore is not null)
								--					begin
								--						select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)

								--						set @ActiveGoal=@ActiveHomeScore+@ActiveAwayScore

								--						set @CustomerTotalGoal=cast( SUBSTRING(@SpecialBetValue,0, CHARINDEX('.', @SpecialBetValue)) as int)
													 
								--						if((@ParameterOddId=3407 and @CustomerTotalGoal>=@ActiveGoal) or (@ParameterOddId=3406 and @CustomerTotalGoal<=@ActiveGoal) or (@ParameterOddId=479 and  @CustomerTotalGoal>=@ActiveHomeScore) )
								--						begin
													 

								--							select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
								--				from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
								--				 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
								--				and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
								--				and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
															
								--						 if(@OddValue<1.2 and @OddValue>1.01)
								--							set @OddValue= 1.01

								--				--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
								--				--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
								--				-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
								--				--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
								--				--and LiveEventDetail.BetStatus=2
								--				--set @OddKey=1.10
								--				set @probodd=((1/@OddValue))
								--					select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

								--					set @IsLive=1
								--					set @IsActive=1
												
								--						if(@OddValue*1.05>4)
								--						begin
								--							set @IsActive=0
								--							set @Reason='Keine Quoten.           Cashout nicht moglich'
								--						end
								--					end
								--					else -- Odd aktif degil
								--					begin
							
								--						set @IsLive=1
								--						set @IsActive=0
								--						 set @probodd=0
								--						  set @OddValue=0
								--						set @Reason='Keine Quoten.           Cashout nicht moglich'
								--					end
								--				end
								--				else -- Odd aktif degil
								--					begin
							
								--						set @IsLive=1
								--						set @IsActive=0
								--						 set @probodd=0
								--						 set @OddValue=0
								--						 set @Reason='Keine Quoten.           Cashout nicht moglich'
										
								--					end
								--		  end
										    else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (708,20))
										  begin 
										   
														SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@timestatu2=TimeStatu
														 from  @TLiveEvenDetail as LiveEventDetail  
														WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														
													if(@MatchScore<>'' and @MatchScore is not null)
													begin
														select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)

														set @ActiveGoal=@ActiveHomeScore+@ActiveAwayScore

														--set @CustomerTotalGoal=cast( SUBSTRING(@SpecialBetValue,0, CHARINDEX('.', @SpecialBetValue)) as int)
													 
															if((@ParameterOddId=3400 and @ActiveHomeScore>@ActiveAwayScore) or (@ParameterOddId=3402 and @ActiveAwayScore>@ActiveHomeScore)  or (@ParameterOddId=57 and @ActiveAwayScore>@ActiveHomeScore and @timestatu2<3) or (@ParameterOddId=55 and @ActiveHomeScore>@ActiveAwayScore  and @timestatu2<3) )
														begin
													 

															set @OddValue= 1.01
															
														 if(@OddValue<1.2 and @OddValue>1.01)
															set @OddValue= @OddValue
 
												--set @OddKey=1.10
												set @probodd=((1/@OddValue))
												set @Oldprobodd=((1/@CustomerOddValue))
												select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
													select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

													set @IsLive=1
													set @IsActive=1
												
														if(@OddValue*1.05>4)
														begin
															set @IsActive=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
														end
													end
													else -- Odd aktif degil
													begin
							
														set @IsLive=1
														set @IsActive=0
														 set @probodd=0
														 set @OddValue=0
														set @Reason='Keine Quoten.           Cashout nicht moglich'
														 	--set @OddKey=1.10
														 set @Oldprobodd=((1/@CustomerOddValue))
														select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
													end
												end
												else -- Odd aktif degil
													begin
							
														set @IsLive=1
														set @IsActive=0
														 set @probodd=0
														  set @OddValue=0
														set @Reason='Keine Quoten.           Cashout nicht moglich'
														 	--set @OddKey=1.10
														 set @Oldprobodd=((1/@CustomerOddValue))
														select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
													end
										  end
										--  else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										-- @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										-- and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										--  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										--  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 )
										--  begin --Oran kapanmış 1.01 olduğu içinse
										
										--		select @OddValue= OddValue
										--from @TLiveEventOdd as LiveEventOdd
										--where BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddValue>1 and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue or SpecialBetValue is null) 
									
								
										--				 if(@OddValue<1.2 and @OddValue>=1.01)
										--				 begin
										--					set @OddValue= @OddValue
										
										--		--set @OddKey=1.10
										--		set @probodd=((1/@OddValue))
										--		--set @Oldprobodd=((1/@CustomerOddValue))
										--		select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										--			select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

										--			set @IsLive=1
										--			set @IsActive=1
												
										--				if(@OddValue*1.05>4)
										--				begin
										--					set @IsActive=0
										--					set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				end
										--					end
										--		else -- Odd aktif degil
										--			begin
							
										--				set @IsLive=1
										--				set @IsActive=0
										--				 set @probodd=0
										--				  set @OddValue=0
										--				 set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				 	---set @OddKey=1.10
										--				 set @Oldprobodd=((1/@CustomerOddValue))
										--				select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
										--			end
										--  end
								else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										 set @probodd=0
										  set @OddValue=0
										set @Reason='Keine Quoten.           Cashout nicht moglich'
										
								    end
					end
			else
				begin
				set @IsActive=0
			    set @Reason='Keine Quoten.           Cashout nicht moglich'
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

	if(@StateId in (2,3))
		begin
		if @StateId=3
			begin
			set @OddValue=1
			set @IsWon=1
			set @Reason='Gewonnen'
			if @BetType=1
				select @OddType=Language.[Parameter.LiveOddType].ShortOddType from Language.[Parameter.LiveOddType] with (nolock)   where Language.[Parameter.LiveOddType].LanguageId=@LangId and  Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId
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

			if(@Score='' or @Score is null)
				begin
						SELECT  top 1 @Score= case when ArchiveLiveEventDetail.MatchTime is not null then  cast( ArchiveLiveEventDetail.MatchTime as nvarchar(50)) + ''' -' + RTRIM(ArchiveLiveEventDetail.Score) else case when Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId>1 then cast(Language.[Parameter.LiveTimeStatu].TimeStatu as nvarchar(10))+ ' - ' + RTRIM(ArchiveLiveEventDetail.Score) else '-' end end 
						,@LegScore=LegScore,@ActiveSportTime=MatchTime,@TimeStatu=ArchiveLiveEventDetail.TimeStatu
						from @TArchiveLiveEvenDetail as ArchiveLiveEventDetail  LEFT OUTER JOIN
						Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId = ArchiveLiveEventDetail.TimeStatu
						WHERE        (ArchiveLiveEventDetail.BetradarMatchId = @BetradarMatchId) AND (Language.[Parameter.LiveTimeStatu].LanguageId = 6)
					end
			if @Score is null or @Score=''
						set @Score='-'
					 
				if(@Remaningtime<@Remaningtime2)
					set @Remaningtime2=@Remaningtime

						select @OddProfitfactor=FactorValue from Parameter.CashoutProfitFactor where ProfitValue1<@OddValue and ProfitValue2>=@OddValue
							select  @Remaningtime2=ISNULL(COUNT(*),0) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=1

									select  @LegScore=cast(ISNULL(COUNT(*),0) as nvarchar(20)) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=2


					insert @TempTable
					select @SlipOddId,@OddValue,@Remaningtime2,@IsActive,@IsLive,@Amount,@Score,@LegScore,@EventName,@CustomerOddValue,@CustomerOutCome,case when @CustomerSpecialBetValue<>'-1' then @CustomerSpecialBetValue else '' end,@OddType,@EventDate,case when @OddValue=1 then  STR(@CustomerOddValue, 25, 2)   else STR(@OddValue, 25, 2) end,@IsWon,0,@OddProfitfactor,@BetradarMatchId,@EventId,@Banko,@probodd,case when @Reason='' then 'Cashout Aktiv' else @Reason end

		end
							fetch next from cur11122 into @SlipOddId, @OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore
			
						end
					close cur11122
					deallocate cur11122


					
					if not exists (select OddId from @TempTable where IsActive=0) and (select COUNT(*) from @TempTable)>0 and ((Select Count(*) from @TempTable where IsLive=1)>0 or (Select Count(*) from @TempTable where IsWon=1)>0)
					begin

					set @TotalOddValue =0
					set @ProfitFactor =1
					set @ReelValue =@Amount
					set @LayRate =0
					 set @TotalProb =0
					set @CurrentOddValue =0
						if exists (select OddId from @TempTable where IsWon=1)
									begin
									select @ReelValue=EXP(SUM(LOG(CustomerOddValue)))*MAX(Amount) from @TempTable where IsWon=1
										if exists (select OddId from @TempTable where IsWon=0) --Eğer kuponda kazanan event varsa ve hala kazanmayan başka bir event varsa cashoutkey düşürülüyor.
											set @CashOutKey=0.95
									end
									else
										set @CashOutKey=0.95

					
					select @TotalOddValue=EXP(SUM(LOG(OddValue))),@CurrentOddValue=EXP(SUM(LOG(CustomerOddValue))),@ProfitFactor=EXP(SUM(LOG(ProfitFactor))) from @TempTable   where OddValue>0
					Begin TRY
						select @TotalProb=EXP(SUM(LOG(OddProb))) from @TempTable   where OddValue>0
					end try
					BEGIN CATCH 
						set @TotalProb=0
					END CATCH 
						
						
						--set @LayRate=(@ProfitFactor*@TotalOddValue)
						
						--if(@LayRate>1)
						--set @LayRate=@LayRate+5

						--set @CashOut=case when @LayRate<=1000 then ((@Amount*@CurrentOddValue)/@ReelValue)*(@ReelValue/@LayRate) else 0 end
						--set @CashOut=(@CurrentOddValue*@Amount*@TotalProb) --*@CashOutKey
						--if(select COUNT(*) from @TempTable)=1
							set @CashOut=(@CurrentOddValue*@Amount*@TotalProb) --*@CashOutKey
						--else
						--set @CashOut=(@CurrentOddValue*@Amount/(@TotalOddValue))*0.81 --*@CashOutKey


					--select @CurrentOddValue as CurrentOddValue,@TotalOddValue as TotalOdd,@ProfitFactor As ProfitFactor,@Amount as Amount,@ReelValue as RealValue,@LayRate as LayRate,@CashOut as CashOutOffer
						if(@CashOut>@CurrentOddValue*@Amount)
							set @CashOut=(@CurrentOddValue*@Amount) 
					end
					else if not exists (select OddId from @TempTable where IsActive=0)   and (select COUNT(*) from @TempTable)>0 and (select COUNT(*) from @TempTable where EvenDate<GETDATE())=0
					begin
						set @CashOut=@Amount
					end
					else
						set @CashOut=0

						
						
						--if(@CashOut<2.00)
						--begin
						--set @CashOut=0

						--end

						update @TempTable set CashOutValue=@CashOut

				select DISTINCT cast(0 as bigint) as OddId ,OddValue ,RemaningTime ,IsActive ,IsLive ,Amount ,Score ,LegScore ,EventName ,CustomerOddValue ,OutCome ,SpecialBetValue,OddType ,EvenDate ,MatchTime ,IsWon ,CashOutValue ,ProfitFactor,BetradarMatchId,EventId ,Banko,case when Reason='' then 'Cashout Aktiv' else Reason  end  as Reason 
					from @TempTable Order by EvenDate,BetradarMatchId
end
 else if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=4 and (Select COUNT(Customer.SlipSystem.SystemSlipId) from Customer.SlipSystem with (nolock) where SystemSlipId=(select Top 1 SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId) and SlipStateId=1)>0  and  (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0		 and (Select Count(Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId )<25   )
	begin

declare @Systems nvarchar(300)
	declare @SystemGain money					
		insert into @TempSlip
		SELECT DISTINCT Customer.SlipOdd.BetradarMatchId
							FROM	Customer.SlipOdd with (nolock) 
							WHERE  (Customer.SlipOdd.SlipId=@SlipId) and (Customer.SlipOdd.BetTypeId in (0,1))

insert into @TLiveEvent
			select Live.[Event].BetradarMatchId,EventId,ConnectionStatu,TournamentId 
			from Live.[Event] with (nolock) INNER JOIN @TempSlip as TS ON Live.[Event].BetradarMatchId=TS.BetradarMatchId


insert into @TLiveEvenDetail
			select Live.EventDetail.EventId,Live.EventDetail.BetStatus,Live.EventDetail.TimeStatu,Live.EventDetail.BetradarMatchIds,MatchTime,Score,LegScore from Live.EventDetail with (nolock)
			 INNER JOIN @TempSlip as TS ON Live.EventDetail.BetradarMatchIds=TS.BetradarMatchId

			insert into @TArchiveLiveEvenDetail
			select Archive.[Live.EventDetail].EventId,Archive.[Live.EventDetail].BetStatus,Archive.[Live.EventDetail].TimeStatu
			,Archive.[Live.EventDetail].BetradarMatchIds,MatchTime,Score,LegScore 
			from Archive.[Live.EventDetail] with (nolock) INNER JOIN @TempSlip as TS ON Archive.[Live.EventDetail].BetradarMatchIds=TS.BetradarMatchId

 
			insert into @TLiveEventOdd
		select Live.EventOdd.BetradarMatchId,Live.EventOdd.MatchId,Live.EventOdd.ParameterOddId,Live.EventOdd.OutCome,case when  Live.EventOdd.SpecialBetValue is null then '' else Live.EventOdd.SpecialBetValue end ,Live.EventOdd.IsEvaluated,Live.EventOdd.OddResult,Live.EventOdd.IsCanceled,Live.EventOdd.OddValue,Live.EventOdd.OddId,Live.EventOdd.IsActive,Live.EventOdd.OddsTypeId 
		from Live.[EventOdd] with (nolock) INNER JOIN @TempSlip as TS ON Live.EventOdd.BetradarMatchId=TS.BetradarMatchId

		insert into @TLiveEventOddResult
		select [BettingLive].Live.[EventOddResult].BetradarMatchId,[BettingLive].Live.[EventOddResult].OutCome,case when  [BettingLive].Live.[EventOddResult].SpecialBetValue is null then '' else [BettingLive].Live.[EventOddResult].SpecialBetValue end
		,[BettingLive].Live.[EventOddResult].IsEvaluated,[BettingLive].Live.[EventOddResult].OddResult,[BettingLive].Live.[EventOddResult].IsCanceled,[BettingLive].Live.[EventOddResult].OddId
		from [BettingLive].Live.[EventOddResult] with (nolock) -- INNER JOIN @TempSlip as TMP On Live.[EventOddResult].BetradarMatchId=TMP.BetradarMatchId 
		 where [BettingLive].Live.[EventOddResult].BetradarMatchId in (Select BetradarMatchId from @TempSlip)
declare @CouponCount int

		select @SlipSystemCashOut=Customer.SlipSystem.Amount,@SystemAmount=Customer.SlipSystem.Amount,@Systems=Customer.SlipSystem.[System],@SystemGain=MaxGain,@CouponCount=CouponCount from Customer.SlipSystem with (nolock) where SystemSlipId=(select top 1 CSS.SystemSlipId from Customer.SlipSystemSlip as CSS with (nolock) where CSS.SlipId=@SlipId )

set @IsCashout=1
set @SystemCashOut=0 
set nocount on
					declare cur111 cursor local for(
					select SlipOddId,OddValue,Customer.Slip.Amount,BetTypeId,OutCome,MatchId,ParameterOddId,case when  SpecialBetValue is null then '' else  SpecialBetValue end  ,EventDate,SportId,customer.SlipOdd.StateId,EventName,OddsTypeId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.MatchId,Customer.SlipOdd.Banko,Customer.SlipOdd.Score
					from Customer.SlipOdd with (nolock) INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.SlipOdd.SlipId
					where Customer.SlipOdd.SlipId=@SlipId and Customer.Slip.SlipStateId=1
					
						)

					open cur111
					fetch next from cur111 into @SlipOddId,@OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore
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
						 --set @OddKey=1
							set @LiveEventId=null
							set @IsLive=@BetType
							set @IsActive=0
							set @Reason=''
							set @ActiveHomeFark=0
							set @ActiveAwayFark=0
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
			--	 select @OddKey=SUM(1/(@CustomerOddValue))
								
										 
										set @probodd=((1/@CustomerOddValue))
											select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
											set @Oldprobodd=@probodd

												 if(@CustomerOddValue>9.90)
												 begin
													set @IsActive=0
													set @Reason='Cashout nur moglich bis Quote 9,90'
												end
												if exists (select Match.Match.BetradarMatchId from Match.Match with (nolock) INNER JOIN Parameter.Tournament with (nolock) On Match.TournamentId=Parameter.Tournament.TournamentId and CategoryId=654 and BetradarMatchId=@BetradarMatchId)
													begin
													set @IsActive=0
													set @Reason='Keine Cashout für E-Sports'
													end
			end	
		else --Pre Match Başlamış
			begin
			 
				
				
				if exists (select BetradarMatchId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId  ) --Event Live da varmı diye bakılıyor
				if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId where BetradarMatchId=@BetradarMatchId and CategoryId=654 )
					begin
		 
						select @LiveEventId=EventId,@EventId=EventId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId   --Live Event Id alınıyor
			
						if exists (select OddsId from Parameter.Odds with (nolock) where OddsId=@ParameterOddId and LiveOddId is not null) --Pre oynanan marketin liveda karşılığı varmı diye bakılıyor
							begin
						 
								select @ParameterOddId=LiveOddId,@Outcome=LiveOutcome 
								from Parameter.Odds with (nolock) where OddsId=@ParameterOddId

								if(@ParameterOddId in (26,27,28))
									set @SpecialBetValue='0:0'

									--	if(@ParameterOddId in (80,81,82))
									--set @SpecialBetValue='-1'
				 

								select @OddType=Language.[Parameter.LiveOddType].ShortOddType,@OddTypeId=Live.[Parameter.Odds].OddTypeId 
								from Language.[Parameter.LiveOddType] with (nolock) INNER JOIN 
								Live.[Parameter.Odds] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.Odds].OddTypeId and Language.[Parameter.LiveOddType].LanguageId=@LangId 
								where Live.[Parameter.Odds].OddsId=@ParameterOddId

							if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
							 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
							 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
							 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and  (LiveEventOdd.OddValue is not null) and LiveEventOdd.IsActive=1
							  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0)
									begin --Live da odd hala aktif mi diye bakılıyor
										select @OddValue=ISNULL(OddValue,1.01 )
										from @TLiveEventOdd as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
										and LiveEventOdd.OddValue>1 --and IsEvaluated IS NULL and OddResult is null  
											
										--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
										--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
										--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) and OddValue is not null and IsActive=1
										--and LiveEventDetail.BetStatus=2
										--set @OddKey=1.10
										set @probodd=((1/@OddValue))
										set @Oldprobodd=((1/@CustomerOddValue))
										select top 1 @Oldprobodd=ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
											select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
											

											set @IsLive=1
											set @IsActive=1

											if(@OddValue>9.90)
												begin
												set @Reason='Cashout nur moglich bis Quote 9,90'
												set @IsActive=0
												end
 
									end
						   else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.MatchId=LiveEventDetail.EventId where LiveEventDetail.BetStatus=2 and LiveEventDetail.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 ) or (@StateId=3) 
									begin --Live da odd sonuçlanmış mı 
										select @OddValue=case when LiveEventOddResult.OddResult=1 then 1 else 0 end from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
											
										 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Oldprobodd=((1/@CustomerOddValue))
										select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
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
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8))
										   begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
												set @ActiveFark =-1
											 
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
												
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
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

													if(@Fark=@ActiveFark)
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
													if (@OddTypeId=18 and @activetimestatu<3)
													begin
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
														 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and IsActive=1 
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
																from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
								
															 
																set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
															end
													end
															else
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


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Keine Quoten.           Cashout nicht moglich'
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															end
														end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
												begin

													set @OddTypeId=708

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
													set @SpecialBetValue=null

													select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
													from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
													and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													and LiveEventDetail.BetStatus=2  and LiveEventOdd.OddValue>1
													
													if (@OddValue is not null and @OddValue>1)
													begin
													--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
													--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
													--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													--and LiveEventDetail.BetStatus=2  
													--set @OddKey=1.10
													set @probodd=((1/@OddValue))
														select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9)
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
															set @Reason='Keine Quoten.           Cashout nicht moglich'
														end
												end
										 end
										
										    else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (708,20))
										  begin 
										   
														SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@timestatu2=TimeStatu
														 from  @TLiveEvenDetail as LiveEventDetail  
														WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														
													if(@MatchScore<>'' and @MatchScore is not null)
													begin
														select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)

														set @ActiveGoal=@ActiveHomeScore+@ActiveAwayScore

														--set @CustomerTotalGoal=cast( SUBSTRING(@SpecialBetValue,0, CHARINDEX('.', @SpecialBetValue)) as int)
													 
															if((@ParameterOddId=3400 and @ActiveHomeScore>@ActiveAwayScore) or (@ParameterOddId=3402 and @ActiveAwayScore>@ActiveHomeScore)  or (@ParameterOddId=57 and @ActiveAwayScore>@ActiveHomeScore and @timestatu2<3) or (@ParameterOddId=55 and @ActiveHomeScore>@ActiveAwayScore  and @timestatu2<3) )
														begin
													 

															set @OddValue= 1.01
															
														 if(@OddValue<1.2 and @OddValue>1.01)
															set @OddValue= @OddValue 
 
												--set @OddKey=1.10
												set @probodd=((1/@OddValue))
												set @Oldprobodd=((1/@CustomerOddValue))
												select top 1 @Oldprobodd=ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
													select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

													set @IsLive=1
													set @IsActive=1
												
														if(@OddValue*1.05>4)
														begin
															set @IsActive=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
														end
													end
													else -- Odd aktif degil
													begin
							
														set @IsLive=1
														set @IsActive=0
														set @Reason='Keine Quoten.           Cashout nicht moglich'
														 set @probodd=0
														 	--set @OddKey=1.10
														 set @Oldprobodd=0
										
													end
												end
												else -- Odd aktif degil
													begin
							
														set @IsLive=1
														set @IsActive=0
														set @Reason='Keine Quoten.           Cashout nicht moglich'
														 set @probodd=0
														-- 	set @OddKey=1.10
														 set @Oldprobodd=0
										
													end
										  end
										--  else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										-- @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										-- and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										--  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										--  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 )
										--  begin --Oran kapanmış 1.01 olduğu içinse
										
										--		select @OddValue= OddValue
										--from @TLiveEventOdd as LiveEventOdd
										--where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue or SpecialBetValue is null) 
									
								
										--				 if(@OddValue<1.2 and @OddValue>=1.01)
										--				 begin
										--					set @OddValue= @OddValue
										
										--		--set @OddKey=1.10
										--		set @probodd=((1/@OddValue))
										--		--set @Oldprobodd=((1/@CustomerOddValue))
										--		select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										--			select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

										--			set @IsLive=1
										--			set @IsActive=1
												
										--				if(@OddValue*1.05>4)
										--				begin
										--					set @IsActive=0
										--					set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				end
										--					end
										--		else -- Odd aktif degil
										--			begin
							
										--				set @IsLive=1
										--				set @IsActive=0
										--				set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				 set @probodd=0
										--				 	---set @OddKey=1.10
										--				 set @Oldprobodd=((1/@CustomerOddValue))
										--				select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
										--			end
										--  end
								else -- Odd aktif değil
									begin
										--set @OddKey=1.10
										set @IsLive=1
										set @IsActive=0
										set @Reason='Keine Quoten.           Cashout nicht moglich'
										 set @probodd=0
										 set @Oldprobodd=((1/@CustomerOddValue))
										select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
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
						 set @probodd=0
						-- 	set @OddKey=1.10
						 set @Oldprobodd=0
					end
				else --Event Liveda yok
					begin
						set @IsLive=0
						set @IsActive=0
						set @Reason='Dieses Spiel ist nicht als Livewette verfügbar'
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
			if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId where BetradarMatchId=@BetradarMatchId and CategoryId=654 )
			begin
								if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
								 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
								 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and  (LiveEventOdd.OddValue is not null) and LiveEventOdd.IsActive=1
								  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0)
									begin --Live da odd hala aktif mi diye bakılıyor
								
										select @OddValue=OddValue,@TimeStatu=TimeStatu
										from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
										and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
								
										--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
										--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
										--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) and OddValue is not null and IsActive=1
										--and LiveEventDetail.BetStatus=2
										--set @OddKey=1.10
										set @probodd=((1/@OddValue))
										  set @Oldprobodd=((1/@CustomerOddValue))
										select top 1 @Oldprobodd=ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

									 
										 
											set @IsLive=1
											set @IsActive=1

												if(@OddValue>9.9)
												begin
													set @IsActive=0
													set @Reason='Cashout nur moglich bis Quote 9,90'
												end
									end
								
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId 
								where LiveEventDetail.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   
								and LiveEventDetail.BetStatus=2   and  (LiveEventOdd.OddValue is not null) and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  
								and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 )  or (@StateId=3)  
								begin --Live Odd sonuçlanmış mı
									select @OddValue= case when LiveEventOddResult.OddResult=1 then 1 else 0 end
										from @TLiveEventOdd as LiveEventOdd  INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
 
									 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
											set @Reason='Keine Quoten.           Cashout nicht moglich'
												if(@OddValue=1 or @StateId=3)
												begin
													set @probodd=1
													--set @OddKey=1.10
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
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 and @ParameterOddId in (6,7,8))
										 begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
												set @ActiveFark =-1
											 
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
												
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
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

													if(@Fark=@ActiveFark)
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
													if (@OddTypeId=18 and @activetimestatu<3)
													begin
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
														 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and IsActive=1 
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
																from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
								
															 
																set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9)
																begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																end

													end
														else
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


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Keine Quoten.           Cashout nicht moglich'
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															end
														end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
												begin

													set @OddTypeId=708

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

													set @SpecialBetValue=null

													select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
													from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
													and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													and LiveEventDetail.BetStatus=2   and LiveEventOdd.OddValue>1
													
													if (@OddValue is not null and @OddValue>1)
													begin
													--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
													--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
													--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													--and LiveEventDetail.BetStatus=2  
													--set @OddKey=1.10
													set @probodd=((1/@OddValue))
														select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
															end
													end
													else
														begin
															set @IsLive=1
															set @IsActive=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															set @probodd=0
														end
												end
										 end
									
										 --	else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 --@TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 --where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 --and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										 -- and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										 -- and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (710,134))
										 -- begin 
										   
											--			SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
											--			 from  @TLiveEvenDetail as LiveEventDetail  
											--			WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														
											--		if(@MatchScore<>'' and @MatchScore is not null)
											--		begin
											--			select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)

											--			set @ActiveGoal=@ActiveHomeScore+@ActiveAwayScore

											--			set @CustomerTotalGoal=cast( SUBSTRING(@SpecialBetValue,0, CHARINDEX('.', @SpecialBetValue)) as int)
													 
											--			if((@ParameterOddId=3407 and @CustomerTotalGoal>=@ActiveGoal) or (@ParameterOddId=3406 and @CustomerTotalGoal<=@ActiveGoal) or (@ParameterOddId=479 and  @CustomerTotalGoal>=@ActiveHomeScore) )
											--			begin
													 

											--				select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
											--	from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
											--	 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
											--	and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
											--	and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
															
											--			 if(@OddValue<1.2 and @OddValue>1.01)
											--				set @OddValue= @OddValue 

											--	--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
											--	--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
											--	-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
											--	--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
											--	--and LiveEventDetail.BetStatus=2
											--	--set @OddKey=1.10
											--	set @probodd=((1/@OddValue))
											--	set @Oldprobodd=((1/@CustomerOddValue))
											--	select top 1 @Oldprobodd=ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
											--		select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

											--		set @IsLive=1
											--		set @IsActive=1
												
											--			if(@OddValue*1.05>4)
											--			begin
											--				set @IsActive=0
											--				set @Reason='Keine Quoten.           Cashout nicht moglich'
											--			end
											--		end
											--		else -- Odd aktif degil
											--		begin
							
											--			set @IsLive=1
											--			set @IsActive=0
											--			set @Reason='Keine Quoten.           Cashout nicht moglich'
											--			 set @probodd=0
											--			 --	set @OddKey=1.10
											--			 set @Oldprobodd=0
										
											--		end
											--	end
											--	else -- Odd aktif degil
											--		begin
							
											--			set @IsLive=1
											--			set @IsActive=0
											--			set @Reason='Keine Quoten.           Cashout nicht moglich'
											--			 set @probodd=0
											--			-- 	set @OddKey=1.10
											--			 set @Oldprobodd=0
										
											--		end
										 -- end
										    else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (708,20))
										  begin 
										   
														SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@timestatu2=TimeStatu
														 from  @TLiveEvenDetail as LiveEventDetail  
														WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														
													if(@MatchScore<>'' and @MatchScore is not null)
													begin
														select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)

														set @ActiveGoal=@ActiveHomeScore+@ActiveAwayScore

														--set @CustomerTotalGoal=cast( SUBSTRING(@SpecialBetValue,0, CHARINDEX('.', @SpecialBetValue)) as int)
													 
															if((@ParameterOddId=3400 and @ActiveHomeScore>@ActiveAwayScore) or (@ParameterOddId=3402 and @ActiveAwayScore>@ActiveHomeScore)  or (@ParameterOddId=57 and @ActiveAwayScore>@ActiveHomeScore and @timestatu2<3) or (@ParameterOddId=55 and @ActiveHomeScore>@ActiveAwayScore  and @timestatu2<3) )
														begin
													 

															set @OddValue= 1.01
															
														 if(@OddValue<1.2 and @OddValue>1.01)
															set @OddValue= @OddValue 
 
											--	set @OddKey=1.10
												set @probodd=((1/@OddValue))
												set @Oldprobodd=((1/@CustomerOddValue))
												select top 1 @Oldprobodd=ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
													select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

													set @IsLive=1
													set @IsActive=1
												
														if(@OddValue*1.05>4)
														begin
															set @IsActive=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
														end
													end
													else -- Odd aktif degil
													begin
							
														set @IsLive=1
														set @IsActive=0
														set @Reason='Keine Quoten.           Cashout nicht moglich'
														 set @probodd=0
														 	--set @OddKey=1.10
														 set @Oldprobodd=0
										
													end
												end
												else -- Odd aktif degil
													begin
							
														set @IsLive=1
														set @IsActive=0
														set @Reason='Keine Quoten.           Cashout nicht moglich'
														 set @probodd=0
														 --	set @OddKey=1.10
														 set @Oldprobodd=0
													
													end
										  end
										--  else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										-- @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										-- and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										--  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										--  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 )
										--  begin --Oran kapanmış 1.01 olduğu içinse
										
										--		select @OddValue= OddValue
										--from @TLiveEventOdd as LiveEventOdd
										--where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue or SpecialBetValue is null) 
									
								
										--				 if(@OddValue<1.2 and @OddValue>=1.01)
										--				 begin
										--					set @OddValue= @OddValue
										
										--		--set @OddKey=1.10
										--		set @probodd=((1/@OddValue))
										--		--set @Oldprobodd=((1/@CustomerOddValue))
										--		select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										--			select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

										--			set @IsLive=1
										--			set @IsActive=1
												
										--				if(@OddValue*1.05>4)
										--				begin
										--					set @IsActive=0
										--					set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				end
										--					end
										--		else -- Odd aktif degil
										--			begin
							
										--				set @IsLive=1
										--				set @IsActive=0
										--				set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				 set @probodd=0
										--				 	---set @OddKey=1.10
										--				 set @Oldprobodd=((1/@CustomerOddValue))
										--				select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
										--			end
										--  end
								else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										set @Reason='Keine Quoten.           Cashout nicht moglich'
										 set @probodd=0
										 set @Oldprobodd=0
									--	select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
								    end
			end
			else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										set @Reason='Keine Quoten.           Cashout nicht moglich'
										 set @probodd=0
										 set @Oldprobodd=0
									--	select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
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

	if(@StateId in (2,3))
		begin
			if @StateId=3
			begin
			set @OddValue=1
			set @IsWon=1
			set @Reason='Gewonnen'
			end
		else
			begin
			set @OddValue=0
			set @IsWon=0
			end
			set @IsActive=1
			set @IsLive=@BetType
			set @probodd=1
			set @Oldprobodd=((1/@CustomerOddValue))
										select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
		 
		end
	else
		begin
			if(@StateId<>4)
				begin
				set @IsActive=0
				set @Reason='Keine Quoten.           Cashout nicht moglich'
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
						SELECT  top 1 @Score= case when  LiveEventDetail.MatchTime is not null then  cast(  LiveEventDetail.MatchTime as nvarchar(50)) + ''' -' + RTRIM( LiveEventDetail.Score) else case when Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId>1 then cast(Language.[Parameter.LiveTimeStatu].TimeStatu as nvarchar(10))+ ' - ' + RTRIM( LiveEventDetail.Score) else '-' end end 
						,@LegScore=LegScore,@ActiveSportTime=MatchTime,@TimeStatu=LiveEventDetail.TimeStatu
						 from  @TLiveEvenDetail as LiveEventDetail  LEFT OUTER JOIN
                         Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId =  LiveEventDetail.TimeStatu
						WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId) AND (Language.[Parameter.LiveTimeStatu].LanguageId = 6)
					end

			if(@Score='' or @Score is null)
				begin
						SELECT  top 1 @Score= case when ArchiveLiveEventDetail.MatchTime is not null then  cast( ArchiveLiveEventDetail.MatchTime as nvarchar(50)) + ''' -' + RTRIM(ArchiveLiveEventDetail.Score) else case when Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId>1 then cast(Language.[Parameter.LiveTimeStatu].TimeStatu as nvarchar(10))+ ' - ' + RTRIM(ArchiveLiveEventDetail.Score) else '-' end end 
						,@LegScore=LegScore,@ActiveSportTime=MatchTime,@TimeStatu=ArchiveLiveEventDetail.TimeStatu
						from @TArchiveLiveEvenDetail as ArchiveLiveEventDetail  LEFT OUTER JOIN
						Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId = ArchiveLiveEventDetail.TimeStatu
						WHERE        (ArchiveLiveEventDetail.BetradarMatchId = @BetradarMatchId) AND (Language.[Parameter.LiveTimeStatu].LanguageId = 6)
					end
			if @Score is null or @Score=''
						set @Score='-'
					 
				if(@Remaningtime<@Remaningtime2)
					set @Remaningtime2=@Remaningtime

						select @OddProfitfactor=FactorValue from Parameter.CashoutProfitFactor where ProfitValue1<@OddValue and ProfitValue2>=@OddValue
						select  @Remaningtime2=ISNULL(COUNT(*),0) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=1

						select  @LegScore=cast(ISNULL(COUNT(*),0) as nvarchar(20)) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=2


					insert @TempTableSystem
					select @SlipOddId,@OddValue,@Remaningtime2,@IsActive,@IsLive,@Amount,@Score,@LegScore,@EventName,@CustomerOddValue,@CustomerOutCome,case when @CustomerSpecialBetValue<>'-1' then @CustomerSpecialBetValue else '' end,@OddType,@EventDate,case when @OddValue=1 then  STR(@CustomerOddValue, 25, 2)   else STR(@OddValue, 25, 2) end,@IsWon,0,@OddProfitfactor,@BetradarMatchId,@EventId,@Banko,@probodd*@CustomerOddValue,1,case when @Reason='' then 'Cashout Aktiv' else @Reason end


		end
							fetch next from cur111 into @SlipOddId, @OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore
			
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
		declare @CustomerOdds nvarchar(300)=''
		declare @say int=0
		declare @BankoOddValue float =1
		declare @BankoCustomerOddValue float =1
		 declare @pf float
		 declare @Oldpf float
		 declare @IsBanko int
		 declare @CustomerSlipOdd float
  

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
							
							 
									 
													 if ((Select Count(*) from @TempTableSystem where IsActive=1 and OddProb>0)>=@SystemCount)
												 begin
														set @BankoOddValue=1
															set nocount on
																	declare cur11123 cursor local for(
																	select OddProb,Banko,CustomerOddValue From @TempTableSystem where IsActive=1 and OddProb>0

																		)

																	open cur11123
																	fetch next from cur11123 into @pf,@IsBanko,@CustomerSlipOdd
																	while @@fetch_status=0
																		begin
																			begin
																				if(@IsBanko=0)
																					begin
																					set @Odds=@Odds+cast(@pf as nvarchar(10))+';'
																					set @CustomerOdds=@CustomerOdds+cast(@CustomerSlipOdd as nvarchar(10))+';'
																					end
																				else
																				begin
																				--set @Odds=@Odds+cast('1' as nvarchar(10))+';'
																					set @BankoOddValue=@BankoOddValue*@pf
																					set @BankoCustomerOddValue=@BankoCustomerOddValue*@CustomerSlipOdd
																					end
																			end
																			fetch next from cur11123 into @pf,@IsBanko,@CustomerSlipOdd
			
																		end
																	close cur11123
																	deallocate cur11123
																	if(Len(@Odds)>1)
																	begin
																	set @Odds=SUBSTRING(@Odds,1,LEN(@Odds)-1)
																	set @CustomerOdds=SUBSTRING(@CustomerOdds,1,LEN(@CustomerOdds)-1)
																	--select @SystemCount,@Odds,@Amount
															
																	--select @WinAmountReel=[RiskManagement].[FuncSlipSystemEvaluateCashOut]   (@SystemCount,@CustomerOdds,@Amount)
																	--select @WinAmountReel
																	select @WinAmount=[RiskManagement].[FuncSlipSystemEvaluateCashOut]   (@SystemCount,@Odds,@Amount)
																	--set @WinAmount=@WinAmount*@BankoOddValue
																	set @TotalWinAmount=@TotalWinAmount+ (@WinAmount)
																	--set @TotalWinAmountReel=@TotalWinAmountReel+ (@WinAmountReel*@WinAmount)
																	--select @SystemCount,@Odds,@Amount,@WinAmount
																	--select @TotalWinAmount,@SystemCount,@WinAmountReel,@CustomerOdds
																	set @Odds=''
																	set @CustomerOdds=''
																	end
												end
											 
									 
								 
							 
								 
									end
									fetch next from cur1112 into @SystemCount
			
								end
							close cur1112
							deallocate cur1112




							--set @TotalOddValue =0
							--set @ProfitFactor =1
							--set @ReelValue =@Amount
							--set @LayRate =0
							-- set @TotalProb =0
							--set @CurrentOddValue =0
							--	if exists (select OddId from @TempTableSystem where IsWon=1)
							--				begin
							--				select @ReelValue=EXP(SUM(LOG(CustomerOddValue)))*MAX(Amount) from @TempTableSystem where IsWon=1
							--					if exists (select OddId from @TempTableSystem where IsWon=0) --Eğer kuponda kazanan event varsa ve hala kazanmayan başka bir event varsa cashoutkey düşürülüyor.
							--						set @CashOutKey=0.95
							--				end
							--				else
							--					set @CashOutKey=0.95

					
							--select @TotalOddValue=EXP(SUM(LOG(OddValue))),@CurrentOddValue=EXP(SUM(LOG(CustomerOddValue))),@ProfitFactor=EXP(SUM(LOG(ProfitFactor))) from @TempTableSystem   where OddValue>0
							--Begin TRY
							--	select @TotalProb=EXP(SUM(LOG(OddProb))) from @TempTableSystem   where OddValue>0
							--end try
							--BEGIN CATCH 
							--	set @TotalProb=0
							--END CATCH 
					 
							-- select @TotalWinAmount
				 
								set @CashOut=@TotalWinAmount
		 


							--	select * from @TempTableSystem

				 
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

						update @TempTableSystem set CashOutValue=@CashOut

				--select DISTINCT cast(0 as bigint) as OddId ,OddValue ,RemaningTime ,IsActive ,IsLive ,Amount ,Score ,LegScore ,EventName ,CustomerOddValue ,OutCome ,SpecialBetValue,OddType ,EvenDate ,MatchTime ,IsWon ,CashOutValue ,ProfitFactor,BetradarMatchId,EventId ,Banko ,Reason
				--	from @TempTableSystem Order by EvenDate,BetradarMatchId
					 	select DISTINCT cast(0 as bigint) as OddId ,OddValue ,RemaningTime ,IsActive ,IsLive ,Amount ,Score ,LegScore ,EventName ,CustomerOddValue ,OutCome ,SpecialBetValue,OddType ,EvenDate ,MatchTime ,IsWon ,CashOutValue ,ProfitFactor,BetradarMatchId,EventId ,Banko,case when Reason='' then 'Cashout Aktiv' else Reason  end  as Reason 
					from @TempTableSystem Order by EvenDate,BetradarMatchId
							--from @TempTableSystem2
						end
 else if exists (Select SlipId from Customer.Slip with (nolock) where SlipId=@SlipId and SlipTypeId=5 and (Select COUNT(Customer.SlipSystem.SystemSlipId) from Customer.SlipSystem with (nolock) where SystemSlipId=(select Top 1 SystemSlipId from Customer.SlipSystemSlip with (nolock) where SlipId=@SlipId) and SlipStateId=1)>0  and  (Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId and BetTypeId  in (2))=0  and (Select Count(Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where SlipId=@SlipId )<25   )
	begin

declare @EventPerBet nvarchar(300)
	declare @MultiGain money					
		insert into @TempSlip
		SELECT DISTINCT Customer.SlipOdd.BetradarMatchId
							FROM	Customer.SlipOdd with (nolock) 
							WHERE  (Customer.SlipOdd.SlipId=@SlipId) and (Customer.SlipOdd.BetTypeId in (0,1))

insert into @TLiveEvent
			select Live.[Event].BetradarMatchId,EventId,ConnectionStatu,TournamentId 
			from Live.[Event] with (nolock) INNER JOIN @TempSlip as TS ON Live.[Event].BetradarMatchId=TS.BetradarMatchId


insert into @TLiveEvenDetail
			select Live.EventDetail.EventId,Live.EventDetail.BetStatus,Live.EventDetail.TimeStatu,Live.EventDetail.BetradarMatchIds,MatchTime,Score,LegScore from Live.EventDetail with (nolock)
			 INNER JOIN @TempSlip as TS ON Live.EventDetail.BetradarMatchIds=TS.BetradarMatchId

			insert into @TArchiveLiveEvenDetail
			select Archive.[Live.EventDetail].EventId,Archive.[Live.EventDetail].BetStatus,Archive.[Live.EventDetail].TimeStatu
			,Archive.[Live.EventDetail].BetradarMatchIds,MatchTime,Score,LegScore 
			from Archive.[Live.EventDetail] with (nolock) INNER JOIN @TempSlip as TS ON Archive.[Live.EventDetail].BetradarMatchIds=TS.BetradarMatchId

 
			insert into @TLiveEventOdd
		select Live.EventOdd.BetradarMatchId,Live.EventOdd.MatchId,Live.EventOdd.ParameterOddId,Live.EventOdd.OutCome,case when  Live.EventOdd.SpecialBetValue is null then '' else Live.EventOdd.SpecialBetValue end ,Live.EventOdd.IsEvaluated,Live.EventOdd.OddResult,Live.EventOdd.IsCanceled,Live.EventOdd.OddValue,Live.EventOdd.OddId,Live.EventOdd.IsActive,Live.EventOdd.OddsTypeId 
		from Live.[EventOdd] with (nolock) INNER JOIN @TempSlip as TS ON Live.EventOdd.BetradarMatchId=TS.BetradarMatchId

		insert into @TLiveEventOddResult
		select Live.[EventOddResult].BetradarMatchId,Live.[EventOddResult].OutCome,case when  Live.[EventOddResult].SpecialBetValue is null then '' else Live.[EventOddResult].SpecialBetValue end,Live.[EventOddResult].IsEvaluated,Live.[EventOddResult].OddResult,Live.[EventOddResult].IsCanceled,Live.[EventOddResult].OddId
		from Live.[EventOddResult] with (nolock) INNER JOIN @TempSlip as TS ON Live.[EventOddResult].BetradarMatchId=TS.BetradarMatchId


		select @SlipSystemCashOut=Customer.SlipSystem.Amount,@SystemAmount=Amount,@EventPerBet=Customer.SlipSystem.[System],@MultiGain=MaxGain from Customer.SlipSystem with (nolock) where SystemSlipId=(select top 1 CSS.SystemSlipId from Customer.SlipSystemSlip as CSS with (nolock) where CSS.SlipId=@SlipId )

set @IsCashout=1
set @SystemCashOut=0 
set nocount on
					declare cur111 cursor local for(
					select SlipOddId,OddValue,Customer.Slip.Amount,BetTypeId,OutCome,MatchId,ParameterOddId,case when  SpecialBetValue is null then '' else  SpecialBetValue end  ,EventDate,SportId,customer.SlipOdd.StateId,EventName,OddsTypeId,Customer.SlipOdd.BetradarMatchId,Customer.SlipOdd.MatchId,Customer.SlipOdd.Banko,Customer.SlipOdd.Score
					from Customer.SlipOdd with (nolock) INNER JOIN Customer.Slip with (nolock) ON Customer.Slip.SlipId=Customer.SlipOdd.SlipId
					where Customer.SlipOdd.SlipId=@SlipId and Customer.Slip.SlipStateId=1
					
						)

					open cur111
					fetch next from cur111 into @SlipOddId,@OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore
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
							-- set @OddKey=0
							set @LiveEventId=null
							set @IsLive=@BetType
							set @IsActive=0
							set @Reason='Cashout Aktiv'
							set @ActiveHomeFark=0
							set @ActiveAwayFark=0
							--if(@OddTypeId=1481)
							--set @SpecialBetValue='-1'

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
				 select @OddKey=SUM(1/(@CustomerOddValue))
								
										 
										set @probodd=((1/@CustomerOddValue) )
											select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
											set @Oldprobodd=@probodd

											if(@CustomerOddValue>9.90)
												begin
												set @IsActive=0
												set @Reason='Cashout nur moglich bis Quote 9,90'
												end

													if exists (select Match.Match.BetradarMatchId from Match.Match with (nolock) INNER JOIN Parameter.Tournament with (nolock) On Match.TournamentId=Parameter.Tournament.TournamentId and CategoryId=654 and BetradarMatchId=@BetradarMatchId)
													begin
													set @Reason='Keine Cashout für E-Sports'
													set @IsActive=0
													end
			end	
		else --Pre Match Başlamış
			begin
			 
				
				
				if exists (select BetradarMatchId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId  ) --Event Live da varmı diye bakılıyor
					if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId where BetradarMatchId=@BetradarMatchId and CategoryId=654 )
					begin
		 
						select @LiveEventId=EventId from @TLiveEvent as LiveEvent where BetradarMatchId=@BetradarMatchId   --Live Event Id alınıyor
			
						if exists (select OddsId from Parameter.Odds with (nolock) where OddsId=@ParameterOddId and LiveOddId is not null) --Pre oynanan marketin liveda karşılığı varmı diye bakılıyor
							begin
						 
								select @ParameterOddId=LiveOddId,@Outcome=LiveOutcome 
								from Parameter.Odds with (nolock) where OddsId=@ParameterOddId

								if(@ParameterOddId in (26,27,28))
									set @SpecialBetValue='0:0'

									--	if(@ParameterOddId in (80,81,82))
									--set @SpecialBetValue='-1'
							 
								select @OddType=Language.[Parameter.LiveOddType].ShortOddType,@OddTypeId=Live.[Parameter.Odds].OddTypeId 
								from Language.[Parameter.LiveOddType] with (nolock) INNER JOIN 
								Live.[Parameter.Odds] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.Odds].OddTypeId and Language.[Parameter.LiveOddType].LanguageId=@LangId 
								where Live.[Parameter.Odds].OddsId=@ParameterOddId

							if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
							 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
							 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
							 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and  (LiveEventOdd.OddValue is not null) and LiveEventOdd.IsActive=1
							  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0)
									begin --Live da odd hala aktif mi diye bakılıyor
										select @OddValue=ISNULL(OddValue,1.01 )
										from @TLiveEventOdd as LiveEventOdd
										where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue ) 
										and LiveEventOdd.OddValue>1 --and IsEvaluated IS NULL and OddResult is null  
											
										--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
										--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
										--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) and OddValue is not null and IsActive=1
										--and LiveEventDetail.BetStatus=2
										--set @OddKey=1.10
										set @probodd=((1/@OddValue) )
										set @Oldprobodd=((1/@CustomerOddValue) )
										select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
											select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
											

											set @IsLive=1
											set @IsActive=1

											if(@OddValue>9.90)
											begin
												set @IsActive=0
												set @Reason='Cashout nur moglich bis Quote 9,90'
											end
 
									end
						   else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.MatchId=LiveEventDetail.EventId where LiveEventDetail.BetStatus=2 and LiveEventDetail.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 ) or (@StateId=3) 
									begin --Live da odd sonuçlanmış mı 
										select @OddValue=case when LiveEventOddResult.OddResult=1 then 1 else 0 end from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
											
										 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0
										--	set @OddKey=1.10
											set @Oldprobodd=((1/@CustomerOddValue))
										select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
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
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0  and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
												set @ActiveFark =-1
											 
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
												
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
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

													if(@Fark=@ActiveFark)
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
													if (@OddTypeId=18 and @activetimestatu<3)
													begin
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
														 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and IsActive=1 
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
																from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
								
															 
																set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9)
																begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																end

													end
														else
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


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Keine Quoten.           Cashout nicht moglich'
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															end
														end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
												begin

													set @OddTypeId=708

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
													set @SpecialBetValue=null

													select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
													from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
													and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													and LiveEventDetail.BetStatus=2   and LiveEventOdd.OddValue>1
													
													if (@OddValue is not null and @OddValue>1)
													begin
													--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
													--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
													--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													--and LiveEventDetail.BetStatus=2  
													--set @OddKey=1.10
													set @probodd=((1/@OddValue))
														select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9)
																begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																end
													end
													else
														begin
															set @IsLive=1
															set @IsActive=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															set @probodd=0
														end
												end
										 end
										--  else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										-- @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										-- and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										--  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										--  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 )
										--  begin --Oran kapanmış 1.01 olduğu içinse
										
										--		select @OddValue= OddValue
										--from @TLiveEventOdd as LiveEventOdd
										--where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue or SpecialBetValue is null) 
									
								
										--				 if(@OddValue<1.2 and @OddValue>=1.01)
										--				 begin
										--					set @OddValue= @OddValue
										
										--		--set @OddKey=1.10
										--		set @probodd=((1/@OddValue))
										--		--set @Oldprobodd=((1/@CustomerOddValue))
										--		select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										--			select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

										--			set @IsLive=1
										--			set @IsActive=1
												
										--				if(@OddValue*1.05>4)
										--				begin
										--					set @IsActive=0
										--					set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				end
										--					end
										--		else -- Odd aktif degil
										--			begin
							
										--				set @IsLive=1
										--				set @IsActive=0
										--				set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				 set @probodd=0
										--				 	---set @OddKey=1.10
										--				 set @Oldprobodd=((1/@CustomerOddValue))
										--				select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
										--			end
										--  end
								else -- Odd aktif değil
									begin
										--set @OddKey=1.10
										set @IsLive=1
										set @IsActive=0
										set @Reason='Keine Quoten.           Cashout nicht moglich'
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
			select @OddType=Language.[Parameter.LiveOddType].ShortOddType from Language.[Parameter.LiveOddType] with (nolock)   where Language.[Parameter.LiveOddType].LanguageId=@LangId and  Language.[Parameter.LiveOddType].OddTypeId=@OddTypeId
				if not exists (select BetradarMatchId from @TLiveEvent as LiveEvent  INNER JOIN Parameter.Tournament with (nolock) on LiveEvent.TournamentId=Parameter.Tournament.TournamentId where BetradarMatchId=@BetradarMatchId and CategoryId=654 )
			begin
								if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
								 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
								 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
								 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and  (LiveEventOdd.OddValue is not null) and LiveEventOdd.IsActive=1
								  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0)
									begin --Live da odd hala aktif mi diye bakılıyor
								
										select @OddValue=OddValue,@TimeStatu=TimeStatu
										from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
										and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
								
										--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
										--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
										--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) and OddValue is not null and IsActive=1
										--and LiveEventDetail.BetStatus=2
										--set @OddKey=1.10
										set @probodd=((1/@OddValue))
										  set @Oldprobodd=((1/@CustomerOddValue))
										select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

									 
										 
											set @IsLive=1
											set @IsActive=1

												if(@OddValue>9.9)
													begin
													set @IsActive=0
													set @Reason='Cashout nur moglich bis Quote 9,90'
													end

									end
								
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId 
								where LiveEventDetail.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )   
								and LiveEventDetail.BetStatus=2   and  (LiveEventOdd.OddValue is not null) and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  
								and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))>0 )  or (@StateId=3)  
								begin --Live Odd sonuçlanmış mı
									select @OddValue= case when LiveEventOddResult.OddResult=1 then 1 else 0 end
										from @TLiveEventOdd as LiveEventOdd  INNER JOIN @TLiveEventOddResult as LiveEventOddResult On LiveEventOdd.OddId=LiveEventOddResult.OddId
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
										and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
 
									 	set @Remaningtime=9999
											set @IsLive=1
											set @IsActive=0

												if(@OddValue=1 or @StateId=3)
												begin
													set @probodd=1
													--set @OddKey=1.10
													set @Oldprobodd=((1/@CustomerOddValue))
													select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
													set @IsWon=1
													set @IsActive=1
												end
																					
								end
								else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2  and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0  and @ParameterOddId in (6,7,8,50,51,52))
										  begin --Live Odd kapanmış ve OddType Rest Of Match ise OddType Handicap ve Tip e çevirilip bakılıyor.
												set @ActiveFark =-1
											 
												select @HomeScore=cast( SUBSTRING(@SlipScore,0, CHARINDEX(':', @SlipScore)) as int),@AwayScore=cast(SUBSTRING(@SlipScore,CHARINDEX(':', @SlipScore)+1, LEN(@SlipScore)) as int) 
												
												SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
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

													if(@Fark=@ActiveFark)
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
													if (@OddTypeId=18 and @activetimestatu<3)
													begin
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
														 and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2   and IsActive=1 
														 and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId  and (LiveEventOddResult.IsCanceled=0 or LiveEventOddResult.IsCanceled is null))=0 
														 )
															begin

																select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
																from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
																 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
																and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
																and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
								
															 
																set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

																set @IsLive=1
																set @IsActive=1

															if(@OddValue>9.9)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
															end
													end
															else
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


																if( @ParameterOddId=3403 and (@ActiveHomeFark-@ActiveAwayFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else if( @ParameterOddId=3405 and (@ActiveAwayFark-@ActiveHomeFark)>1)
																		begin
																		set @OddValue=1.05
																		set @IsActive=1
																				set @probodd=((1/@OddValue))
																	select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd
																		end
																else
																	begin
																	set @IsLive=1
																	set @IsActive=0
																	set @probodd=0
																	set @Reason='Keine Quoten.           Cashout nicht moglich'
																	end
															end
															else
															begin

															set @IsLive=1
															set @IsActive=0
															set @probodd=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															end
														end
												end
												else --Rest of Match oynandigindan skor berabereyse tippe bakiyoruz.
												begin

													set @OddTypeId=708

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
													set @SpecialBetValue=null

													select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
													from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
													and LiveEventOdd.OutCome=@Outcome --and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													and LiveEventDetail.BetStatus=2   and LiveEventOdd.OddValue>1
													
													if (@OddValue is not null and @OddValue>1)
													begin
													--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
													--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
													-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
													--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
													--and LiveEventDetail.BetStatus=2  
													--set @OddKey=1.10
													set @probodd=((1/@OddValue))
														select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

														set @IsLive=1
														set @IsActive=1

															if(@OddValue>9.9)
															begin
																	set @IsActive=0
																	set @Reason='Cashout nur moglich bis Quote 9,90'
																end
													end
													else
														begin
															set @IsLive=1
															set @IsActive=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
															set @probodd=0
														end
												end
										 end
										 --	else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 --@TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 --where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 --and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										 -- and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										 -- and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (710,134))
										 -- begin 
										   
											--			SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score)
											--			 from  @TLiveEvenDetail as LiveEventDetail  
											--			WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														
											--		if(@MatchScore<>'' and @MatchScore is not null)
											--		begin
											--			select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)

											--			set @ActiveGoal=@ActiveHomeScore+@ActiveAwayScore

											--			set @CustomerTotalGoal=cast( SUBSTRING(@SpecialBetValue,0, CHARINDEX('.', @SpecialBetValue)) as int)
													 
											--			if((@ParameterOddId=3407 and @CustomerTotalGoal>=@ActiveGoal) or (@ParameterOddId=3406 and @CustomerTotalGoal<=@ActiveGoal) or (@ParameterOddId=479 and  @CustomerTotalGoal>=@ActiveHomeScore) )
											--			begin
													 

											--				select @OddValue=ISNULL(OddValue,1.01),@TimeStatu=TimeStatu
											--	from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
											--	 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId
											--	and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
											--	and LiveEventDetail.BetStatus=2 and LiveEventOdd.OddValue>1
															
											--			 if(@OddValue<1.2 and @OddValue>1.01)
											--				set @OddValue= @OddValue 

											--	--		select @OddKey=SUM(1/(ISNULL(OddValue,1.01)))
											--	--from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN @TLiveEvent as LiveEvent ON LiveEvent.BetradarMatchId = LiveEventDetail.BetradarMatchId 
											--	-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.OddsTypeId=@OddTypeId
											--	--and   (LiveEventOdd.SpecialBetValue=@SpecialBetValue ) 
											--	--and LiveEventDetail.BetStatus=2
											--	--set @OddKey=1.10
											--	set @probodd=((1/@OddValue))
											--	set @Oldprobodd=((1/@CustomerOddValue))
											--	select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
											--		select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

											--		set @IsLive=1
											--		set @IsActive=1
												
											--			if(@OddValue*1.05>4)
											--			begin
											--				set @IsActive=0
											--				set @Reason='Keine Quoten.           Cashout nicht moglich'
											--			end
											--		end
											--		else -- Odd aktif degil
											--		begin
							
											--			set @IsLive=1
											--			set @IsActive=0
											--			set @Reason='Keine Quoten.           Cashout nicht moglich'
											--			 set @probodd=0
											--			-- 	set @OddKey=1.10
											--			 set @Oldprobodd=0
										
											--		end
											--	end
											--	else -- Odd aktif degil
											--		begin
							
											--			set @IsLive=1
											--			set @IsActive=0
											--			set @Reason='Keine Quoten.           Cashout nicht moglich'
											--			 set @probodd=0
											--			 	--set @OddKey=1.10
											--			 set @Oldprobodd=0
										
											--		end
										 -- end
										    else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										 @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										 where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										 and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 and @OddTypeId in (708,20))
										  begin 
										   
															SELECT  top 1 @MatchScore=RTRIM( LiveEventDetail.Score),@timestatu2=TimeStatu
														 from  @TLiveEvenDetail as LiveEventDetail  
														WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId)
														
													if(@MatchScore<>'' and @MatchScore is not null)
													begin
														select @ActiveHomeScore=cast( SUBSTRING(@MatchScore,0, CHARINDEX(':', @MatchScore)) as int),@ActiveAwayScore=cast(SUBSTRING(@MatchScore,CHARINDEX(':', @MatchScore)+1, LEN(@MatchScore)) as int)

														set @ActiveGoal=@ActiveHomeScore+@ActiveAwayScore

														--set @CustomerTotalGoal=cast( SUBSTRING(@SpecialBetValue,0, CHARINDEX('.', @SpecialBetValue)) as int)
													 
															if((@ParameterOddId=3400 and @ActiveHomeScore>@ActiveAwayScore) or (@ParameterOddId=3402 and @ActiveAwayScore>@ActiveHomeScore)  or (@ParameterOddId=57 and @ActiveAwayScore>@ActiveHomeScore and @timestatu2<3) or (@ParameterOddId=55 and @ActiveHomeScore>@ActiveAwayScore  and @timestatu2<3) )
														begin
													 

															set @OddValue= 1.01
															
														 if(@OddValue<1.2 and @OddValue>1.01)
															set @OddValue= @OddValue 
 
												--set @OddKey=1.10
												set @probodd=((1/@OddValue))
												set @Oldprobodd=((1/@CustomerOddValue))
												select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
													select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

													set @IsLive=1
													set @IsActive=1
												
														if(@OddValue*1.05>4)
														begin
															set @IsActive=0
															set @Reason='Keine Quoten.           Cashout nicht moglich'
														end
													end
													else -- Odd aktif degil
													begin
							
														set @IsLive=1
														set @IsActive=0
														set @Reason='Keine Quoten.           Cashout nicht moglich'
														 set @probodd=0
														 	--set @OddKey=1.10
														 set @Oldprobodd=0
										
													end
												end
												else -- Odd aktif degil
													begin
							
														set @IsLive=1
														set @IsActive=0
														set @Reason='Keine Quoten.           Cashout nicht moglich'
														 set @probodd=0
														 --	set @OddKey=1.10
														 set @Oldprobodd=0
										
													end
										  end
										--    else if exists (select OddId from @TLiveEventOdd as LiveEventOdd INNER JOIN @TLiveEvenDetail as LiveEventDetail ON LiveEventOdd.BetradarMatchId=LiveEventDetail.BetradarMatchId INNER JOIN
										-- @TLiveEvent as LiveEvent On LiveEvent.BetradarMatchId=LiveEventDetail.BetradarMatchId  
										-- where LiveEventOdd.BetradarMatchId=@BetradarMatchId and LiveEventOdd.ParameterOddId=@ParameterOddId and LiveEventOdd.OutCome=@Outcome and (LiveEventOdd.SpecialBetValue=@SpecialBetValue )  
										-- and LiveEventDetail.BetStatus=2 and LiveEventDetail.TimeStatu not in (5) and LiveEvent.ConnectionStatu=2    and LiveEventOdd.IsActive=0
										--  and (select COUNT(LiveEventOddResult.OddId) from @TLiveEventOddResult as LiveEventOddResult where LiveEventOddResult.OddId=LiveEventOdd.OddId 
										--  and (LiveEventOddResult.IsCanceled=0 or  LiveEventOddResult.IsCanceled is null))=0 )
										--  begin --Oran kapanmış 1.01 olduğu içinse
										
										--		select @OddValue= OddValue
										--from @TLiveEventOdd as LiveEventOdd
										--where BetradarMatchId=@BetradarMatchId and ParameterOddId=@ParameterOddId and OutCome=@Outcome and (SpecialBetValue=@SpecialBetValue or SpecialBetValue is null) 
									
								
										--				 if(@OddValue<1.2 and @OddValue>=1.01)
										--				 begin
										--					set @OddValue= @OddValue
										
										--		--set @OddKey=1.10
										--		set @probodd=((1/@OddValue))
										--		--set @Oldprobodd=((1/@CustomerOddValue))
										--		select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										--			select top 1 @probodd=@probodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@probodd and Value2>=@probodd

												

										--			set @IsLive=1
										--			set @IsActive=1
												
										--				if(@OddValue*1.05>4)
										--				begin
										--					set @IsActive=0
										--					set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				end
										--					end
										--		else -- Odd aktif degil
										--			begin
							
										--				set @IsLive=1
										--				set @IsActive=0
										--				set @Reason='Keine Quoten.           Cashout nicht moglich'
										--				 set @probodd=0
										--				 	---set @OddKey=1.10
										--				 set @Oldprobodd=((1/@CustomerOddValue))
										--				select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey2 where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
										--			end
										--  end
								else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										set @Reason='Keine Quoten.           Cashout nicht moglich'
										 set @probodd=0
										 set @Oldprobodd=0
									--	select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
								    end
					end
					else -- Odd aktif değil
									begin
								 
										set @IsLive=1
										set @IsActive=0
										set @Reason='Keine Quoten.           Cashout nicht moglich'
										 set @probodd=0
										 set @Oldprobodd=0
									--	select top 1 @Oldprobodd=@Oldprobodd*ISNULL(CashoutKey,1) from @TCashoutKey where Value1<=@Oldprobodd and Value2>=@Oldprobodd
										
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
			set @IsActive=0
			set @IsLive=0
			set @probodd=0
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
						SELECT  top 1 @Score= case when  LiveEventDetail.MatchTime is not null then  cast(  LiveEventDetail.MatchTime as nvarchar(50)) + ''' -' + RTRIM( LiveEventDetail.Score) else case when Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId>1 then cast(Language.[Parameter.LiveTimeStatu].TimeStatu as nvarchar(10))+ ' - ' + RTRIM( LiveEventDetail.Score) else '-' end end 
						,@LegScore=LegScore,@ActiveSportTime=MatchTime,@TimeStatu=LiveEventDetail.TimeStatu
						 from  @TLiveEvenDetail as LiveEventDetail  LEFT OUTER JOIN
                         Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId =  LiveEventDetail.TimeStatu
						WHERE        ( LiveEventDetail.BetradarMatchId = @BetradarMatchId) AND (Language.[Parameter.LiveTimeStatu].LanguageId = 6)
					end

			if(@Score='' or @Score is null)
				begin
						SELECT  top 1 @Score= case when ArchiveLiveEventDetail.MatchTime is not null then  cast( ArchiveLiveEventDetail.MatchTime as nvarchar(50)) + ''' -' + RTRIM(ArchiveLiveEventDetail.Score) else case when Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId>1 then cast(Language.[Parameter.LiveTimeStatu].TimeStatu as nvarchar(10))+ ' - ' + RTRIM(ArchiveLiveEventDetail.Score) else '-' end end 
						,@LegScore=LegScore,@ActiveSportTime=MatchTime,@TimeStatu=ArchiveLiveEventDetail.TimeStatu
						from @TArchiveLiveEvenDetail as ArchiveLiveEventDetail  LEFT OUTER JOIN
						Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId = ArchiveLiveEventDetail.TimeStatu
						WHERE        (ArchiveLiveEventDetail.BetradarMatchId = @BetradarMatchId) AND (Language.[Parameter.LiveTimeStatu].LanguageId = 6)
					end
			if @Score is null or @Score=''
						set @Score='-'
					 
				if(@Remaningtime<@Remaningtime2)
					set @Remaningtime2=@Remaningtime

						select @OddProfitfactor=FactorValue from Parameter.CashoutProfitFactor where ProfitValue1<@OddValue and ProfitValue2>=@OddValue
								select  @Remaningtime2=ISNULL(COUNT(*),0) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=1

						select  @LegScore=cast(ISNULL(COUNT(*),0) as nvarchar(20)) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and ScoreCardType=2 and CardType=2 and AffectedTeam=2


					insert @TempTableSystem
					select @SlipOddId,@OddValue,@Remaningtime2,@IsActive,@IsLive,@Amount,@Score,@LegScore,@EventName,@CustomerOddValue,@CustomerOutCome,case when @CustomerSpecialBetValue<>'-1' then @CustomerSpecialBetValue else '' end,@OddType,@EventDate,case when @OddValue=1 then STR(@CustomerOddValue, 25, 2)   else STR(@OddValue, 25, 2)  end,@IsWon,0,@OddProfitfactor,@BetradarMatchId,@EventId,@Banko,@probodd*@CustomerOddValue,@Oldprobodd,@Reason

		end
							fetch next from cur111 into @SlipOddId, @OddValue,@Amount,@BetType,@Outcome,@MatchId,@ParameterOddId,@SpecialBetValue,@EventDate,@SportId,@StateId,@EventName,@OddTypeId,@BetradarMatchId,@EventId,@Banko,@SlipScore
			
						end
					close cur111
					deallocate cur111	

					set @TotalWinAmount=0
				declare @OldMatchId bigint
				declare @OddMatchId bigint	
				 declare @Multipf float
				 declare @MultiOdds nvarchar(300)=''
				 declare @MultiCustomerOdds nvarchar(300)=''
					 select @EventPerBet= COUNT(distinct BetradarMatchId) from @TempTableSystem 

					-- select * from @TempTableSystem

						if  (((select COUNT(*) from @TempTableSystem where IsActive=0)=0 or (select COUNT(*) from @TempTableSystem where BetradarMatchId in (select BetradarMatchId from @TempTableSystem where IsActive=0) and IsActive=1)>0) and (((select COUNT(*) from @TempTableSystem where IsLive=1)>0) or ((select COUNT(*) from @TempTableSystem where IsWon=1)>0)  or (select COUNT(*) from @TempTableSystem where Score like '%beendet%')>0) )   
						begin
						set @OldMatchId=0
										
													set nocount on
															declare cur11123 cursor local for(
															select OddProb,CustomerOddValue,BetradarMatchId From @TempTableSystem where IsActive=1 and OddProb>0

																)
																order by BetradarMatchId
															open cur11123
															fetch next from cur11123 into @Multipf,@CustomerOddValue,@OddMatchId
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
																	fetch next from cur11123 into @Multipf,@CustomerOddValue,@OddMatchId
			
																end
															close cur11123
															deallocate cur11123

															set @MultiOdds=SUBSTRING(@MultiOdds,2,LEN(@MultiOdds))
															set @MultiCustomerOdds=SUBSTRING(@MultiCustomerOdds,2,LEN(@MultiCustomerOdds))
															select @WinAmount=[RiskManagement].[FuncSlipMultiEvaluateCashOut]     (@EventPerBet,@MultiOdds,@Amount)
														--	select @WinAmountReel=[RiskManagement].[FuncSlipMultiEvaluateCashOut]     (@EventPerBet,@MultiCustomerOdds,@Amount)
														--	select @WinAmount
																set @TotalWinAmount=@TotalWinAmount+ (@WinAmount)
															set @TotalWinAmountReel=@TotalWinAmountReel+ (@WinAmountReel*@WinAmount)
															--select @TotalOddValue,@EventPerBet,@MultiOdds,@Amount
															--select @WinAmount,@CouponCount,@Odds,@Amount
															set @Multipf=''


					--set @TotalOddValue =0
					--set @ProfitFactor =1
					--set @ReelValue =@Amount
					--set @LayRate =0
					-- set @TotalProb =0
					--set @CurrentOddValue =0
					--	if exists (select OddId from @TempTableSystem where IsWon=1)
					--				begin
					--				select @ReelValue=EXP(SUM(LOG(CustomerOddValue)))*MAX(Amount) from @TempTableSystem where IsWon=1
					--					if exists (select OddId from @TempTableSystem where IsWon=0) --Eğer kuponda kazanan event varsa ve hala kazanmayan başka bir event varsa cashoutkey düşürülüyor.
					--						set @CashOutKey=0.95
					--				end
					--				else
					--					set @CashOutKey=0.95

					
					--select @TotalOddValue=EXP(SUM(LOG(OddValue))),@CurrentOddValue=EXP(SUM(LOG(CustomerOddValue))),@ProfitFactor=EXP(SUM(LOG(ProfitFactor))) from @TempTableSystem   where OddValue>0
					--Begin TRY
					--	select @TotalProb=EXP(SUM(LOG(OddProb))) from @TempTableSystem   where OddValue>0
					--end try
					--BEGIN CATCH 
					--	set @TotalProb=0
					--END CATCH 
					 
					-- select @TotalWinAmount
						set @CashOut=@TotalWinAmount


					--	select * from @TempTableSystem

				 
					end
					else if not exists (select OddId from @TempTableSystem where IsActive=0)   and (select COUNT(*) from @TempTableSystem)>0 and (select COUNT(*) from @TempTableSystem where EvenDate<GETDATE())=0
					begin
							set @CashOut=@SystemAmount
					end
					else
						set @CashOut=0

						if(@CashOut>=@MultiGain)
						begin
					 
							set @CashOut=0
					 end

						update @TempTableSystem set CashOutValue=@CashOut

				select DISTINCT cast(0 as bigint) as OddId ,OddValue ,RemaningTime ,IsActive ,IsLive ,Amount ,Score ,LegScore ,EventName ,CustomerOddValue ,OutCome ,SpecialBetValue,OddType ,EvenDate ,MatchTime ,IsWon ,CashOutValue ,ProfitFactor,BetradarMatchId,EventId ,Banko ,Reason
					from @TempTableSystem Order by EvenDate,BetradarMatchId
					 
							--from @TempTableSystem2
						end
 else
	begin

						set @SystemCashOut=0

								select DISTINCT cast(0 as bigint) as OddId 
								,OddValue as OddValue ,0 as RemaningTime , cast(1 as bit ) as IsActive ,cast(0 as bit ) as IsLive ,cast(0 as money) as Amount 
								,'' as Score ,'' as LegScore ,EventName as EventName ,OddValue as  CustomerOddValue ,OutCome as OutCome 
								,SpecialBetValue as SpecialBetValue,case when Customer.SlipOdd.BetTypeId=0 
								then (Select Language.[Parameter.OddsType].OddsType from Language.[Parameter.OddsType] where Language.[Parameter.OddsType].OddsTypeId=Customer.SlipOdd.OddsTypeId and LanguageId=@LangId) 
								else (Select Language.[Parameter.LiveOddType].ShortOddType from  Language.[Parameter.LiveOddType] where Language.[Parameter.LiveOddType].OddTypeId=Customer.SlipOdd.OddsTypeId and LanguageId=@LangId) end as OddType ,EventDate as  EvenDate ,'' as MatchTime ,cast(0 as bit ) as IsWon 
								,@SystemCashOut as CashOutValue ,cast(0 as float ) as ProfitFactor,BetradarMatchId,MatchId as  EventId  ,Banko,'' as Reason
							from Customer.SlipOdd  where SlipId=@SlipId
							--from @TempTable2
						end


	
					
				


GO
