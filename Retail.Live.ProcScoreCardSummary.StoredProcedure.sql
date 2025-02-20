USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[Live.ProcScoreCardSummary]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[Live.ProcScoreCardSummary]
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

select @EventId=Live.Event.EventId from Live.Event with (nolock) where Live.Event.BetradarMatchId=@BetradarEventId

if (@EventId is not null)
	begin
	
		--select top 1 @ScoreCardId=Live.ScoreCardSummary.ScoreCardId from Live.ScoreCardSummary where Live.ScoreCardSummary.BetradarId=@BetradarScoreCardId
		
		--if (@PlayerId is not null)
		--	begin
		--		select @PlayerId=Parameter.Competitor.CompetitorId from Parameter.Competitor where Parameter.Competitor.BetradarSuperId=@BetradarPlayerId
		--	end
			
		if exists (select Live.ScoreCardSummary.ScoreCardId from Live.ScoreCardSummary with (nolock) where Live.ScoreCardSummary.BetradarId=@BetradarScoreCardId)
			begin
				UPDATE [Live].[ScoreCardSummary]
					   SET [ScoreCardType] = @ScoreCardType
						  ,[CardType] = @CardType
						  ,[AffectedPlayers] = @AffectedPlayers
						  ,[AffectedTeam] = @AffectedTeam
						  ,[PlayerId] = @PlayerId
						  ,[IsCanceled] = @IsCanceled
						  ,[Time] = @Time
					 WHERE [Live].[ScoreCardSummary].BetradarId=@BetradarScoreCardId
			end
		else
			begin
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


	select 1 as result
END


GO
