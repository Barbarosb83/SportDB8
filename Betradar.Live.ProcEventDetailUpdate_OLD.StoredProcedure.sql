USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventDetailUpdate_OLD]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Live.ProcEventDetailUpdate_OLD]
           @BetradarMatchId bigint,
           @IsActive bit, --maçın aktifliği
           @AutoTraded bit, 
           @Balls int,
           @Bases nvarchar(50),
           @BatterTeam1 int,
           @BatterTeam2 int,
           @BetStatus int,
           @BetStopReasonId int,
           @Booked bit,
           @ClearedScore nchar(15),
           @ClockStopped bit,
           @CornersTeam1 int,
           @CornersTeam2 int,
           @CurrentEnd int,
           @Delivery int,
           @DismissalsTeam1 int,
           @DismissalsTeam2 int,
           @EarlyBetStatusId int,
           @Expedite bit,
           @GameScore nchar(15),
           @Innings int,
           @LegScore nchar(100),
           @MatchTime bigint,
           @MatchTimeExtended nchar(15),
           @Msgnr bigint,
           @Outs int,
           @MatchOver int,
           @PenaltyRunsTeam1 int,
           @PenaltyRunsTeam2 int,
           @Position int,
           @Possession int,
           @RedCardsTeam1 int,
           @RedCardsTeam2 int,
           @RemainingBowlsTeam1 int,
           @RemainingBowlsTeam2 int,
           @RemainingReds int,
           @RemainingTime nchar(15),
           @RemainingTimeInPeriod nchar(15),
           @Score nchar(100),
           @MatchServer int,
           @SourceId nvarchar(50),
           @Strikes int,
           @SuspendTeam1 int,
           @SuspendTeam2 int,
           @Throw int,
           @TieBreak bit,
           @MatchTry int,
           @MatchVisit int,
           @Yards int,
           @YellowCardsTeam1 int,
           @YellowCardsTeam2 int,
           @YellowRedCardsTeam1 int,
           @YellowRedCardsTeam2 int,
           @TimeStatu int,
@BetradarTimeStamp datetime

AS
BEGIN
set @BetStatus=2
declare @EventId int
select @EventId=[Live].[Event].EventId from [Live].[Event] with (nolock) where [Live].[Event].[BetradarMatchId]=@BetradarMatchId
 


if (@EventId is not null)
begin

if exists (select [Live].[EventDetail].EventId from [Live].[EventDetail] with (nolock) where [Live].[EventDetail].[BetradarMatchIds]=@BetradarMatchId)
begin
			
			

			UPDATE [Live].[EventDetail]
   SET [IsActive] = @IsActive
      ,[AutoTraded] = @AutoTraded
      ,[Balls] = @Balls
      ,[Bases] = @Bases
      ,[BatterTeam1] = @BatterTeam1
      ,[BatterTeam2] = @BatterTeam2
      ,[BetStatus] = @BetStatus
      ,[BetStopReasonId] = @BetStopReasonId
      ,[Booked] = @Booked
      ,[ClearedScore] = @ClearedScore
      ,[ClockStopped] = @ClockStopped
      ,[CornersTeam1] = @CornersTeam1
      ,[CornersTeam2] = @CornersTeam2
      ,[CurrentEnd] = @CurrentEnd
      ,[Delivery] = @Delivery
      ,[DismissalsTeam1] = @DismissalsTeam1
      ,[DismissalsTeam2] = @DismissalsTeam2
      ,[EarlyBetStatusId] = @EarlyBetStatusId
      ,[Expedite] = @Expedite
      ,[GameScore] = @GameScore
      ,[Innings] = @Innings
      ,[LegScore] = @LegScore
      ,[MatchTime] = @MatchTime
      ,[MatchTimeExtended] = @MatchTimeExtended
      ,[Msgnr] = @Msgnr
      ,[Outs] = @Outs
      ,[MatchOver] = @MatchOver
      ,[PenaltyRunsTeam1] = @PenaltyRunsTeam1
      ,[PenaltyRunsTeam2] = @PenaltyRunsTeam2
      ,[Position] = @Position
      ,[Possession] = @Possession
      ,[RedCardsTeam1] = @RedCardsTeam1
      ,[RedCardsTeam2] = @RedCardsTeam2
      ,[RemainingBowlsTeam1] = @RemainingBowlsTeam1
      ,[RemainingBowlsTeam2] = @RemainingBowlsTeam2
      ,[RemainingReds] = @RemainingReds
      ,[RemainingTime] = @RemainingTime
      ,[RemainingTimeInPeriod] = @RemainingTimeInPeriod
      ,[Score] = @Score
      ,[MatchServer] = @MatchServer
      ,[SourceId] = @SourceId
      ,[Strikes] = @Strikes
      ,[SuspendTeam1] = @SuspendTeam1
      ,[SuspendTeam2] = @SuspendTeam2
      ,[Throw] = @Throw
      ,[TieBreak] = @TieBreak
      ,[MatchTry] = @MatchTry
      ,[MatchVisit] = @MatchVisit
      ,[Yards] = @Yards
      ,[YellowCardsTeam1] = @YellowCardsTeam1
      ,[YellowCardsTeam2] = @YellowCardsTeam2
      ,[YellowRedCardsTeam1] = @YellowRedCardsTeam1
      ,[YellowRedCardsTeam2] = @YellowRedCardsTeam2
      ,[TimeStatu]=@TimeStatu,BetradarTimeStamp=@BetradarTimeStamp
   ,BetradarMatchIds=@BetradarMatchId 
 WHERE [EventId] = @EventId --  and BetradarTimeStamp<@BetradarTimeStamp

 exec [Betradar].[Live.ProcEventScore] @BetradarMatchId,@Score,@MatchTime
  --if(@BetStopReasonId is not null)
		--update Live.EventOdd set IsActive=0 where BetradarMatchId=@BetradarMatchId

	--if(@RedCardsTeam1+@YellowRedCardsTeam1>0)
	--	begin
	--		if (ISNULL((Select COUNT(Live.ScoreCardSummary.ScoreCardId) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and AffectedTeam=1 and ScoreCardType=2 and CardType=2 and IsCanceled=0),0))<@RedCardsTeam1+@YellowRedCardsTeam1
	--			begin
	--					INSERT INTO [Live].[ScoreCardSummary]
	--				   ([EventId]
	--				   ,[BetradarId]
	--				   ,[ScoreCardType]
	--				   ,[CardType]
	--				   ,[AffectedPlayers]
	--				   ,[AffectedTeam]
	--				   ,[PlayerId]
	--				   ,[IsCanceled]
	--				   ,[Time])
	--			 VALUES
	--				   (@EventId
	--				   ,@EventId+DATEPART(SECOND,GETDATE())+DATEPART(MINUTE,GETDATE())
	--				   ,2
	--				   ,2
	--				   ,0
	--				   ,1
	--				   ,-1
	--				   ,0
	--				   ,@MatchTime)		
	--			end
	--	end
	--else
	--	begin
	--	if (ISNULL((Select COUNT(Live.ScoreCardSummary.ScoreCardId) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and AffectedTeam=1 and ScoreCardType=2 and CardType=2 and IsCanceled=0),0))>@RedCardsTeam1+@YellowRedCardsTeam1
	--		update Live.ScoreCardSummary set IsCanceled=1 where ScoreCardId = (select Top 1 ScoreCardId from Live.ScoreCardSummary with (nolock) where EventId=@EventId and AffectedTeam=1 and ScoreCardType=2 and CardType=2 and IsCanceled=0 order by [Time] desc  )
	--	end

	--		if(@RedCardsTeam2+@YellowRedCardsTeam2>0)
	--	begin
	--		if (ISNULL((Select COUNT(Live.ScoreCardSummary.ScoreCardId) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and AffectedTeam=2 and ScoreCardType=2 and CardType=2 and IsCanceled=0),0))<@RedCardsTeam2+@YellowRedCardsTeam2
	--			begin
	--					INSERT INTO [Live].[ScoreCardSummary]
	--				   ([EventId]
	--				   ,[BetradarId]
	--				   ,[ScoreCardType]
	--				   ,[CardType]
	--				   ,[AffectedPlayers]
	--				   ,[AffectedTeam]
	--				   ,[PlayerId]
	--				   ,[IsCanceled]
	--				   ,[Time])
	--			 VALUES
	--				   (@EventId
	--				   	   ,@EventId+DATEPART(SECOND,GETDATE())+DATEPART(MINUTE,GETDATE())
	--				   ,2
	--				   ,2
	--				   ,0
	--				   ,2
	--				   ,-1
	--				   ,0
	--				   ,@MatchTime)		
	--			end

	--	end
	--	else
	--	begin
	--	if (ISNULL((Select COUNT(Live.ScoreCardSummary.ScoreCardId) from Live.ScoreCardSummary with (nolock) where EventId=@EventId and AffectedTeam=2 and ScoreCardType=2 and CardType=2 and IsCanceled=0),0))>@RedCardsTeam2+@YellowRedCardsTeam2
	--		update Live.ScoreCardSummary set IsCanceled=1 where ScoreCardId = (select Top 1 ScoreCardId from Live.ScoreCardSummary with (nolock) where EventId=@EventId and AffectedTeam=2 and ScoreCardType=2 and CardType=2 and IsCanceled=0 order by [Time] desc  )
	--	end

 end
 else
begin
			INSERT INTO [Live].[EventDetail]
           ([EventId]
           ,[IsActive]
           ,[AutoTraded]
           ,[Balls]
           ,[Bases]
           ,[BatterTeam1]
           ,[BatterTeam2]
           ,[BetStatus]
           ,[BetStopReasonId]
           ,[Booked]
           ,[ClearedScore]
           ,[ClockStopped]
           ,[CornersTeam1]
           ,[CornersTeam2]
           ,[CurrentEnd]
           ,[Delivery]
           ,[DismissalsTeam1]
           ,[DismissalsTeam2]
           ,[EarlyBetStatusId]
           ,[Expedite]
           ,[GameScore]
           ,[Innings]
           ,[LegScore]
           ,[MatchTime]
           ,[MatchTimeExtended]
           ,[Msgnr]
           ,[Outs]
           ,[MatchOver]
           ,[PenaltyRunsTeam1]
           ,[PenaltyRunsTeam2]
           ,[Position]
           ,[Possession]
           ,[RedCardsTeam1]
           ,[RedCardsTeam2]
           ,[RemainingBowlsTeam1]
           ,[RemainingBowlsTeam2]
           ,[RemainingReds]
           ,[RemainingTime]
           ,[RemainingTimeInPeriod]
           ,[Score]
           ,[MatchServer]
           ,[SourceId]
           ,[Strikes]
           ,[SuspendTeam1]
           ,[SuspendTeam2]
           ,[Throw]
           ,[TieBreak]
           ,[MatchTry]
           ,[MatchVisit]
           ,[Yards]
           ,[YellowCardsTeam1]
           ,[YellowCardsTeam2]
           ,[YellowRedCardsTeam1]
           ,[YellowRedCardsTeam2]
           ,[TimeStatu],BetradarTimeStamp,BetradarMatchIds
      )
     VALUES
           (@EventId,
           @IsActive,
           @AutoTraded,
           @Balls,
           @Bases,
           @BatterTeam1,
           @BatterTeam2,
           @BetStatus,
           @BetStopReasonId,
           @Booked,
           @ClearedScore,
           @ClockStopped,
           @CornersTeam1,
           @CornersTeam2,
           @CurrentEnd,
           @Delivery,
           @DismissalsTeam1,
           @DismissalsTeam2,
           @EarlyBetStatusId,
           @Expedite,
           @GameScore,
           @Innings,
           @LegScore,
           @MatchTime,
           @MatchTimeExtended,
           @Msgnr,
           @Outs,
           @MatchOver,
           @PenaltyRunsTeam1,
           @PenaltyRunsTeam2,
           @Position,
           @Possession,
           @RedCardsTeam1,
           @RedCardsTeam2,
           @RemainingBowlsTeam1,
           @RemainingBowlsTeam2,
           @RemainingReds,
           @RemainingTime,
           @RemainingTimeInPeriod,
           @Score,
           @MatchServer,
           @SourceId,
           @Strikes,
           @SuspendTeam1,
           @SuspendTeam2,
           @Throw,
           @TieBreak,
           @MatchTry,
           @MatchVisit,
           @Yards,
           @YellowCardsTeam1,
           @YellowCardsTeam2,
           @YellowRedCardsTeam1,
           @YellowRedCardsTeam2,
           @TimeStatu,@BetradarTimeStamp,@BetradarMatchId)

		end

 if(@TimeStatu=3)
 begin

 if not exists (select EventId from [Live].[ScoreCardSummary] with (nolock) where EventId=@EventId and [ScoreCardType]=3)
		INSERT INTO [Live].[ScoreCardSummary]
					   ([EventId]
					   ,[BetradarId]
					   ,[ScoreCardType]
					   ,[CardType]
					   ,[AffectedPlayers]
					   ,[AffectedTeam]
					   ,[PlayerId]
					   ,[IsCanceled]
					   ,[Time])
				 VALUES
					   (@EventId
					   ,-1
					   ,3
					   ,4
					   ,''
					   ,0
					   ,-1
					   ,0
					   ,45)
 end
  else if(@TimeStatu=5)
 begin
  if not exists (select EventId from [Live].[ScoreCardSummary] with (nolock) where EventId=@EventId and [ScoreCardType]=4)
		INSERT INTO [Live].[ScoreCardSummary]
					   ([EventId]
					   ,[BetradarId]
					   ,[ScoreCardType]
					   ,[CardType]
					   ,[AffectedPlayers]
					   ,[AffectedTeam]
					   ,[PlayerId]
					   ,[IsCanceled]
					   ,[Time])
				 VALUES
					   (@EventId
					   ,-2
					   ,4 --FT
					   ,5
					   ,''
					   ,0
					   ,-1
					   ,0
					   ,90)

					   delete from Live.Score where BetradarMatchId= @BetradarMatchId
 end


end

	

	


	
END


GO
