USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[GamePlatform.ProcEventOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[GamePlatform.ProcEventOne]
	@LangId int,
	@EventId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT        Virtual.Event.EventId,Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName, Language.[Parameter.Sport].SportName, Parameter.Sport.SportName AS SportNameOriginal, 
                         Parameter.Sport.Icon AS SportIcon, Parameter.Sport.IconColor AS SportIconColor, Language.ParameterCompetitor.CompetitorName AS HomeTeam, ParameterCompetiTip_1.CompetitorName AS AwayTeam, 
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
						 Virtual.[EventTopOdd].NextGoal2Id as NextGoal2Id,
						(SELECT  COUNT(DISTINCT Virtual.EventOdd.OddsTypeId) AS OddCount FROM   Virtual.EventOdd WHERE  (Virtual.EventOdd.IsActive = 1) AND (Virtual.EventOdd.OddResult IS NULL) AND (Virtual.EventOdd.IsCanceled IS NULL) AND (Virtual.EventOdd.IsEvaluated IS NULL) AND (Virtual.EventOdd.MatchId = Virtual.Event.EventId) ) as ExtraOddCount,
						 Virtual.[EventDetail].BetStatus,
						 Virtual.[Event].BetradarMatchId
FROM            Language.ParameterCompetitor INNER JOIN
                         Parameter.Competitor ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND 
                         Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND 
                         Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                         Virtual.Event INNER JOIN
                         Virtual.EventDetail ON Virtual.Event.EventId = Virtual.EventDetail.EventId INNER JOIN
                         Parameter.Tournament ON Virtual.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                         Language.[Parameter.Tournament] ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
                         Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId  AND Language.[Parameter.Tournament].LanguageId=@LangId  INNER JOIN
                         Language.[Parameter.Sport] ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND 
                         Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND Parameter.Sport.SportId = Language.[Parameter.Sport].SportId  AND Language.[Parameter.Sport].LanguageId=@LangId   INNER JOIN
                         Language.[Parameter.Category] ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND 
                         Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId  AND Language.[Parameter.Category].LanguageId=@LangId   ON Parameter.Competitor.CompetitorId = Virtual.Event.HomeTeam INNER JOIN
                         Parameter.Competitor AS CompetiTip_1 ON Virtual.Event.AwayTeam = CompetiTip_1.CompetitorId INNER JOIN
                         Language.ParameterCompetitor AS ParameterCompetiTip_1 ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId  AND ParameterCompetiTip_1.LanguageId=@LangId  INNER JOIN
                         Virtual.[Parameter.TimeStatu] ON Virtual.EventDetail.TimeStatu = Virtual.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 Virtual.[EventSetting] on Virtual.[EventSetting].MatchId=Virtual.Event.EventId INNER JOIN Virtual.[EventTopOdd] ON Virtual.[EventTopOdd].EventId=Virtual.[Event].EventId
Where Virtual.[Event].EventId=@EventId
 
 
END


GO
