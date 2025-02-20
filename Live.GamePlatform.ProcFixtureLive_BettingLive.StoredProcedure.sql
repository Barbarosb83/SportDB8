USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcFixtureLive_BettingLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[GamePlatform.ProcFixtureLive_BettingLive]
	@LangId int,
@SportId int,
@CategoryId int,
@TournamentId int
AS

BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE Table #tTopOdd
	(
	[EventId] [bigint] NOT NULL,
	[ThreeWay1] [float] NULL,
	[ThreeWayX] [float] NULL,
	[ThreeWay2] [float] NULL,
	[RestThreeWay1] [float] NULL,
	[RestThreeWayX] [float] NULL,
	[RestThreeWay2] [float] NULL,
	[Total] [nvarchar](50) NULL,
	[TotalOver] [float] NULL,
	[TotalUnder] [float] NULL,
	[NextGoal1] [float] NULL,
	[NextGoalX] [float] NULL,
	[NextGoal2] [float] NULL,
	[ThreeWay1State] [int] NULL,
	[ThreeWayXState] [int] NULL,
	[ThreeWay2State] [int] NULL,
	[RestThreeWay1State] [int] NULL,
	[RestThreeWayXState] [int] NULL,
	[RestThreeWay2State] [int] NULL,
	[TotalOverState] [int] NULL,
	[TotalUnderState] [int] NULL,
	[NextGoal1State] [int] NULL,
	[NextGoalXState] [int] NULL,
	[NextGoal2State] [int] NULL,
	[ThreeWay1Change] [int] NULL,
	[ThreeWayXChange] [int] NULL,
	[ThreeWay2Change] [int] NULL,
	[RestThreeWay1Change] [int] NULL,
	[RestThreeWayXChange] [int] NULL,
	[RestThreeWay2Change] [int] NULL,
	[TotalOverChange] [int] NULL,
	[TotalUnderChange] [int] NULL,
	[NextGoal1Change] [int] NULL,
	[NextGoalXChange] [int] NULL,
	[NextGoal2Change] [int] NULL,
	[ThreeWay1Id] [int] NULL,
	[ThreeWayXId] [int] NULL,
	[ThreeWay2Id] [int] NULL,
	[RestThreeWay1Id] [int] NULL,
	[RestThreeWayXId] [int] NULL,
	[RestThreeWay2Id] [int] NULL,
	[TotalOverId] [int] NULL,
	[TotalUnderId] [int] NULL,
	[NextGoal1Id] [int] NULL,
	[NextGoalXId] [int] NULL,
	[NextGoal2Id] [int] NULL,
	[BetradarMatchId] [bigint] NOT NULL
	)





 CREATE TABLE #tEventDetailFixtureLive
(
	[EventDetailId] [bigint]  NOT NULL,
	[EventId] [bigint] NOT NULL,
	 [IsActive] [bit] NULL,
	 [EventStatu] [int] NULL,
	 [BetStatus] [int] NULL,
	[LegScore] [nvarchar](100) NULL,
	[GameScore] [nvarchar](100) NULL,
	 [MatchTime] [bigint] NULL,
	 [MatchTimeExtended] [nchar](15) NULL,
	 [Score] [nchar](15) NULL,
	[TimeStatu] [int] NULL
	,BetradarMatchIds bigint NOT NULL
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
	,SequenceNumber int,CategoryId int,TournamentId int,TournamentSeqNumber int,RedCardTeam1 int,RedCardTeam2 int,BetStopReasonId int,BetStopreason nvarchar(200))


  CREATE TABLE #tempLiveOddFixtureLive
(

	[OddId] bigint  NOT NULL ,
	[OddsTypeId] int  NOT NULL,
	[OutCome] nvarchar(100)  ,
	[SpecialBetValue] nvarchar(100) ,
	[OddValue] float  ,
	[MatchId] bigint  NOT NULL ,
	[IsChanged] int ,
	[IsActive] bit  
)


 
  CREATE TABLE #tempLiveOddFixtureLive2
(
	[OddId] bigint  NOT NULL ,
	[OddsTypeId] int  NOT NULL,
	[OutCome] nvarchar(100) ,
	[SpecialBetValue] nvarchar(100) ,
	[OddValue] float ,
	[MatchId] bigint NOT NULL ,
	[IsChanged] int ,
	[IsActive] bit,
	[SpecialBetValue2] float
)


insert #tTopOdd
SELECT [EventId]
      ,[ThreeWay1]
      ,[ThreeWayX]
      ,[ThreeWay2]
      ,[RestThreeWay1]
      ,[RestThreeWayX]
      ,[RestThreeWay2]
      ,[Total]
      ,[TotalOver]
      ,[TotalUnder]
      ,[NextGoal1]
      ,[NextGoalX]
      ,[NextGoal2]
      ,[ThreeWay1State]
      ,[ThreeWayXState]
      ,[ThreeWay2State]
      ,[RestThreeWay1State]
      ,[RestThreeWayXState]
      ,[RestThreeWay2State]
      ,[TotalOverState]
      ,[TotalUnderState]
      ,[NextGoal1State]
      ,[NextGoalXState]
      ,[NextGoal2State]
      ,[ThreeWay1Change]
      ,[ThreeWayXChange]
      ,[ThreeWay2Change]
      ,[RestThreeWay1Change]
      ,[RestThreeWayXChange]
      ,[RestThreeWay2Change]
      ,[TotalOverChange]
      ,[TotalUnderChange]
      ,[NextGoal1Change]
      ,[NextGoalXChange]
      ,[NextGoal2Change]
      ,[ThreeWay1Id]
      ,[ThreeWayXId]
      ,[ThreeWay2Id]
      ,[RestThreeWay1Id]
      ,[RestThreeWayXId]
      ,[RestThreeWay2Id]
      ,[TotalOverId]
      ,[TotalUnderId]
      ,[NextGoal1Id]
      ,[NextGoalXId]
      ,[NextGoal2Id]
      ,[BetradarMatchId]
  FROM [Live].[EventTopOdd] with (nolock)


	 	insert #tempLiveOddFixtureLive
	select Live.EventOdd.[OddId]  ,
	Live.EventOdd.[OddsTypeId] ,
	Live.EventOdd.[OutCome],
	Live.EventOdd.[SpecialBetValue]  ,
	Live.EventOdd.[OddValue]  ,
	Live.EventOdd.[MatchId] ,
	Live.EventOdd.[IsChanged] ,
	Live.EventOdd.[IsActive] 
	    FROM           
                         Live.EventOdd with (nolock) 
						 where Live.EventOdd.OddsTypeId in (9,18,20,101,709,708,490,8,3,11,97,34,96)  and Live.EventOdd.IsActive=1  
						  and (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=live.EventOdd.OddId and IsCanceled=0)=0
						  --and Live.EventOdd.OddResult is null and Live.EventOdd.IsCanceled is null and Live.EventOdd.IsEvaluated is null


	insert #tempLiveOddFixtureLive2
	select Live.EventOdd.[OddId]  ,
	Live.EventOdd.[OddsTypeId] ,
	Live.EventOdd.[OutCome],
	Live.EventOdd.[SpecialBetValue]  ,
	Live.EventOdd.[OddValue]  ,
	Live.EventOdd.[MatchId] ,
	Live.EventOdd.[IsChanged] ,
	Live.EventOdd.[IsActive],cast(Live.EventOdd.[SpecialBetValue] as float)   FROM           
                         Live.EventOdd with (nolock)
						 where Live.EventOdd.OddsTypeId in (19,710) and Live.EventOdd.IsActive=1  
						  and (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=live.EventOdd.OddId  and IsCanceled=0)=0
						 --and Live.EventOdd.OddResult is null and Live.EventOdd.IsCanceled is null and Live.EventOdd.IsEvaluated is null


 

insert #tEventDetailFixtureLive
select EventDetail.[EventDetailId],
	EventDetail.[EventId] ,
	 EventDetail.[IsActive],
	 EventDetail.[EventStatu],
	 EventDetail.[BetStatus] ,
	EventDetail.[LegScore] ,
	EventDetail.GameScore ,
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
							
						 ,cast (0 as bit) AS HasStreaming,Parameter.Sport.SportId,ISNULL(Parameter.Category.SequenceNumber,99999),Language.[Parameter.Category].CategoryId,Parameter.Tournament.TerminalTournamentId as TournamentId
						 ,ISNULL(Parameter.Tournament.SequenceNumber,99999) ,ISNULL(EventDetail.RedCardsTeam1,0)+ISNULL(EventDetail.YellowRedCardsTeam1,0),ISNULL(EventDetail.RedCardsTeam2,0)+ISNULL(EventDetail.YellowRedCardsTeam2,0)
						  ,EventDetail.BetStopReasonId
						,Language.[Parameter.LiveBetStopReason].Reason as BetStopreason
FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail as EventDetail with (nolock) ON Live.Event.EventId = EventDetail.EventId INNER JOIN
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
						 Live.[EventSetting] with (nolock)  on Live.[EventSetting].MatchId=Live.Event.EventId INNER JOIN #tTopOdd as TPO with (nolock) ON TPO.EventId=Live.[Event].EventId 
						 INNER JOIN Language.[Parameter.LiveBetStopReason] On Language.[Parameter.LiveBetStopReason].ParameterReasonId=ISNULL(EventDetail.BetStopReasonId,0) and Language.[Parameter.LiveBetStopReason].LanguageId=@LangId
Where Parameter.Sport.SportId<>21 and
 Live.[EventSetting].StateId=2 and --Match State Open
EventDetail.IsActive=1 and --Match Active   
((EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  ) 
 OR (EventDetail.TimeStatu=1 AND TPO.ThreeWay1 is not null and Live.[Event].ConnectionStatu=2 
   and EventDetail.BetStatus=2) 
   OR (EventDetail.TimeStatu=5 and EventDetail.BetradarTimeStamp>DATEADD(SECOND,-30,GETDATE())) 
   )  
--and  Parameter.Sport.SportId=999


  
  
     SELECT    DIsTINCT   EventDetail.BetradarMatchIds as BetradarMatchId,  EventDetail.EventId,EventDetail.TournamentName, EventDetail.CategoryName, EventDetail.SportName, EventDetail.SportNameOriginal, 
                           cast(ISNULL((select Count(*) from #tEventDetailFixtureLive as ED where Ed.SportId=EventDetail.SportId),0) as nvarchar(50)) as  SportIcon
						   , EventDetail.SportIconColor, EventDetail.HomeTeam, EventDetail.AwayTeam, 
                         EventDetail.EventDate, EventDetail.IsActive, EventDetail.EventStatu, EventDetail.BetStatus, EventDetail.MatchTime
						 ,case when EventDetail.SportId=1 and EventDetail.TimeStatu=2 and EventDetail.MatchTime>45 and SUBSTRING(EventDetail.MatchTimeExtended,1, CHARINDEX(':',EventDetail.MatchTimeExtended)-1)<>'0' then  '45+'+ SUBSTRING(EventDetail.MatchTimeExtended,1, CHARINDEX(':',EventDetail.MatchTimeExtended)-1) else 
						 case when  EventDetail.SportId=1 and EventDetail.TimeStatu=4 and EventDetail.MatchTime>90 and SUBSTRING(EventDetail.MatchTimeExtended,1, CHARINDEX(':',EventDetail.MatchTimeExtended)-1)<>'0' then  '90+'+ SUBSTRING(EventDetail.MatchTimeExtended,1, CHARINDEX(':',EventDetail.MatchTimeExtended)-1)
						 else  cast(EventDetail.MatchTime as nvarchar(10)) end end as MatchTimeExtended
						 , EventDetail.Score, 
                         EventDetail.TimeStatu, EventDetail.StatuColor,  EventDetail.TimeStatuColor,EventDetail.SportId,EventDetail.CategoryId, EventDetail.TournamentId,

						 EventTopOdd.ThreeWay1 as OddValue1,
						 CASE WHEN (EventTopOdd.ThreeWay1State <> 1 or EventDetail.BetStatus<>2 or ThreeWay1 is null) THEN 'hidden' ELSE '' END as OddValue1Visibility,
						 EventTopOdd.ThreeWay1Change as Odd1Change,
						 	 EventTopOdd.ThreeWay1Id as OddId1,


						 EventTopOdd.ThreeWayX as OddValue2,
						 CASE WHEN (EventTopOdd.ThreeWayXState <> 1 or EventDetail.BetStatus<>2 or ThreeWayX is null) THEN 'hidden' ELSE '' END as OddValue2Visibility,
						 EventTopOdd.ThreeWayXChange as Odd2Change,
						 EventTopOdd.ThreeWayXId as OddId2,

						 EventTopOdd.ThreeWay2 as OddValue3,
						 CASE WHEN (EventTopOdd.ThreeWay2State <> 1 or EventDetail.BetStatus<>2 or ThreeWay2 is null) THEN 'hidden' ELSE '' END as OddValue3Visibility,
						 EventTopOdd.ThreeWay2Change as Odd3Change,
						 EventTopOdd.ThreeWay2Id as OddId3

						 	 ,EventTopOdd.NextGoal1Id as OddIdFirstScore_1
							  ,EventTopOdd.NextGoal1 as OddValueFirstScore_1
							  ,CASE WHEN (EventTopOdd.NextGoal1State <> 1 or EventDetail.BetStatus<>2 or NextGoal1 is null) THEN 'hidden' else ''  END as VisibilityFirstScore_1
							  ,EventTopOdd.NextGoal1Change as ChangeFirstScore_1


						,EventTopOdd.NextGoalX as OddValueFirstScore_None
						,CASE WHEN (EventTopOdd.NextGoalXState <> 1 or EventDetail.BetStatus<>2 or NextGoalX is null) THEN 'hidden'  else '' END as VisibilityFirstScore_None
						,EventTopOdd.NextGoalXChange as ChangeFirstScore_None
						 ,EventTopOdd.NextGoalXId as OddIdFirstScore_None


						 ,EventTopOdd.NextGoal2 as OddValueFirstScore_2
						 ,CASE WHEN (EventTopOdd.NextGoal2State <> 1 or EventDetail.BetStatus<>2 or NextGoal2 is null)  THEN 'hidden' ELSE  ''  END as NextGoal2Visibility
						 ,EventTopOdd.NextGoal2Change as  ChangeFirstScore_2
						  ,EventTopOdd.NextGoal2Id as OddIdFirstScore_2


						, EventTopOdd.RestThreeWay1 as RestThreeWay1
						,CASE WHEN (EventTopOdd.RestThreeWay1State <> 1 or EventDetail.BetStatus<>2 or RestThreeWay1 is null)  THEN 'hidden' else ''  END as RestThreeWay1Visibility
						,EventTopOdd.RestThreeWay1Change as RestThreeWay1Change
						,EventTopOdd.RestThreeWay1Id as RestThreeWay1Id


						 ,EventTopOdd.RestThreeWayX as RestThreeWayX
						 ,CASE WHEN (EventTopOdd.RestThreeWayXState <> 1 or EventDetail.BetStatus<>2 or RestThreeWayX is null) THEN 'hidden' ELSE  ''   END as RestThreeWayXVisibility
						 ,EventTopOdd.RestThreeWayXChange as RestThreeWayXChange
						 ,EventTopOdd.RestThreeWayXId as RestThreeWayXId

						 ,EventTopOdd.RestThreeWay2 as RestThreeWay2
						 ,CASE WHEN (EventTopOdd.RestThreeWay2State <> 1 or EventDetail.BetStatus<>2 or RestThreeWay2 is null) THEN 'hidden' ELSE '' END as RestThreeWay2Visibility
						 ,EventTopOdd.RestThreeWay2Change as RestThreeWay2Change
						 ,EventTopOdd.RestThreeWay2Id as RestThreeWay2Id

						 ,(select top 1 Half1x2_1.OddId  from #tempLiveOddFixtureLive as Half1x2_1 where Half1x2_1.MatchId=EventDetail.EventId and Half1x2_1.OddsTypeId=20  and Half1x2_1.OutCome='1') as  OddIdFirstHalf_1 
						 ,(select top 1 Half1x2_1.OddValue from #tempLiveOddFixtureLive as Half1x2_1 where Half1x2_1.MatchId=EventDetail.EventId and Half1x2_1.OddsTypeId=20  and Half1x2_1.OutCome='1')  as OddValueFirstHalf_1
						 ,(select top 1 Half1x2_1.IsChanged from #tempLiveOddFixtureLive as Half1x2_1 where Half1x2_1.MatchId=EventDetail.EventId and Half1x2_1.OddsTypeId=20  and Half1x2_1.OutCome='1') as ChangeFirstHalf_1
						 ,case when (select top 1 Half1x2_1.OddValue from #tempLiveOddFixtureLive as Half1x2_1 where Half1x2_1.MatchId=EventDetail.EventId and Half1x2_1.OddsTypeId=20  and Half1x2_1.OutCome='1') is null or  EventDetail.BetStatus<>2 then 'hidden' else '' end as VisibilityFirstHalf_1




					,(select top 1 Half1x2_X.OddId from  #tempLiveOddFixtureLive as Half1x2_X where  Half1x2_X.MatchId=EventDetail.EventId and Half1x2_X.OddsTypeId=20  and Half1x2_X.OutCome='x') as OddIdFirstHalf_X 
					,(select top 1 Half1x2_X.OddValue from  #tempLiveOddFixtureLive as Half1x2_X where  Half1x2_X.MatchId=EventDetail.EventId and Half1x2_X.OddsTypeId=20  and Half1x2_X.OutCome='x')  as OddValueFirstHalf_X
					,(select top 1 Half1x2_X.IsChanged from  #tempLiveOddFixtureLive as Half1x2_X where  Half1x2_X.MatchId=EventDetail.EventId and Half1x2_X.OddsTypeId=20  and Half1x2_X.OutCome='x')  as ChangeFirstHalf_X
				    ,case when (select top 1 Half1x2_X.OddValue from  #tempLiveOddFixtureLive as Half1x2_X where  Half1x2_X.MatchId=EventDetail.EventId and Half1x2_X.OddsTypeId=20  and Half1x2_X.OutCome='x')  is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as VisibilityFirstHalf_X



					,(select top 1 Half1x2_2.OddId from #tempLiveOddFixtureLive as Half1x2_2 where Half1x2_2.MatchId=EventDetail.EventId and Half1x2_2.OddsTypeId=20  and Half1x2_2.OutCome='2') as OddIdFirstHalf_2
					 ,(select top 1 Half1x2_2.OddValue from #tempLiveOddFixtureLive as Half1x2_2 where Half1x2_2.MatchId=EventDetail.EventId and Half1x2_2.OddsTypeId=20  and Half1x2_2.OutCome='2')  as OddValueFirstHalf_2
					,(select top 1 Half1x2_2.IsChanged from #tempLiveOddFixtureLive as Half1x2_2 where Half1x2_2.MatchId=EventDetail.EventId and Half1x2_2.OddsTypeId=20  and Half1x2_2.OutCome='2')  as ChangeFirstHalf_2
				    ,case when (select top 1 Half1x2_2.OddValue from #tempLiveOddFixtureLive as Half1x2_2 where Half1x2_2.MatchId=EventDetail.EventId and Half1x2_2.OddsTypeId=20  and Half1x2_2.OutCome='2') is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as VisibilityFirstHalf_2


						 ,(select top 1 HalfNG_1.OddId from  #tempLiveOddFixtureLive as HalfNG_1 where HalfNG_1.MatchId=EventDetail.EventId and HalfNG_1.OddsTypeId=101  and HalfNG_1.OutCome='1' and HalfNG_1.IsActive=1)  as  OddIdFirstHalfNG_1
						  ,(select top 1 HalfNG_1.OddValue from  #tempLiveOddFixtureLive as HalfNG_1 where HalfNG_1.MatchId=EventDetail.EventId and HalfNG_1.OddsTypeId=101  and HalfNG_1.OutCome='1' and HalfNG_1.IsActive=1)   as OddValueFirstHalfNG_1
						 ,(select top 1 HalfNG_1.IsChanged from  #tempLiveOddFixtureLive as HalfNG_1 where HalfNG_1.MatchId=EventDetail.EventId and HalfNG_1.OddsTypeId=101  and HalfNG_1.OutCome='1' and HalfNG_1.IsActive=1)  as ChangeFirstHalfNG_1
						 ,case when (select top 1  HalfNG_1.OddValue from  #tempLiveOddFixtureLive as HalfNG_1 where HalfNG_1.MatchId=EventDetail.EventId and HalfNG_1.OddsTypeId=101  and HalfNG_1.OutCome='1' and HalfNG_1.IsActive=1)  is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as VisibilityFirstHalfNG_1


					,(select top 1 HalfNG_X.OddId from #tempLiveOddFixtureLive as HalfNG_X where HalfNG_X.MatchId=EventDetail.EventId and HalfNG_X.OddsTypeId=101  and HalfNG_X.OutCome='x' and HalfNG_X.IsActive=1) as OddIdFirstHalfNG_X 
					,(select top 1 HalfNG_X.OddValue from #tempLiveOddFixtureLive as HalfNG_X where HalfNG_X.MatchId=EventDetail.EventId and HalfNG_X.OddsTypeId=101  and HalfNG_X.OutCome='x' and HalfNG_X.IsActive=1) as OddValueFirstHalfNG_X
					,(select top 1 HalfNG_X.IsChanged from #tempLiveOddFixtureLive as HalfNG_X where HalfNG_X.MatchId=EventDetail.EventId and HalfNG_X.OddsTypeId=101  and HalfNG_X.OutCome='x' and HalfNG_X.IsActive=1) as ChangeFirstHalfNG_X
						 ,case when (select top 1 HalfNG_X.OddValue  from #tempLiveOddFixtureLive as HalfNG_X where HalfNG_X.MatchId=EventDetail.EventId and HalfNG_X.OddsTypeId=101  and HalfNG_X.OutCome='x' and HalfNG_X.IsActive=1)  is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as VisibilityFirstHalfNG_X



					,(select top 1 HalfNG_2.OddId from #tempLiveOddFixtureLive as HalfNG_2 where HalfNG_2.MatchId=EventDetail.EventId and HalfNG_2.OddsTypeId=101  and HalfNG_2.OutCome='2' and HalfNG_2.IsActive=1) as OddIdFirstHalfNG_2 
					,(select top 1 HalfNG_2.OddValue  from #tempLiveOddFixtureLive as HalfNG_2 where HalfNG_2.MatchId=EventDetail.EventId and HalfNG_2.OddsTypeId=101  and HalfNG_2.OutCome='2' and HalfNG_2.IsActive=1) as OddValueFirstHalfNG_2
					,(select top 1 HalfNG_2.IsChanged  from #tempLiveOddFixtureLive as HalfNG_2 where HalfNG_2.MatchId=EventDetail.EventId and HalfNG_2.OddsTypeId=101  and HalfNG_2.OutCome='2' and HalfNG_2.IsActive=1) as ChangeFirstHalfNG_2
					,case when (select top 1 HalfNG_2.OddValue  from #tempLiveOddFixtureLive as HalfNG_2 where HalfNG_2.MatchId=EventDetail.EventId and HalfNG_2.OddsTypeId=101  and HalfNG_2.OutCome='2' and HalfNG_2.IsActive=1) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as VisibilityFirstHalfNG_2

						 ,(select top 1 HalfRS_1.OddId from #tempLiveOddFixtureLive as HalfRS_1 where HalfRS_1.MatchId=EventDetail.EventId and HalfRS_1.OddsTypeId=18  and HalfRS_1.OutCome='1' and HalfRS_1.IsActive=1) as  OddIdFirstHalfRS_1 
						 ,(select top 1 HalfRS_1.OddValue from #tempLiveOddFixtureLive as HalfRS_1 where HalfRS_1.MatchId=EventDetail.EventId and HalfRS_1.OddsTypeId=18  and HalfRS_1.OutCome='1' and HalfRS_1.IsActive=1)  as OddValueFirstHalfRS_1
						 ,(select top 1 HalfRS_1.IsChanged from #tempLiveOddFixtureLive as HalfRS_1 where HalfRS_1.MatchId=EventDetail.EventId and HalfRS_1.OddsTypeId=18  and HalfRS_1.OutCome='1' and HalfRS_1.IsActive=1) as ChangeFirstHalfRS_1
						 ,case when (select top 1 HalfRS_1.OddValue from #tempLiveOddFixtureLive as HalfRS_1 where HalfRS_1.MatchId=EventDetail.EventId and HalfRS_1.OddsTypeId=18  and HalfRS_1.OutCome='1' and HalfRS_1.IsActive=1) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as VisibilityFirstHalfRS_1
					
					
					
					,(select top 1 HalfRS_X.OddId from #tempLiveOddFixtureLive as HalfRS_X where HalfRS_X.MatchId=EventDetail.EventId and HalfRS_X.OddsTypeId=18  and HalfRS_X.OutCome='x'  and HalfRS_X.IsActive=1 ) as OddIdFirstHalfRS_X 
					,(select top 1 HalfRS_X.OddValue from #tempLiveOddFixtureLive as HalfRS_X where HalfRS_X.MatchId=EventDetail.EventId and HalfRS_X.OddsTypeId=18  and HalfRS_X.OutCome='x'  and HalfRS_X.IsActive=1 )  as OddValueFirstHalfRS_X
					,(select top 1 HalfRS_X.IsChanged from #tempLiveOddFixtureLive as HalfRS_X where HalfRS_X.MatchId=EventDetail.EventId and HalfRS_X.OddsTypeId=18  and HalfRS_X.OutCome='x'  and HalfRS_X.IsActive=1 )  as ChangeFirstHalfRS_X
				    ,case when (select top 1 HalfRS_X.OddValue from #tempLiveOddFixtureLive as HalfRS_X where HalfRS_X.MatchId=EventDetail.EventId and HalfRS_X.OddsTypeId=18  and HalfRS_X.OutCome='x'  and HalfRS_X.IsActive=1 )  is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as VisibilityFirstHalfRS_X
					
					
					,(select top 1 HalfRS_2.OddId from #tempLiveOddFixtureLive as HalfRS_2 where HalfRS_2.MatchId=EventDetail.EventId and HalfRS_2.OddsTypeId=18  and HalfRS_2.OutCome='2' and HalfRS_2.IsActive=1 ) as OddIdFirstHalfRS_2 
					,(select top 1 HalfRS_2.OddValue  from #tempLiveOddFixtureLive as HalfRS_2 where HalfRS_2.MatchId=EventDetail.EventId and HalfRS_2.OddsTypeId=18  and HalfRS_2.OutCome='2' and HalfRS_2.IsActive=1 ) as OddValueFirstHalfRS_2
					,(select top 1 HalfRS_2.IsChanged  from #tempLiveOddFixtureLive as HalfRS_2 where HalfRS_2.MatchId=EventDetail.EventId and HalfRS_2.OddsTypeId=18  and HalfRS_2.OutCome='2' and HalfRS_2.IsActive=1 ) as ChangeFirstHalfRS_2
				,case when (select top 1  HalfRS_2.OddValue  from #tempLiveOddFixtureLive as HalfRS_2 where HalfRS_2.MatchId=EventDetail.EventId and HalfRS_2.OddsTypeId=18  and HalfRS_2.OutCome='2' and HalfRS_2.IsActive=1 ) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as VisibilityFirstHalfRS_2


						 ,(select top 1 TennisFirstSet1.OddId from #tempLiveOddFixtureLive as TennisFirstSet1 where TennisFirstSet1.MatchId=EventDetail.EventId and TennisFirstSet1.OddsTypeId=9  and TennisFirstSet1.OutCome='1' and TennisFirstSet1.IsActive=1  and TennisFirstSet1.SpecialBetValue='1' ) as OddIdTennisFirstSet1 
						 ,(select top 1 TennisFirstSet1.OddValue from #tempLiveOddFixtureLive as TennisFirstSet1 where TennisFirstSet1.MatchId=EventDetail.EventId and TennisFirstSet1.OddsTypeId=9  and TennisFirstSet1.OutCome='1' and TennisFirstSet1.IsActive=1  and TennisFirstSet1.SpecialBetValue='1' )  as OddValueTennisFirstSet1
					,(select top 1 TennisFirstSet1.IsChanged from #tempLiveOddFixtureLive as TennisFirstSet1 where TennisFirstSet1.MatchId=EventDetail.EventId and TennisFirstSet1.OddsTypeId=9  and TennisFirstSet1.OutCome='1' and TennisFirstSet1.IsActive=1  and TennisFirstSet1.SpecialBetValue='1' )  as ChangeTennisFirstSet1
						 ,case when (select top 1  TennisFirstSet1.OddValue  from #tempLiveOddFixtureLive as TennisFirstSet1 where TennisFirstSet1.MatchId=EventDetail.EventId and TennisFirstSet1.OddsTypeId=9  and TennisFirstSet1.OutCome='1' and TennisFirstSet1.IsActive=1  and TennisFirstSet1.SpecialBetValue='1' )  is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as VisibilityTennisFirstSet1



					,(select top 1 TennisFirstSet2.OddId from #tempLiveOddFixtureLive as TennisFirstSet2 where TennisFirstSet2.MatchId=EventDetail.EventId and TennisFirstSet2.OddsTypeId=9  and TennisFirstSet2.OutCome='2' and TennisFirstSet2.IsActive=1  and TennisFirstSet2.SpecialBetValue='1' ) as OddIdTennisFirstSet2 
					,(select top 1 TennisFirstSet2.OddValue  from #tempLiveOddFixtureLive as TennisFirstSet2 where TennisFirstSet2.MatchId=EventDetail.EventId and TennisFirstSet2.OddsTypeId=9  and TennisFirstSet2.OutCome='2' and TennisFirstSet2.IsActive=1  and TennisFirstSet2.SpecialBetValue='1' )  as OddValueTennisFirstSet2
					,(select top 1 TennisFirstSet2.IsChanged  from #tempLiveOddFixtureLive as TennisFirstSet2 where TennisFirstSet2.MatchId=EventDetail.EventId and TennisFirstSet2.OddsTypeId=9  and TennisFirstSet2.OutCome='2' and TennisFirstSet2.IsActive=1  and TennisFirstSet2.SpecialBetValue='1' )  as ChangeTennisFirstSet2
						 ,case when (select top 1 TennisFirstSet2.OddValue  from #tempLiveOddFixtureLive as TennisFirstSet2 where TennisFirstSet2.MatchId=EventDetail.EventId and TennisFirstSet2.OddsTypeId=9  and TennisFirstSet2.OutCome='2' and TennisFirstSet2.IsActive=1  and TennisFirstSet2.SpecialBetValue='1' )  is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as VisibilityTennisFirstSet2

						 ,(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1  order by SpecialBetValue2) as Total1
						 ,(select top 1 OddId from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1   order by SpecialBetValue2) as Total1OverOddId
						 ,(select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1   order by SpecialBetValue2) as Total1OverOddValue
						 ,(select top 1 IsChanged from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) as Total1OverChange
						  , case when (select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as Total1OverVisibilty

						 ,(select top 1 OddId from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1    order by SpecialBetValue2) as Total1UnderOddId
						 ,(select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1   order by SpecialBetValue2) as Total1UnderOddValue
						 ,(select top 1 IsChanged from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1  order by SpecialBetValue2) as Total1UnderChange
						 ,case when (select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1  order by SpecialBetValue2) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as Total1UnderVisibilty

						  ,(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as Total2
						 ,(select top 1 OddId from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as Total2OverOddId
						 ,(select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as Total2OverOddValue
						 ,(select top 1 IsChanged from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as Total2OverChange
						 ,case when  (select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)  is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as Total2OverVisibilty

						 ,(select top 1 OddId from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as Total2UnderOddId
						 ,(select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as Total2UnderOddValue
						 ,(select top 1 IsChanged from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as Total2UnderChange
						 ,case when (select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)  is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as Total2UnderVisibilty
						
					,(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)  order by SpecialBetValue2 ) as Total3
						 ,(select top 1 OddId from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)   order by SpecialBetValue2 ) as Total3OverOddId
						 ,(select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)   order by SpecialBetValue2 ) as Total3OverOddValue
						 ,(select top 1 IsChanged from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)   order by SpecialBetValue2 ) as Total3OverChange
						 ,case when (select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)   order by SpecialBetValue2 )  is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as Total3OverVisibilty

						 ,(select top 1 OddId from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)    order by SpecialBetValue2 ) as Total3UnderOddId
						 ,(select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)  order by SpecialBetValue2 ) as Total3UnderOddValue
						 ,(select top 1 IsChanged from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)  order by SpecialBetValue2 ) as Total3UnderChange
						 ,case when (select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1  and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) order by SpecialBetValue2 ) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as Total3UnderVisibilty




						  ,(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1  order by SpecialBetValue2) as HalfTotal1
						 ,(select top 1 OddId from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1    order by SpecialBetValue2) as HalfTotal1OverOddId
						 ,(select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1   order by SpecialBetValue2) as HalfTotal1OverOddValue
						 ,(select top 1 IsChanged from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) as HalfTotal1OverChange
						  , case when (select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as HalfTotal1OverVisibilty

						 ,(select top 1 OddId from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1    order by SpecialBetValue2) as HalfTotal1UnderOddId
						 ,(select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1   order by SpecialBetValue2) as HalfTotal1UnderOddValue
						 ,(select top 1 IsChanged from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1  order by SpecialBetValue2) as HalfTotal1UnderChange
						 ,case when (select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1  order by SpecialBetValue2) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as HalfTotal1UnderVisibilty

						  ,(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as HalfTotal2
						 ,(select top 1 OddId from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as HalfTotal2OverOddId
						 ,(select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as HalfTotal2OverOddValue
						 ,(select top 1 IsChanged from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as HalfTotal2OverChange
						 ,case when  (select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as HalfTotal2OverVisibilty

						 ,(select top 1 OddId from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as HalfTotal2UnderOddId
						 ,(select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as HalfTotal2UnderOddValue
						 ,(select top 1 IsChanged from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) as HalfTotal2UnderChange
						 ,case when (select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as HalfTotal2UnderVisibilty
						
					,(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)  order by SpecialBetValue2 ) as HalfTotal3
						 ,(select top 1 OddId from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)   order by SpecialBetValue2 ) as HalfTotal3OverOddId
						 ,(select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)   order by SpecialBetValue2 ) as HalfTotal3OverOddValue
						 ,(select top 1 IsChanged from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)   order by SpecialBetValue2 ) as HalfTotal3OverChange
						 ,case when (select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)   order by SpecialBetValue2 )  is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as HalfTotal3OverVisibilty

						 ,(select top 1 OddId from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)    order by SpecialBetValue2 ) as HalfTotal3UnderOddId
						 ,(select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)  order by SpecialBetValue2 ) as HalfTotal3UnderOddValue
						 ,(select top 1 IsChanged from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2)  order by SpecialBetValue2 ) as HalfTotal3UnderChange
						 ,case when (select top 1 OddValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1  and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 and SpecialBetValue>(select top 1 SpecialBetValue from #tempLiveOddFixtureLive2 where OddsTypeId=19 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1 order by SpecialBetValue2)  order by SpecialBetValue2) order by SpecialBetValue2 ) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end as HalfTotal3UnderVisibilty
						 ,EventDetail.BetStatus
						 ,EventDetail.HasStreaming
						 	 ,RTRIM(EventDetail.LegScore) as  GameScore 
							 ,EventDetail.SequenceNumber,case when EventDetail.SportId<>3 then EventDetail.GameScore else SUBSTRING(RTRIM(EventDetail.LegScore),LEN(RTRIM(EventDetail.LegScore))-2,3) end as LegScore
							  ,EventDetail.TournamentSeqNumber,EventDetail.RedCardTeam1,EventDetail.RedCardTeam2
							  ,EventDetail.BetStopReasonId,EventDetail.BetStopreason
FROM        #tEventDetailFixtureLive as EventDetail  INNER JOIN #tTopOdd as   EventTopOdd with (nolock) ON EventTopOdd.EventId=EventDetail.EventId   order by EventDetail.SportId


end
GO
