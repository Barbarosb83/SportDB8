USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchCard]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcMatchCard]
@MatchId bigint,
@BetradarCardId bigint,
@Time nvarchar(10),
@BetRadarPlayerId bigint,
@Doubtful bit,
@BetradarTeamId bigint,
@Type nvarchar(20),
@PlayerName nvarchar(250)
AS

BEGIN
declare @CardTypeId int

declare @PlayerId int=0
declare @TeamId int=0

--select @CardTypeId=Parameter.CardType.CardTypeId from Parameter.CardType with (nolock) where Parameter.CardType.CardType=@Type
--if(@BetRadarPlayerId<>0)
--	select @PlayerId=Parameter.TeamPlayer.TeamPlayerId,@TeamId=CompetitorId from Parameter.TeamPlayer with (nolock) where Parameter.TeamPlayer.BetradarPlayerId=@BetRadarPlayerId 

--if(@CardTypeId is not null)
--begin
--if EXISTS (select Match.Card.CardId from Match.Card  with (nolock) where Match.Card.BetradarCardId=@BetRadarPlayerId)
--	update Match.Card set CardTypeId=@CardTypeId,MatchId=@MatchId,Doubtful=@Doubtful,[Time]=@Time,PlayerId=@PlayerId,TeamId=@TeamId,PlayerName=@PlayerName
--	where Match.Card.BetradarCardId=@BetradarCardId
--else
--	insert Match.Card(BetradarCardId,Time,CardTypeId,PlayerId,MatchId,Doubtful,TeamId,PlayerName)
--	values (@BetradarCardId,@Time,@CardTypeId,@PlayerId,@MatchId,@Doubtful,@TeamId,@PlayerName)
--end



	
	
	

END


GO
