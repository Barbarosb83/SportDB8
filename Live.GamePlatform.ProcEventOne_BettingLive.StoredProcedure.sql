USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcEventOne_BettingLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[GamePlatform.ProcEventOne_BettingLive]
	@LangId int,
	@EventId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT        Live.Event.EventId,Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName, Language.[Parameter.Sport].SportName, Parameter.Sport.SportName AS SportNameOriginal, 
                         Parameter.Sport.Icon AS SportIcon, Parameter.Sport.IconColor AS SportIconColor, Language.ParameterCompetitor.CompetitorName AS HomeTeam, ParameterCompetiTip_1.CompetitorName AS AwayTeam, 
                         Live.Event.EventDate, Live.EventDetail.IsActive, Live.EventDetail.EventStatu, Live.EventDetail.BetStatus, Live.EventDetail.MatchTime, Live.EventDetail.MatchTimeExtended, Live.EventDetail.Score, 
                         Live.EventDetail.TimeStatu, Live.[Parameter.TimeStatu].StatuColor, Live.[Parameter.TimeStatu].TimeStatu AS TimeStatuColor,
						 Live.[EventTopOdd].ThreeWay1 as ThreeWay1,
						 Live.[EventTopOdd].ThreeWayX as ThreeWayX,
						 Live.[EventTopOdd].ThreeWay2 as ThreeWay2,
						 Live.[EventTopOdd].RestThreeWay1 as RestThreeWay1,
						 Live.[EventTopOdd].RestThreeWayX as RestThreeWayX,
						 Live.[EventTopOdd].RestThreeWay2 as RestThreeWay2,
						 Live.[EventTopOdd].Total as Total,
						 Live.[EventTopOdd].TotalOver as TotalOver,
						 Live.[EventTopOdd].TotalUnder as TotalUnder,
						 Live.[EventTopOdd].NextGoal1 as NextGoal1,
						 Live.[EventTopOdd].NextGoal2 as NextGoal2,
						 CASE WHEN (Live.[EventTopOdd].ThreeWay1State <> 1 or Live.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as ThreeWay1Visibility,
						 CASE WHEN (Live.[EventTopOdd].ThreeWayXState <> 1 or Live.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as ThreeWayXVisibility,
						 CASE WHEN (Live.[EventTopOdd].ThreeWay2State <> 1 or Live.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as ThreeWay2Visibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWay1State <> 1 or Live.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as RestThreeWay1Visibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWayXState <> 1 or Live.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as RestThreeWayXVisibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWay2State <> 1 or Live.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as RestThreeWay2Visibility,
						 CASE WHEN (Live.[EventTopOdd].TotalOverState <> 1 or Live.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as TotalOverVisibility,
						 CASE WHEN (Live.[EventTopOdd].TotalUnderState <> 1 or Live.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as TotalUnderVisibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoal1State <> 1 or Live.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as NextGoal1Visibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoal2State <> 1 or Live.[EventDetail].BetStatus<>2) THEN 'hidden' ELSE '' END as NextGoal2Visibility,
						 Live.[EventTopOdd].ThreeWay1Change as ThreeWay1Change,
						 Live.[EventTopOdd].ThreeWayXChange as ThreeWayXChange,
						 Live.[EventTopOdd].ThreeWay2Change as ThreeWay2Change,
						 Live.[EventTopOdd].RestThreeWay1Change as RestThreeWay1Change,
						 Live.[EventTopOdd].RestThreeWayXChange as RestThreeWayXChange,
						 Live.[EventTopOdd].RestThreeWay2Change as RestThreeWay2Change,
						 Live.[EventTopOdd].TotalOverChange as TotalOverChange,
						 Live.[EventTopOdd].TotalUnderChange as TotalUnderChange,
						 Live.[EventTopOdd].NextGoal1Change as NextGoal1Change,
						 Live.[EventTopOdd].NextGoal2Change as NextGoal2Change,
						 Live.[EventTopOdd].ThreeWay1Id as ThreeWay1Id,
						 Live.[EventTopOdd].ThreeWayXId as ThreeWayXId,
						 Live.[EventTopOdd].ThreeWay2Id as ThreeWay2Id,
						 Live.[EventTopOdd].RestThreeWay1Id as RestThreeWay1Id,
						 Live.[EventTopOdd].RestThreeWayXId as RestThreeWayXId,
						 Live.[EventTopOdd].RestThreeWay2Id as RestThreeWay2Id,
						 Live.[EventTopOdd].TotalOverId as TotalOverId,
						 Live.[EventTopOdd].TotalUnderId as TotalUnderId,
						 Live.[EventTopOdd].NextGoal1Id as NextGoal1Id,
						 Live.[EventTopOdd].NextGoal2Id as NextGoal2Id,
						(SELECT  COUNT(DISTINCT Live.EventOdd.OddsTypeId) AS OddCount FROM   Live.EventOdd with (nolock) WHERE  (Live.EventOdd.IsActive = 1) 
						and (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=live.EventOdd.OddId)=0 )
						as ExtraOddCount,
						 Live.[EventDetail].BetStatus,
						 Live.[Event].BetradarMatchId
FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND 
                         Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND 
                         Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
                         Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                         Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
                         Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId  AND Language.[Parameter.Tournament].LanguageId=@LangId  INNER JOIN
                         Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND 
                         Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND Parameter.Sport.SportId = Language.[Parameter.Sport].SportId  AND Language.[Parameter.Sport].LanguageId=@LangId   INNER JOIN
                         Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND 
                         Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId  AND Language.[Parameter.Category].LanguageId=@LangId   ON Parameter.Competitor.CompetitorId = Live.Event.HomeTeam INNER JOIN
                         Parameter.Competitor AS CompetiTip_1 with (nolock) ON Live.Event.AwayTeam = CompetiTip_1.CompetitorId INNER JOIN
                         Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId  AND ParameterCompetiTip_1.LanguageId=@LangId  INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 Live.[EventTopOdd] ON Live.[EventTopOdd].EventId=Live.[Event].EventId
Where Live.[Event].EventId=@EventId
 
 
END


GO
