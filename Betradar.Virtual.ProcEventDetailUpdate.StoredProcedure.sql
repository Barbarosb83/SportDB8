USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcEventDetailUpdate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcEventDetailUpdate]
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
           @DeVirtualry int,
           @DismissalsTeam1 int,
           @DismissalsTeam2 int,
           @EarlyBetStatusId int,
           @Expedite bit,
           @GameScore nchar(15),
           @Innings int,
           @LegScore nchar(15),
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
           @Score nvarchar(15),
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
           @TimeStatu int

AS
BEGIN

declare @EventId int
select @EventId=[Virtual].[Event].EventId from [Virtual].[Event] where [Virtual].[Event].[BetradarMatchId]=@BetradarMatchId

if (@EventId is not null)
begin
	if(@TimeStatu in (3,5,32,31,87))
	begin
	IF EXISTS (select Customer.SlipOdd.SlipOddId from Customer.SlipOdd with (nolock) where Customer.SlipOdd.MatchId=@EventId)
		begin
		if(@TimeStatu in (3,31,87) and (@Score is not null))
			update Customer.SlipOdd set Score=REPLACE(@Score,' ',''),ScoreTimeStatu=@TimeStatu where MatchId=@EventId
		else if(@TimeStatu=32 and (@Score is not null))
			update Customer.SlipOdd set Score=REPLACE(@Score,' ',''),ScoreTimeStatu=@TimeStatu where MatchId=@EventId and  ISNULL(ScoreTimeStatu,0) <> @TimeStatu
		else if((@Score is not null))
			update Customer.SlipOdd set Score= case when Customer.SlipOdd.Score is not null then   REPLACE(@Score,' ','')+'('+ISNULL(Customer.SlipOdd.Score,'')+')' else REPLACE(@Score,' ','') end,ScoreTimeStatu=@TimeStatu  where MatchId=@EventId and (Score not like '%(%' or Score is null) and ISNULL(ScoreTimeStatu,0) <> @TimeStatu
		end
	end

	if ((select count([Virtual].[EventDetail].EventId) from [Virtual].[EventDetail] where [Virtual].[EventDetail].EventId=@EventId)>0)
		begin
			
			UPDATE [Virtual].[EventDetail]
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
				  ,[DeVirtualry] = @DeVirtualry
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
				  ,[TimeStatu]=@TimeStatu
			 WHERE [EventId] = @EventId
		end
	else
		begin
			INSERT INTO [Virtual].[EventDetail]
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
				   ,[DeVirtualry]
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
				   ,[TimeStatu])
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
				   @DeVirtualry,
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
				   @TimeStatu)
		end
	end
END


GO
