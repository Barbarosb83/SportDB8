USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventDetailUpdate_NEW]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Betradar].[Live.ProcEventDetailUpdate_NEW]
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
      ,[Bases] = @Bases
      ,[BetStatus] = @BetStatus
      ,[BetStopReasonId] = @BetStopReasonId
      ,[EarlyBetStatusId] = @EarlyBetStatusId
      ,[Expedite] = @Expedite
      ,[GameScore] = @GameScore
      ,[Innings] = @Innings
      ,[LegScore] = @LegScore
      ,[MatchTime] = @MatchTime
      ,[MatchTimeExtended] = @MatchTimeExtended
      ,[Possession] = @Possession
      ,[RedCardsTeam1] = @RedCardsTeam1
      ,[RedCardsTeam2] = @RedCardsTeam2
      ,[Score] = @Score
      ,[MatchServer] = @MatchServer
      ,[SourceId] = @SourceId
      ,[MatchVisit] = @MatchVisit
      ,[YellowRedCardsTeam1] = @YellowRedCardsTeam1
      ,[YellowRedCardsTeam2] = @YellowRedCardsTeam2
      ,[TimeStatu]=@TimeStatu,BetradarTimeStamp=@BetradarTimeStamp
   ,BetradarMatchIds=@BetradarMatchId 
 WHERE [EventId] = @EventId --  and BetradarTimeStamp<@BetradarTimeStamp

 exec [Betradar].[Live.ProcEventScore] @BetradarMatchId,@Score,@MatchTime
  

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
 else
begin
			INSERT INTO [Live].[EventDetail]
           ([EventId]
           ,[IsActive]
           ,[Bases]
           ,[BetStatus]
           ,[BetStopReasonId]
           ,[Delivery]
           ,[EarlyBetStatusId]
           ,[GameScore]
           ,[Innings]
           ,[LegScore]
           ,[MatchTime]
           ,[MatchTimeExtended]
           ,[Possession]
           ,[RedCardsTeam1]
           ,[RedCardsTeam2]
           ,[Score]
           ,[MatchServer]
           ,[SourceId]
           ,[MatchVisit]
           ,[YellowRedCardsTeam1]
           ,[YellowRedCardsTeam2]
           ,[TimeStatu],BetradarTimeStamp,BetradarMatchIds
      )
     VALUES
           (@EventId,
           @IsActive,
           @Bases,
           @BetStatus,
           @BetStopReasonId,
           @Delivery,
           @EarlyBetStatusId,
           @GameScore,
           @Innings,
           @LegScore,
           @MatchTime,
           @MatchTimeExtended,
           @Possession,
           @RedCardsTeam1,
           @RedCardsTeam2,
           @Score,
           @MatchServer,
           @SourceId,
           @MatchVisit,
           @YellowRedCardsTeam1,
           @YellowRedCardsTeam2,
           @TimeStatu,@BetradarTimeStamp,@BetradarMatchId)

		end




end

	

	


	
END


GO
