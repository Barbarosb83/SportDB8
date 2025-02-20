USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcScoreCardSummary]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Virtual.ProcScoreCardSummary]
@BetradarScoreCardId bigint,
@BetradarEventId bigint,
@ScoreCardType  int,
@CardType int,
@AffectedPlayers nvarchar(max),
@AffectedTeam int,
@BetradarPlayerId bigint,
@IsCanceled bit,
@Time int

AS

declare @EventId bigint
declare @PlayerId bigint
declare @ScoreCardId bigint

BEGIN

select @EventId=Virtual.Event.EventId from Virtual.Event where Virtual.Event.BetradarMatchId=@BetradarEventId

if (@EventId is not null)
	begin
	
		select @ScoreCardId=Virtual.ScoreCardSummary.ScoreCardId from Virtual.ScoreCardSummary where Virtual.ScoreCardSummary.BetradarId=@BetradarScoreCardId
		
		if (@PlayerId is not null)
			begin
				select @PlayerId=Parameter.Competitor.CompetitorId from Parameter.Competitor where Parameter.Competitor.BetradarSuperId=@BetradarPlayerId
			end
			
		if (@ScoreCardId is not null)
			begin
				UPDATE [Virtual].[ScoreCardSummary]
					   SET [ScoreCardType] = @ScoreCardType
						  ,[CardType] = @CardType
						  ,[AffectedPlayers] = @AffectedPlayers
						  ,[AffectedTeam] = @AffectedTeam
						  ,[PlayerId] = @PlayerId
						  ,[IsCanceled] = @IsCanceled
						  ,[Time] = @Time
					 WHERE [Virtual].[ScoreCardSummary].ScoreCardId=@ScoreCardId
			end
		else
			begin
				INSERT INTO [Virtual].[ScoreCardSummary]
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
					   ,@BetradarScoreCardId
					   ,@ScoreCardType
					   ,@CardType
					   ,@AffectedPlayers
					   ,@AffectedTeam
					   ,@PlayerId
					   ,@IsCanceled
					   ,@Time)
			

			end
	
	end



END


GO
