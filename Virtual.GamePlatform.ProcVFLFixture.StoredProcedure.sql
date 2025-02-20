USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[GamePlatform.ProcVFLFixture]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[GamePlatform.ProcVFLFixture]
	@LangId int,
	@TournamentName nvarchar(max),
	@MatchDay varchar(15)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT        [Virtual].[Event].EventId,[Virtual].Tournament.Tournament as FullTournamentName, [Virtual].[Category].Category as CategoryName,  
                         t1.Team AS HomeTeam, t2.Team AS AwayTeam, 
                         Virtual.Event.EventDate, Virtual.EventDetail.IsActive, Virtual.EventDetail.EventStatu, Virtual.EventDetail.BetStatus, Virtual.EventDetail.MatchTime, Virtual.EventDetail.MatchTimeExtended, Virtual.EventDetail.Score, 
                         Virtual.EventDetail.TimeStatu, Virtual.[Parameter.TimeStatu].StatuColor, Virtual.[Parameter.TimeStatu].TimeStatu AS TimeStatuColor,
						 Virtual.[EventTopOdd].ThreeWay1 as ThreeWay1,
						 Virtual.[EventTopOdd].ThreeWayX as ThreeWayX,
						 Virtual.[EventTopOdd].ThreeWay2 as ThreeWay2,
						 Virtual.[EventTopOdd].RestThreeWay1 as RestThreeWay1,
						 Virtual.[EventTopOdd].RestThreeWayX as RestThreeWayX,
						 Virtual.[EventTopOdd].RestThreeWay2 as RestThreeWay2,
						 Virtual.[EventTopOdd].Total as Total,
						 Virtual.[EventTopOdd].TotalOver as TotalOver,
						 Virtual.[EventTopOdd].TotalUnder as TotalUnder,
						 Virtual.[EventTopOdd].NextGoal1 as NextGoal1,
						 Virtual.[EventTopOdd].NextGoalX as NextGoalX,
						 Virtual.[EventTopOdd].NextGoal2 as NextGoal2,
						 CASE WHEN (Virtual.[EventTopOdd].ThreeWay1State <> 1 or Virtual.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as ThreeWay1Visibility,
						 CASE WHEN (Virtual.[EventTopOdd].ThreeWayXState <> 1 or Virtual.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as ThreeWayXVisibility,
						 CASE WHEN (Virtual.[EventTopOdd].ThreeWay2State <> 1 or Virtual.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as ThreeWay2Visibility,
						 CASE WHEN (Virtual.[EventTopOdd].RestThreeWay1State <> 1 or Virtual.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as RestThreeWay1Visibility,
						 CASE WHEN (Virtual.[EventTopOdd].RestThreeWayXState <> 1 or Virtual.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as RestThreeWayXVisibility,
						 CASE WHEN (Virtual.[EventTopOdd].RestThreeWay2State <> 1 or Virtual.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as RestThreeWay2Visibility,
						 CASE WHEN (Virtual.[EventTopOdd].TotalOverState <> 1 or Virtual.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as TotalOverVisibility,
						 CASE WHEN (Virtual.[EventTopOdd].TotalUnderState <> 1 or Virtual.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as TotalUnderVisibility,
						 CASE WHEN (Virtual.[EventTopOdd].NextGoal1State <> 1 or Virtual.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as NextGoal1Visibility,
						 CASE WHEN (Virtual.[EventTopOdd].NextGoalXState <> 1 or Virtual.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as NextGoalXVisibility,
						 CASE WHEN (Virtual.[EventTopOdd].NextGoal2State <> 1 or Virtual.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as NextGoal2Visibility,
						 Virtual.[EventTopOdd].ThreeWay1Change as ThreeWay1Change,
						 Virtual.[EventTopOdd].ThreeWayXChange as ThreeWayXChange,
						 Virtual.[EventTopOdd].ThreeWay2Change as ThreeWay2Change,
						 Virtual.[EventTopOdd].RestThreeWay1Change as RestThreeWay1Change,
						 Virtual.[EventTopOdd].RestThreeWayXChange as RestThreeWayXChange,
						 Virtual.[EventTopOdd].RestThreeWay2Change as RestThreeWay2Change,
						 Virtual.[EventTopOdd].TotalOverChange as TotalOverChange,
						 Virtual.[EventTopOdd].TotalUnderChange as TotalUnderChange,
						 Virtual.[EventTopOdd].NextGoal1Change as NextGoal1Change,
						 Virtual.[EventTopOdd].NextGoalXChange as NextGoalXChange,
						 Virtual.[EventTopOdd].NextGoal2Change as NextGoal2Change,
						 Virtual.[EventTopOdd].ThreeWay1Id as ThreeWay1Id,
						 Virtual.[EventTopOdd].ThreeWayXId as ThreeWayXId,
						 Virtual.[EventTopOdd].ThreeWay2Id as ThreeWay2Id,
						 Virtual.[EventTopOdd].RestThreeWay1Id as RestThreeWay1Id,
						 Virtual.[EventTopOdd].RestThreeWayXId as RestThreeWayXId,
						 Virtual.[EventTopOdd].RestThreeWay2Id as RestThreeWay2Id,
						 Virtual.[EventTopOdd].TotalOverId as TotalOverId,
						 Virtual.[EventTopOdd].TotalUnderId as TotalUnderId,
						 Virtual.[EventTopOdd].NextGoal1Id as NextGoal1Id,
						 Virtual.[EventTopOdd].NextGoalXId as NextGoalXId,
						 Virtual.[EventTopOdd].NextGoal2Id as NextGoal2Id,
						(SELECT  COUNT(DISTINCT Virtual.EventOdd.OddsTypeId) AS OddCount FROM   Virtual.EventOdd WHERE  (Virtual.EventOdd.IsActive = 1) AND (Virtual.EventOdd.OddResult IS NULL) AND (Virtual.EventOdd.IsCanceled IS NULL) AND (Virtual.EventOdd.IsEvaluated IS NULL) AND (Virtual.EventOdd.MatchId = Virtual.Event.EventId) ) as ExtraOddCount,
						 Virtual.[EventDetail].BetStatus,
						 Virtual.[Event].TournamentName,
						 Virtual.[Event].MatchDay,
						 Virtual.[Event].BetradarMatchId,
						 t1.TeamId as HomeTeamId,
						 t2.TeamId as AwayTeamId
FROM            Virtual.Event INNER JOIN
                         Virtual.EventDetail ON Virtual.Event.EventId = Virtual.EventDetail.EventId INNER JOIN
                         Virtual.Tournament ON Virtual.Event.TournamentId = Virtual.Tournament.TournamentId INNER JOIN   
                         Virtual.[Category] ON Virtual.Tournament.CategoryId = Virtual.[Category].CategoryId INNER JOIN                                 
                         Virtual.[Parameter.TimeStatu] ON Virtual.EventDetail.TimeStatu = Virtual.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 Virtual.[EventSetting] on Virtual.[EventSetting].MatchId=Virtual.Event.EventId INNER JOIN Virtual.[EventTopOdd] ON Virtual.[EventTopOdd].EventId=Virtual.[Event].EventId
						inner join [Virtual].[Team] as t1 on t1.TeamId=Virtual.Event.HomeTeam
						inner join [Virtual].[Team] as t2 on t2.TeamId=Virtual.Event.AwayTeam
Where 
--Virtual.[EventSetting].StateId=2 and --Match State Open
--Virtual.[EventDetail].IsActive=1 and --Match Active
--Virtual.[EventDetail].TimeStatu not in (5,27,84) and
Virtual.[Event].TournamentName=@TournamentName and
Virtual.[Event].MatchDay=@MatchDay
order by  Virtual.[Event].TournamentName, Virtual.[Event].MatchDay
    
END


GO
