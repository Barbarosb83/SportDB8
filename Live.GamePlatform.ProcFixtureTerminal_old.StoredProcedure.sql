USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcFixtureTerminal_old]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[GamePlatform.ProcFixtureTerminal_old]
	@LangId int,
	@SportId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tEventDetail
(

		[EventDetailId] [bigint]  NOT NULL,
	[EventId] [bigint] NOT NULL,
	 [IsActive] [bit] NULL,
	 [EventStatu] [int] NULL,
	 [BetStatus] [int] NULL,
	[LegScore] [nvarchar](100) NULL,
	 [MatchTime] [bigint] NULL,
	 [MatchTimeExtended] [nchar](15) NULL,
	 [Score] [nchar](15) NULL,
	[TimeStatu] [int] NULL
	,BetradarMatchIds bigint
	,TournamentName nvarchar(200)
	,CategoryName nvarchar(200)
	,SportName nvarchar(150)
	,SportNameOriginal nvarchar(150)
	,SportIcon nvarchar(250)
	,SportIconColor nvarchar(100)
	,HomeTeam nvarchar(150)
	,AwayTeam nvarchar(150)
	,EventDate datetime
	,StatuColor int
	,TimeStatuColor nvarchar(50)
	,HasStreaming bit
	,SportId int
	,SequenceNumber int )
-- CONSTRAINT [PK_EventDetaillFixtureTerminal] PRIMARY KEY CLUSTERED 
--(
--	[EventId] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]



insert #tEventDetail
select EventDetail.[EventDetailId],
	EventDetail.[EventId] ,
	 EventDetail.[IsActive],
	 EventDetail.[EventStatu],
	 EventDetail.[BetStatus] ,
	EventDetail.[LegScore] ,
	 EventDetail.[MatchTime] ,
	 EventDetail.[MatchTimeExtended] ,
	 EventDetail.[Score] ,
	EventDetail.[TimeStatu]
	,BetradarMatchIds ,
  Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName, Language.[Parameter.Sport].SportName, Parameter.Sport.SportName AS SportNameOriginal, 
                         Parameter.Sport.Icon AS SportIcon, Parameter.Sport.IconColor AS SportIconColor, Language.ParameterCompetitor.CompetitorName AS HomeTeam
						 , ParameterCompetiTip_1.CompetitorName AS AwayTeam, 
                         Live.Event.EventDate, 
                          Live.[Parameter.TimeStatu].StatuColor,  Language.[Parameter.LiveTimeStatu].TimeStatu AS TimeStatuColor
							
						 ,cast (0 as bit) AS HasStreaming,Parameter.Sport.SportId,ISNULL(Parameter.Category.SequenceNumber,999)
FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail as EventDetail ON Live.Event.EventId = EventDetail.EventId INNER JOIN
                         Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                         Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND Language.[Parameter.Tournament].LanguageId=@LangId  INNER JOIN
                         Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId   AND Language.[Parameter.Sport].LanguageId=@LangId   INNER JOIN
                         Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId  AND Language.[Parameter.Category].LanguageId=@LangId   ON Parameter.Competitor.CompetitorId = Live.Event.HomeTeam INNER JOIN
                         Parameter.Competitor  AS CompetiTip_1 with (nolock) ON Live.Event.AwayTeam = CompetiTip_1.CompetitorId INNER JOIN
                         Language.ParameterCompetitor  AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId  AND ParameterCompetiTip_1.LanguageId=@LangId  INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 Language.[Parameter.LiveTimeStatu] with (nolock) On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=@LangId INNER JOIN
						 Live.[EventSetting] on Live.[EventSetting].MatchId=Live.Event.EventId INNER JOIN Live.[EventTopOdd] with (nolock) ON Live.[EventTopOdd].EventId=Live.[Event].EventId 
Where
((Live.[EventSetting].StateId=2 and --Match State Open
EventDetail.IsActive=1 and --Match Active
EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  )  OR (EventDetail.TimeStatu=1 AND Live.[EventTopOdd].ThreeWay1 is not null and Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2)) 






if (@SportId=0)
begin
    
  
   SELECT    DIsTINCT    EventDetail.EventId,EventDetail.TournamentName, EventDetail.CategoryName, EventDetail.SportName, EventDetail.SportNameOriginal AS SportNameOriginal, 
                         EventDetail.SportIcon AS SportIcon, EventDetail.SportIconColor AS SportIconColor, EventDetail.HomeTeam, EventDetail.AwayTeam, 
                         EventDetail.EventDate, EventDetail.IsActive, EventDetail.EventStatu, EventDetail.BetStatus, EventDetail.MatchTime, EventDetail.MatchTimeExtended, EventDetail.Score, 
                         EventDetail.TimeStatu, EventDetail.StatuColor,  EventDetail.TimeStatuColor AS TimeStatuColor,
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
						 CASE WHEN (Live.[EventTopOdd].ThreeWay1State <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].ThreeWay1 is null)  THEN 'hidden' ELSE  ''   END as ThreeWay1Visibility,
						 CASE WHEN (Live.[EventTopOdd].ThreeWayXState <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].ThreeWayX is null) THEN 'hidden' ELSE '' END as ThreeWayXVisibility,
						 CASE WHEN (Live.[EventTopOdd].ThreeWay2State <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].ThreeWay2 is null) THEN 'hidden' ELSE  ''  END as ThreeWay2Visibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWay1State <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].RestThreeWay1 is null)  THEN 'hidden' ELSE   '' END as RestThreeWay1Visibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWayXState <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].RestThreeWayX is null) THEN 'hidden' ELSE   '' END as RestThreeWayXVisibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWay2State <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].RestThreeWay2 is null)   THEN 'hidden' ELSE ''  END as RestThreeWay2Visibility,
						 CASE WHEN (Live.[EventTopOdd].TotalOverState <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].TotalOver is null) THEN 'hidden' ELSE '' END as TotalOverVisibility,
						 CASE WHEN (Live.[EventTopOdd].TotalUnderState <> 1 or EventDetail.BetStatus<>2  or Live.[EventTopOdd].TotalUnder is null) THEN 'hidden' ELSE  ''  END as TotalUnderVisibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoal1State <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].NextGoal1 is null)   THEN 'hidden' ELSE ''  END as NextGoal1Visibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoalXState <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].NextGoalX is null)  THEN 'hidden' ELSE ''   END as NextGoalXVisibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoal2State <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].NextGoal2 is null)  THEN 'hidden' ELSE  ''END as NextGoal2Visibility,
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
(SELECT    
	COUNT(DISTINCT LiveEventOdd.OddsTypeId )
FROM      Live.EventOdd as   LiveEventOdd  with (nolock) INNER JOIN
                      Live.[Parameter.OddType]  with (nolock) on LiveEventOdd.OddsTypeId=Live.[Parameter.OddType].OddTypeId inner join
                     
                      live.[Parameter.Odds]  with (nolock) ON live.[Parameter.Odds].OddsId=LiveEventOdd.ParameterOddId
                       INNER JOIN
					   [Live].[Parameter.OddTypeGroupOddType]  with (nolock) ON  [Live].[Parameter.OddTypeGroupOddType].OddTypeId=LiveEventOdd.OddsTypeId
WHERE     LiveEventOdd.MatchId=EventDetail.EventId and LiveEventOdd.OddValue is not null
and (LiveEventOdd.IsActive = 1)
-- AND (LiveEventOdd.OddResult IS NULL) AND (LiveEventOdd.IsCanceled IS NULL) AND (LiveEventOdd.IsEvaluated IS NULL) 
and (Select Count(Live.EventOddResult.OddresultId) from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=LiveEventOdd.OddId)=0
and Live.[Parameter.OddType].IsActive=1  --and Live.[Parameter.OddType].OddTypeId=@LangId
and [Live].[Parameter.OddTypeGroupOddType].OddTypeGroupId = 12) as ExtraOddCount,
						 EventDetail.BetStatus
						 ,EventDetail.HasStreaming
						 	 ,EventDetail.LegScore as  GameScore 
FROM        #tEventDetail as EventDetail  INNER JOIN Live.[EventTopOdd] with (nolock) ON Live.[EventTopOdd].EventId=EventDetail.EventId   


end
else
begin

     SELECT    DIsTINCT    EventDetail.EventId,EventDetail.TournamentName, EventDetail.CategoryName, EventDetail.SportName, EventDetail.SportNameOriginal AS SportNameOriginal, 
                         EventDetail.SportIcon AS SportIcon, EventDetail.SportIconColor AS SportIconColor, EventDetail.HomeTeam, EventDetail.AwayTeam, 
                         EventDetail.EventDate, EventDetail.IsActive, EventDetail.EventStatu, EventDetail.BetStatus, EventDetail.MatchTime, EventDetail.MatchTimeExtended, EventDetail.Score, 
                         EventDetail.TimeStatu, EventDetail.StatuColor,  EventDetail.TimeStatuColor AS TimeStatuColor,
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
						 CASE WHEN (Live.[EventTopOdd].ThreeWay1State <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].ThreeWay1 is null)  THEN 'hidden' ELSE  ''   END as ThreeWay1Visibility,
						 CASE WHEN (Live.[EventTopOdd].ThreeWayXState <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].ThreeWayX is null) THEN 'hidden' ELSE '' END as ThreeWayXVisibility,
						 CASE WHEN (Live.[EventTopOdd].ThreeWay2State <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].ThreeWay2 is null) THEN 'hidden' ELSE  ''  END as ThreeWay2Visibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWay1State <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].RestThreeWay1 is null)  THEN 'hidden' ELSE   '' END as RestThreeWay1Visibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWayXState <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].RestThreeWayX is null) THEN 'hidden' ELSE   '' END as RestThreeWayXVisibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWay2State <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].RestThreeWay2 is null)   THEN 'hidden' ELSE ''  END as RestThreeWay2Visibility,
						 CASE WHEN (Live.[EventTopOdd].TotalOverState <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].TotalOver is null) THEN 'hidden' ELSE '' END as TotalOverVisibility,
						 CASE WHEN (Live.[EventTopOdd].TotalUnderState <> 1 or EventDetail.BetStatus<>2  or Live.[EventTopOdd].TotalUnder is null) THEN 'hidden' ELSE  ''  END as TotalUnderVisibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoal1State <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].NextGoal1 is null)   THEN 'hidden' ELSE ''  END as NextGoal1Visibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoalXState <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].NextGoalX is null)  THEN 'hidden' ELSE ''   END as NextGoalXVisibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoal2State <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].NextGoal2 is null)  THEN 'hidden' ELSE  ''END as NextGoal2Visibility,
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
(SELECT    
	COUNT(DISTINCT LiveEventOdd.OddsTypeId )
FROM      Live.EventOdd as   LiveEventOdd  with (nolock) INNER JOIN
                      Live.[Parameter.OddType]  with (nolock) on LiveEventOdd.OddsTypeId=Live.[Parameter.OddType].OddTypeId inner join
                     
                      live.[Parameter.Odds]  with (nolock) ON live.[Parameter.Odds].OddsId=LiveEventOdd.ParameterOddId
                       INNER JOIN
					   [Live].[Parameter.OddTypeGroupOddType]  with (nolock) ON  [Live].[Parameter.OddTypeGroupOddType].OddTypeId=LiveEventOdd.OddsTypeId
WHERE     LiveEventOdd.MatchId=EventDetail.EventId and LiveEventOdd.OddValue is not null
and (LiveEventOdd.IsActive = 1) 
--AND (LiveEventOdd.OddResult IS NULL) AND (LiveEventOdd.IsCanceled IS NULL) AND (LiveEventOdd.IsEvaluated IS NULL) 
and (Select Count(Live.EventOddResult.OddresultId) from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=LiveEventOdd.OddId)=0
and Live.[Parameter.OddType].IsActive=1  --and Live.[Parameter.OddType].OddTypeId=@LangId
and [Live].[Parameter.OddTypeGroupOddType].OddTypeGroupId = 12) as ExtraOddCount,
						 EventDetail.BetStatus
						 ,EventDetail.HasStreaming
						 	 ,EventDetail.LegScore as  GameScore 
FROM        #tEventDetail as EventDetail  INNER JOIN Live.[EventTopOdd] with (nolock) ON Live.[EventTopOdd].EventId=EventDetail.EventId  
where EventDetail.SportId=@SportId
--and live.[Event].EventDate<=DATEADD(MINUTE,10,GETDATE())
--and Live.[EventDetail].BetStatus in (2)  --BetStatus 1,2 olanlar listeye gelir
--Tarih de gelecek
--order by Parameter.Sport.SportId,Live.[Parameter.TimeStatu].TimeStatu desc,Live.EventDetail.MatchTime desc

end
    
END





GO
