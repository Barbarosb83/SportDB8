USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchGoal]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[ProcMatchGoal]
@MatchId bigint,
@FixtureId bigint,
@BetradarGoalId bigint,
@BetradarScoringTeam  nvarchar(20),
@Team1Score int,
@Team2Score int,
@BetradarPlayerId bigint,
@Time nvarchar(10),
@Doubtful bit,
@PlayerName nvarchar(250)

AS

declare @BetradarTeamType int=0

BEGIN


declare @PlayerId int=0
declare @TeamId int=0

--if(@BetradarPlayerId<>0)
--select @PlayerId=Parameter.TeamPlayer.TeamPlayerId from Parameter.TeamPlayer   with (nolock)  where Parameter.TeamPlayer.BetradarPlayerId=@BetradarPlayerId 

--if(@BetradarScoringTeam='HOME')
--	set @BetradarTeamType=1
--else
--	set @BetradarTeamType=2

--	select @TeamId=ISNULL(Match.FixtureCompetitor.CompetitorId,0) from Match.FixtureCompetitor with (nolock) where Match.FixtureCompetitor.FixtureId=@FixtureId and Match.FixtureCompetitor.TypeId=@BetradarTeamType

--if EXISTS (select Match.Goal.GoalId from Match.Goal with (nolock) where Match.Goal.BetradarGoalId=@BetradarGoalId)
--	update Match.Goal set MatchId=@MatchId,ScoringTeamId=@TeamId,Team1Score=@Team1Score,Team2Score=@Team2Score,PlayerId=@PlayerId,Time=@Time,Doubtful=@Doubtful,PlayerName=@PlayerName
--	where Match.Goal.BetradarGoalId=@BetradarGoalId
--else
--	insert Match.Goal (BetradarGoalId,MatchId,ScoringTeamId,Team1Score,Team2Score,PlayerId,Time,Doubtful,PlayerName)
--	values (@BetradarGoalId,@MatchId,@TeamId,@Team1Score,@Team2Score,@PlayerId,@Time,@Doubtful,@PlayerName)




	
	
	

END


GO
