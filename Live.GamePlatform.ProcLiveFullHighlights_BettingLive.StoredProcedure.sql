USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcLiveFullHighlights_BettingLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Live].[GamePlatform.ProcLiveFullHighlights_BettingLive] 
@LangId int
AS

BEGIN

/****** [Live].[GamePlatform.ProcFixture]  ******/

SET NOCOUNT ON;

declare @TempTable table(MatchId bigint,CountBet int)

insert @TempTable
SELECT   top 30  Customer.SlipOdd.MatchId,count(Customer.SlipOdd.SlipId)
FROM         Customer.Slip with (nolock) INNER JOIN
                      Customer.SlipOdd with (nolock) ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId					  
WHERE    Customer.SlipOdd.BetTypeId=1 and Customer.SlipOdd.StateId=1
					  group by Customer.SlipOdd.MatchId

if ((select count(MatchId) from  @TempTable)<3)
begin
	insert @TempTable
	SELECT   Live.Event.EventId,1
		FROM       Live.Event with (nolock) INNER JOIN
                   Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
				   Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId
		Where
((Live.[EventSetting].StateId=2 and --Match State Open
Live.[EventDetail].IsActive=1 and --Match Active
Live.[EventDetail].TimeStatu not in (0,1,5,14,27,84,21,22,23,24,25,26,11,86,83)  and 
Live.[Event].ConnectionStatu=2) OR (Live.[EventDetail].TimeStatu=5 and DATEDIFF(MINUTE,  Live.[EventDetail].UpdatedDate,GETDATE())<2)  and 
Live.[Event].ConnectionStatu=2 OR (Live.[EventDetail].TimeStatu=1 and Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and Live.[EventDetail].IsActive=1 and Live.[EventDetail].BetStatus=2))
		
end


SELECT   top 5   temp.CountBet,  Live.Event.EventId,Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName, Language.[Parameter.Sport].SportName, Parameter.Sport.SportName AS SportNameOriginal, 
                         Parameter.Sport.Icon AS SportIcon, Parameter.Sport.IconColor AS SportIconColor, Language.ParameterCompetitor.CompetitorName AS HomeTeam, ParameterCompetiTip_1.CompetitorName AS AwayTeam, 
                         Live.Event.EventDate, Live.EventDetail.IsActive, Live.EventDetail.EventStatu, Live.EventDetail.BetStatus, Live.EventDetail.MatchTime, Live.EventDetail.MatchTimeExtended, Live.EventDetail.Score, 
                         Live.EventDetail.TimeStatu, Live.[Parameter.TimeStatu].StatuColor,  Language.[Parameter.LiveTimeStatu].TimeStatu AS TimeStatuColor,
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
						 Live.[EventTopOdd].NextGoalX as NextGoalX,
						 Live.[EventTopOdd].NextGoal2 as NextGoal2,
						 CASE WHEN (Live.[EventTopOdd].ThreeWay1State <> 1 or Live.[EventDetail].BetStatus<>2) or  (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.[EventTopOdd].ThreeWay1Id)>0 THEN 'hidden' ELSE (case when ThreeWay1 is null then 'hidden' else '' end) END as ThreeWay1Visibility,
						 CASE WHEN (Live.[EventTopOdd].ThreeWayXState <> 1 or Live.[EventDetail].BetStatus<>2) or  (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.[EventTopOdd].ThreeWayXId)>0 THEN 'hidden' ELSE (case when ThreeWayX is null then 'hidden' else '' end) END as ThreeWayXVisibility,
						 CASE WHEN (Live.[EventTopOdd].ThreeWay2State <> 1 or Live.[EventDetail].BetStatus<>2) or  (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.[EventTopOdd].ThreeWay2Id)>0 THEN 'hidden' ELSE (case when ThreeWay2 is null then 'hidden' else '' end) END as ThreeWay2Visibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWay1State <> 1 or Live.[EventDetail].BetStatus<>2) or  (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.[EventTopOdd].RestThreeWay1Id)>0 THEN 'hidden' ELSE (case when RestThreeWay1 is null then 'hidden' else '' end) END as RestThreeWay1Visibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWayXState <> 1 or Live.[EventDetail].BetStatus<>2) or  (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.[EventTopOdd].RestThreeWayXId)>0 THEN 'hidden' ELSE (case when RestThreeWayX is null then 'hidden' else '' end) END as RestThreeWayXVisibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWay2State <> 1 or Live.[EventDetail].BetStatus<>2) or  (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.[EventTopOdd].RestThreeWay2Id)>0 THEN 'hidden' ELSE (case when RestThreeWay2 is null then 'hidden' else '' end) END as RestThreeWay2Visibility,
						 CASE WHEN (Live.[EventTopOdd].TotalOverState <> 1 or Live.[EventDetail].BetStatus<>2) or  (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.[EventTopOdd].TotalOverId)>0 THEN 'hidden' ELSE (case when TotalOver is null then 'hidden' else '' end) END as TotalOverVisibility,
						 CASE WHEN (Live.[EventTopOdd].TotalUnderState <> 1 or Live.[EventDetail].BetStatus<>2   or Live.[EventTopOdd].TotalUnder is null) or  (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.[EventTopOdd].TotalUnderId)>0  THEN 'hidden' ELSE '' END as TotalUnderVisibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoal1State <> 1 or Live.[EventDetail].BetStatus<>2) or   (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.[EventTopOdd].NextGoal1Id)>0  THEN 'hidden' ELSE (case when NextGoal1 is null then 'hidden' else '' end) END as NextGoal1Visibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoalXState <> 1 or Live.[EventDetail].BetStatus<>2) or (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.[EventTopOdd].NextGoalXId)>0  THEN 'hidden' ELSE (case when NextGoalX is null then 'hidden' else '' end) END as NextGoalXVisibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoal2State <> 1 or Live.[EventDetail].BetStatus<>2) or (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.[EventTopOdd].NextGoal2Id)>0 THEN 'hidden' ELSE (case when NextGoal2 is null then 'hidden' else '' end) END as NextGoal2Visibility,
						 Live.[EventTopOdd].ThreeWay1Change as ThreeWay1Change,
						 Live.[EventTopOdd].ThreeWayXChange as ThreeWayXChange,
						 Live.[EventTopOdd].ThreeWay2Change as ThreeWay2Change,
						 Live.[EventTopOdd].RestThreeWay1Change as RestThreeWay1Change,
						 Live.[EventTopOdd].RestThreeWayXChange as RestThreeWayXChange,
						 Live.[EventTopOdd].RestThreeWay2Change as RestThreeWay2Change,
						 Live.[EventTopOdd].TotalOverChange as TotalOverChange,
						 Live.[EventTopOdd].TotalUnderChange as TotalUnderChange,
						 Live.[EventTopOdd].NextGoal1Change as NextGoal1Change,
						 Live.[EventTopOdd].NextGoalXChange as NextGoalXChange,
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
						 Live.[EventTopOdd].NextGoalXId as NextGoalXId,
						 Live.[EventTopOdd].NextGoal2Id as NextGoal2Id,
0 as ExtraOddCount,
						 Live.[EventDetail].BetStatus
FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
                         Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                         Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND Language.[Parameter.Tournament].LanguageId=@LangId  INNER JOIN
                         Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId   AND Language.[Parameter.Sport].LanguageId=@LangId   INNER JOIN
                         Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId  AND Language.[Parameter.Category].LanguageId=@LangId   ON Parameter.Competitor.CompetitorId = Live.Event.HomeTeam INNER JOIN
                         Parameter.Competitor AS CompetiTip_1 with (nolock) ON Live.Event.AwayTeam = CompetiTip_1.CompetitorId INNER JOIN
                         Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId  AND ParameterCompetiTip_1.LanguageId=@LangId  INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 Language.[Parameter.LiveTimeStatu] with (nolock) On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=@LangId INNER JOIN
						 Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId INNER JOIN Live.[EventTopOdd] ON Live.[EventTopOdd].EventId=Live.[Event].EventId  INNER JOIN
					  @TempTable AS temp ON Live.[EventDetail].EventId=temp.MatchId
Where
((Live.[EventSetting].StateId=2 and --Match State Open
Live.[EventDetail].IsActive=1 and --Match Active
Live.[EventDetail].TimeStatu not in (0,1,5,14,27,84,21,22,23,24,25,26,11,86,83)  and 
Live.[Event].ConnectionStatu=2) OR (Live.[EventDetail].TimeStatu=5 and DATEDIFF(MINUTE,  Live.[EventDetail].UpdatedDate,GETDATE())<2)  and 
Live.[Event].ConnectionStatu=2 OR (Live.[EventDetail].TimeStatu=1 AND Live.[EventTopOdd].ThreeWay1 is not null and Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and Live.[EventDetail].IsActive=1 and Live.[EventDetail].BetStatus=2))
Order by   temp.CountBet desc

END
GO
