USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcEventDetailUpdate2]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Betradar].[Live.ProcEventDetailUpdate2]
           @BetradarMatchId bigint,
           @GameScore nchar(15),
           @MatchTime bigint,
           @MatchTimeExtended nchar(15),
           @Score nchar(15),
           @TimeStatu int
AS
BEGIN


 declare @EventId int
 
 
			  if(@TimeStatu=3)
				if exists (Select EventId from Live.EventDetail where BetradarMatchIds=@BetradarMatchId and TimeStatu=2)
					update live.EventOdd set IsActive=0 where BetradarMatchId=@BetradarMatchId


			UPDATE [Live].[EventDetail]
			   SET [GameScore] = @GameScore
				  ,[MatchTime] = @MatchTime
				  ,[MatchTimeExtended] = @MatchTimeExtended      
				  ,[Score] = @Score      
				  ,[TimeStatu]=@TimeStatu
			 WHERE BetradarMatchIds = @BetradarMatchId


				--begin
  
				--	select @EventId=[Live].[Event].EventId from [Live].[Event] with (nolock) where [Live].[Event].[BetradarMatchId]=@BetradarMatchId
				--	if (@EventId is not null)
				--	 if not exists (select EventId from [Live].[ScoreCardSummary] with (nolock) where EventId=@EventId and [ScoreCardType]=3)
				--			INSERT INTO [Live].[ScoreCardSummary]
				--						   ([EventId]
				--						   ,[BetradarId]
				--						   ,[ScoreCardType]
				--						   ,[CardType]
				--						   ,[AffectedPlayers]
				--						   ,[AffectedTeam]
				--						   ,[PlayerId]
				--						   ,[IsCanceled]
				--						   ,[Time])
				--					 VALUES
				--						   (@EventId
				--						   ,-1
				--						   ,3
				--						   ,4
				--						   ,''
				--						   ,0
				--						   ,-1
				--						   ,0
				--						   ,45)
				--end
			 --else if(@TimeStatu=5)
				--begin

				--	select @EventId=[Live].[Event].EventId  from [Live].[Event] with (nolock) where [Live].[Event].[BetradarMatchId]=@BetradarMatchId
				--	if (@EventId is not null)
				--	  if not exists (select EventId from [Live].[ScoreCardSummary] with (nolock) where EventId=@EventId and [ScoreCardType]=4) 
				--			INSERT INTO [Live].[ScoreCardSummary]
				--						   ([EventId]
				--						   ,[BetradarId]
				--						   ,[ScoreCardType]
				--						   ,[CardType]
				--						   ,[AffectedPlayers]
				--						   ,[AffectedTeam]
				--						   ,[PlayerId]
				--						   ,[IsCanceled]
				--						   ,[Time])
				--					 VALUES
				--						   (@EventId
				--						   ,-2
				--						   ,4 --FT
				--						   ,5
				--						   ,''
				--						   ,0
				--						   ,-1
				--						   ,0
				--						   ,90)
				--end

	 
END


GO
