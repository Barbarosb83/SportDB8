USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventOddCancel_BettingLive]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Live.ProcEventOddCancel_BettingLive]
@BetradarMatchId bigint,
@BetradarOddTypeId bigint,
@BetradarOddSubTypeId bigint,
@SpecialBetValue nvarchar(50),
@BettradarOddId bigint,
@IsActive bit,
@Combination bigint,
@ForTheRest nchar(30),
@Comment nchar(30),
@MostBalanced bit,
@Changed bit,
@IsCanceled bit,
@BetradarTimeStamp datetime
AS

BEGIN

declare @oddId int
declare @PlayerId int=0
declare @TeamId int=0
declare @EventId bigint
declare @StartDate datetime
declare @EndDate datetime
set @StartDate=cast(@ForTheRest as datetime)
set @EndDate =@BetradarTimeStamp


declare @LiveEventId int
select @LiveEventId=[BettingLive].[Live].[Event].EventId from [BettingLive].[Live].[Event] with (nolock) where [BettingLive].[Live].[Event].[BetradarMatchId]=@BetradarMatchId


--insert dbo.betslip values (@EventId,'Live.ProcEventOddCancel',GETDATE())	
if (@LiveEventId is not null)
	begin
		
		declare @eventoddid bigint  
		declare @IsOddValueLock bit
		
				
				set nocount on
					declare cur111 cursor local for(
					SELECT  Live.EventOdd.OddId  from  Live.EventOdd with (nolock) WHERE  Live.EventOdd.BettradarOddId=@BettradarOddId and Live.EventOdd.MatchId=@LiveEventId

						)

					open cur111
					fetch next from cur111 into @eventoddid
					while @@fetch_status=0
						begin
							begin

								INSERT INTO [Customer].[SlipOddCancel]
										   ([SlipOddCancelId]
										   ,[SlipId]
										   ,[OddId]
										   ,[OddValue]
										   ,[Amount]
										   ,[StateId]
										   ,[BetTypeId]
										   ,[OutCome]
										   ,[MatchId]
										   ,[OddsTypeId]
										   ,[SpecialBetValue]
										   ,[ParameterOddId]
										   ,[EventName]
										   ,[EventDate]
										   ,[CurrencyId]
										   ,[Score]
										   ,[ScoreTimeStatu]
										   ,[SportId]
										   ,[Banko]
										   ,[BetradarMatchId],OddProbValue)
										select * from Customer.SlipOdd with (nolock)  where OddId=@eventoddid and MatchId=@LiveEventId and BetTypeId=1
										and SlipId in (Select SlipId from Customer.Slip with (nolock) where CreateDate>=@StartDate and CreateDate<=@EndDate)
										and SlipId not in (Select SlipId from Customer.SlipOddCancel with (nolock))





							update Customer.SlipOdd set OddValue=1,StateId=2 where OddId=@eventoddid and MatchId=@LiveEventId and BetTypeId=1 and SlipId in (Select SlipId from Customer.Slip with (nolock) where CreateDate>=@StartDate and CreateDate<=@EndDate)
								exec RiskManagement.ProcSlipOddsEvaluateRollBack  @eventoddid,1
							
							end
							fetch next from cur111 into @eventoddid
			
						end
					close cur111
					deallocate cur111	
				
			if not exists (select [BettingLive].Live.EventOddResult.OddresultId from [BettingLive].Live.EventOddResult  with (nolock)  where [BettingLive].Live.EventOddResult.BetradarOddId=@BettradarOddId and [BettingLive].Live.EventOddResult.BetradarMatchId=@BetradarMatchId)
						insert [BettingLive].Live.EventOddResult (OddId,OddsTypeId,BetradarOddId,BetradarOddsTypeId,BetradarOddsSubTypeId,BetradarMatchId,OutCome,SpecialBetValue,OddResult,IsEvaluated,StateId,EvaluatedDate,IsCanceled)
					select Live.EventOdd.OddId,OddsTypeId,@BettradarOddId,@BetradarOddTypeId,@BetradarOddSubTypeId,@BetradarMatchId,Live.EventOdd.OutCome,Live.EventOdd.SpecialBetValue,0,0,4,GETDATE(),1 
					from Live.EventOdd  with (nolock)
					WHERE   Live.EventOdd.BettradarOddId=@BettradarOddId 
						 and Live.EventOdd.BetradarMatchId=@BetradarMatchId
			else
				begin
					delete from [BettingLive].Live.EventOddResult where [BettingLive].Live.EventOddResult.BetradarOddId=@BettradarOddId and [BettingLive].Live.EventOddResult.BetradarMatchId=@BetradarMatchId

					insert [BettingLive].Live.EventOddResult (OddId,OddsTypeId,BetradarOddId,BetradarOddsTypeId,BetradarOddsSubTypeId,BetradarMatchId,OutCome,SpecialBetValue,OddResult,IsEvaluated,StateId,EvaluatedDate,IsCanceled)
					select Live.EventOdd.OddId,OddsTypeId, @BettradarOddId,@BetradarOddTypeId,@BetradarOddSubTypeId,@BetradarMatchId,Live.EventOdd.OutCome,Live.EventOdd.SpecialBetValue,0,0,4,GETDATE(),1 
					from Live.EventOdd  with (nolock)
					WHERE   Live.EventOdd.BettradarOddId=@BettradarOddId 
						 and Live.EventOdd.BetradarMatchId=@BetradarMatchId

				end		
					
						
							
						--UPDATE [Live].[EventOdd]
						--   SET 
							 
						--	  [IsChanged] = @Changed
						--	  ,[IsActive] = @IsActive
						--	  ,[IsCanceled]=@IsCanceled
						--	  ,StateId=4
						--	  ,BetradarTimeStamp=@BetradarTimeStamp
						--	   ,UpdatedDate=GETDATE()
						-- WHERE   Live.EventOdd.BettradarOddId=@BettradarOddId 
						-- --and Live.EventOdd.MatchId=@LiveEventId
						-- and Live.EventOdd.BetradarMatchId=@BetradarMatchId
			
						 exec [Betradar].[Live.ProcEventTopOddNoOutCome] @BetradarMatchId, NULL, @SpecialBetValue,NULL,@BettradarOddId,0,NULL,NULL
				end
				
				select 0
END


GO
