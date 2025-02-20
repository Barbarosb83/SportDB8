USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[TV.ProcFixture_old]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[TV.ProcFixture_old]
	@LangId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	 CREATE TABLE #tEventDetailTV1
(
	[EventDetailId] [bigint]  NOT NULL,
	[EventId] [bigint] NOT NULL,
	 [IsActive] [bit] NULL,
	 [EventStatu] [int] NULL,
	 [BetStatus] [int] NULL,
	[LegScore] [nvarchar](100) NULL,
	 [MatchTime] [bigint] NULL,
	 [MatchTimeExtended] [nchar](15) NULL,
	 MatchServer [int],
	 [Score] [nchar](100) NULL,
	[TimeStatu] [int] NULL
	,BetradarMatchIds [bigint]  NOT NULL
	,SportId [int]  NOT NULL
	,TournamentName [nvarchar](200) NULL
	,CategoryName [nvarchar](200)  NULL
	,SportName [nvarchar](150) NULL
 ,SportNameOriginal [nvarchar](150) NULL
 ,SportIcon [nvarchar](250) NULL
 ,SportIconColor [nvarchar](100) NULL
 ,HomeTeam [nvarchar](150) NULL
 ,AwayTeam [nvarchar](150) NULL
 ,EventDate [datetime] NULL
 ,StatuColor [int] NULL
 ,TimeStatuColor [nvarchar](50) NULL
 ,HasStreaming [bit] NULL 
 ,Reason [nvarchar](50) NULL
 ,IsoName [nvarchar](5) NULL
 ,ParameterReasonId [int] NULL
 ,SquanceNumber [int] NULL
 ,Code [nvarchar](20) NULL
 )
  
insert INTO  #tEventDetailTV1
select EventDetail.[EventDetailId],
	EventDetail.[EventId] ,
	 EventDetail.[IsActive],
	 EventDetail.[EventStatu],
	 EventDetail.[BetStatus] ,
	EventDetail.[LegScore] ,
	 EventDetail.[MatchTime] ,
	 EventDetail.[MatchTimeExtended] ,
	  EventDetail.MatchServer ,
	 EventDetail.[Score] ,
	EventDetail.[TimeStatu]
	,BetradarMatchIds ,Parameter.Sport.SportId,Language.[Parameter.Tournament].TournamentName,Language.[Parameter.Category].CategoryName,Language.[Parameter.Sport].SportName
,Parameter.Sport.SportName as SportOrginal ,Parameter.Sport.Icon AS SportIcon
						 , Parameter.Sport.IconColor AS SportIconColor
						 , Language.ParameterCompetitor.CompetitorName AS HomeTeam
						 , ParameterCompetiTip_1.CompetitorName AS AwayTeam, Live.Event.EventDate, Live.[Parameter.TimeStatu].StatuColor
						 ,  Language.[Parameter.LiveTimeStatu].TimeStatu AS TimeStatuColor,Live.EventLiveStreaming.Web AS HasStreaming,
						 Language.[Parameter.LiveBetStopReason].Reason,
						 Parameter.Iso.IsoName, Language.[Parameter.LiveBetStopReason].ParameterReasonId,
						 Parameter.Sport.SquanceNumber,Match.Code.Code
from Language.ParameterCompetitor with (nolock) INNER JOIN
                       
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = EventDetail.EventId INNER JOIN
                         Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                         Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND Language.[Parameter.Tournament].LanguageId=@LangId  INNER JOIN
                         Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId   AND Language.[Parameter.Sport].LanguageId=@LangId   INNER JOIN
                         Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId  AND Language.[Parameter.Category].LanguageId=@LangId   ON Language.ParameterCompetitor.LanguageId=@LangId and Language.ParameterCompetitor.CompetitorId = Live.Event.HomeTeam INNER JOIN
                         Language.ParameterCompetitor  AS ParameterCompetiTip_1 with (nolock) ON ParameterCompetiTip_1.CompetitorId = Live.Event.AwayTeam  AND ParameterCompetiTip_1.LanguageId=@LangId  INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 Language.[Parameter.LiveTimeStatu] with (nolock) On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=@LangId INNER JOIN
						 Live.EventSetting with (nolock) On Live.EventSetting.MatchId=Live.Event.EventId INNER JOIN
						 Live.[EventTopOdd] with (nolock) ON Live.[EventTopOdd].EventId=Live.[Event].EventId LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Live.Event.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId INNER JOIN
						 Match.Code with (nolock) On Match.Code.BetradarMatchId=Live.Event.BetradarMatchId LEFT OUTER JOIN
						 Language.[Parameter.LiveBetStopReason] with (nolock) ON Language.[Parameter.LiveBetStopReason].ParameterReasonId=EventDetail.BetStopReasonId and Language.[Parameter.LiveBetStopReason].LanguageId=@LangId INNER JOIN
						 Parameter.Iso On Parameter.Iso.IsoId=Parameter.Category.IsoId
Where
((Live.[EventSetting].StateId=2 and --Match State Open
EventDetail.IsActive=1 and --Match Active
EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  )  OR (EventDetail.TimeStatu=5 and DATEDIFF(SECOND, EventDetail.BetradarTimeStamp,GETDATE())<10)   OR (EventDetail.TimeStatu=1 AND Live.[EventTopOdd].ThreeWay1 is not null and Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2))  
 



 
  
	 CREATE TABLE #tempLiveOddTV
(
	[OddId] bigint ,
	[OddsTypeId] int,
	[OutCome] nvarchar(100) ,
	[SpecialBetValue] nvarchar(100) ,
	[OddValue] float ,
	[MatchId] bigint ,
	[BettradarOddId] bigint ,
	[Suggestion] float ,
	[ParameterOddId] int ,
	[IsOddValueLock] bit ,
	[IsChanged] int ,
	[IsActive] bit,
	[OddResult] bit ,
	[VoidFactor] float ,
	[IsCanceled] bit ,
	[IsEvaluated] bit ,
	[OddFactor] float,
	[BetradarTimeStamp] datetime ,
	[UpdatedDate] datetime ,
	[BetradarMatchId] bigint ,
	[EvaluatedDate] datetime,BetradarOddsTypeId bigint,BetradarOddsSubTypeId bigint,StateId int )

 	insert #tempLiveOddTV
	select Live.EventOdd.*  FROM           
                          #tEventDetailTV1 as TDetail INNER JOIN
						 Live.EventOdd with (nolock) ON Live.EventOdd.MatchId=TDetail.EventId and ( Live.EventOdd.OddsTypeId in (10,77) ) and TDetail.SportId=5
						 and (Select Count(Live.EventOddResult.OddresultId) from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=live.EventOdd.OddId)=0
						 and  Live.EventOdd.IsActive=1




  CREATE TABLE #tempLiveOddTV2
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


	insert #tempLiveOddTV2
	select Live.EventOdd.[OddId]  ,
	Live.EventOdd.[OddsTypeId] ,
	Live.EventOdd.[OutCome],
	Live.EventOdd.[SpecialBetValue]  ,
	Live.EventOdd.[OddValue]  ,
	Live.EventOdd.[MatchId] ,
	Live.EventOdd.[IsChanged] ,
	Live.EventOdd.[IsActive],cast(Live.EventOdd.[SpecialBetValue] as float)   FROM           
                         Live.EventOdd with (nolock)
						 where Live.EventOdd.OddsTypeId in (710) and Live.EventOdd.IsActive=1  
						  and (Select Count(Live.EventOddResult.OddresultId) from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=live.EventOdd.OddId and IsCanceled<>1)=0

    
   SELECT    DIsTINCT EventDetail.Code,EventDetail.EventId
   ,EventDetail.TournamentName
   , EventDetail.CategoryName
   , EventDetail.SportName
   , EventDetail.SportNameOriginal, 
                         EventDetail.SportIcon
						 , EventDetail.SportIconColor
						 , EventDetail.HomeTeam
						 ,EventDetail.AwayTeam, 
                         EventDetail.EventDate, EventDetail.IsActive, EventDetail.EventStatu, EventDetail.BetStatus, EventDetail.MatchTime, EventDetail.MatchTimeExtended, EventDetail.Score, 
                         EventDetail.TimeStatu
						 , EventDetail.StatuColor
						 ,  EventDetail.TimeStatuColor,
						 Live.[EventTopOdd].ThreeWay1 as ThreeWay1,
						 Live.[EventTopOdd].ThreeWayX as ThreeWayX,
						 Live.[EventTopOdd].ThreeWay2 as ThreeWay2,
						 Live.[EventTopOdd].RestThreeWay1 as RestThreeWay1,
						 Live.[EventTopOdd].RestThreeWayX as RestThreeWayX,
						 Live.[EventTopOdd].RestThreeWay2 as RestThreeWay2,
						 case when SportId<>1 then Live.[EventTopOdd].Total else case when (select   COUNT(SpecialBetValue) from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  )>0 then  cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  order by SpecialBetValue2 desc) as nvarchar(10)) else cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) as nvarchar(10)) end end as Total,
						 case when SportId<>1 then  Live.[EventTopOdd].TotalOver else cast((select top 1 OddValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1   and SpecialBetValue=case when (select   COUNT(SpecialBetValue) from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  )>0 then  cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  order by SpecialBetValue2 desc) as nvarchar(10)) else cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) as nvarchar(10)) end) as float) end as TotalOver,
						 case when SportId<>1 then Live.[EventTopOdd].TotalUnder else cast((select top 1 OddValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1  and SpecialBetValue=case when (select   COUNT(SpecialBetValue) from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  )>0 then  cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  order by SpecialBetValue2 desc) as nvarchar(10)) else cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) as nvarchar(10)) end) as float) end as TotalUnder,
						 Live.[EventTopOdd].NextGoal1 as NextGoal1,
						 Live.[EventTopOdd].NextGoalX as NextGoalX,
						 Live.[EventTopOdd].NextGoal2 as NextGoal2,
						 CASE WHEN (Live.[EventTopOdd].ThreeWay1State <> 1 or ThreeWay1 is null or EventDetail.BetStatus<>2) THEN 'hidden' ELSE  ''   END as ThreeWay1Visibility,
						 CASE WHEN (Live.[EventTopOdd].ThreeWayXState <> 1 or ThreeWayX is null or EventDetail.BetStatus<>2)  THEN 'hidden' ELSE  ''   END as ThreeWayXVisibility,
						 CASE WHEN (Live.[EventTopOdd].ThreeWay2State <> 1 or ThreeWay2 is null or EventDetail.BetStatus<>2) THEN 'hidden' ELSE '' END as ThreeWay2Visibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWay1State <> 1 or RestThreeWay1 is null or EventDetail.BetStatus<>2) THEN 'hidden' ELSE  '' END as RestThreeWay1Visibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWayXState <> 1 or RestThreeWayX is null or EventDetail.BetStatus<>2)  THEN 'hidden' ELSE  ''  END as RestThreeWayXVisibility,
						 CASE WHEN (Live.[EventTopOdd].RestThreeWay2State <> 1 or RestThreeWay2 is null or EventDetail.BetStatus<>2)   THEN 'hidden' ELSE '' END as RestThreeWay2Visibility,
						 case when SportId<>1 then CASE WHEN (Live.[EventTopOdd].TotalOverState <> 1 or EventDetail.BetStatus<>2 or Live.[EventTopOdd].TotalOver is null) THEN 'hidden' ELSE ''  END else  case when (select top 1 OddValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  and SpecialBetValue=case when (select   COUNT(SpecialBetValue) from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  )>0 then  cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  order by SpecialBetValue2 desc) as nvarchar(10)) else cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) as nvarchar(10)) end) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end  end as TotalOverVisibility,
						 case when SportId<>1 then CASE WHEN (Live.[EventTopOdd].TotalUnderState <> 1 or EventDetail.BetStatus<>2  or Live.[EventTopOdd].TotalUnder is null) THEN 'hidden' ELSE  ''  END else case when (select top 1 OddValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1  and SpecialBetValue=case when (select   COUNT(SpecialBetValue) from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  )>0 then  cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  order by SpecialBetValue2 desc) as nvarchar(10)) else cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) as nvarchar(10)) end) is null or EventDetail.BetStatus<>2 then 'hidden' else '' end end  as TotalUnderVisibility,
						 --CASE WHEN (Live.[EventTopOdd].TotalOverState <> 1 or TotalOver is null or EventDetail.BetStatus<>2 )  THEN 'hidden' ELSE  '' END as TotalOverVisibility,
						 --CASE WHEN (Live.[EventTopOdd].TotalUnderState <> 1 or TotalUnder is null or EventDetail.BetStatus<>2)  THEN 'hidden' ELSE  ''  END as TotalUnderVisibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoal1State <> 1 or NextGoal1 is null or EventDetail.BetStatus<>2) THEN 'hidden' ELSE   ''  END as NextGoal1Visibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoalXState <> 1 or NextGoalX is null or EventDetail.BetStatus<>2 )  THEN 'hidden' ELSE  ''  END as NextGoalXVisibility,
						 CASE WHEN (Live.[EventTopOdd].NextGoal2State <> 1 or NextGoal2 is null or EventDetail.BetStatus<>2) THEN 'hidden' ELSE   ''  END as NextGoal2Visibility,
						 Live.[EventTopOdd].ThreeWay1Change as ThreeWay1Change,
						 Live.[EventTopOdd].ThreeWayXChange as ThreeWayXChange,
						 Live.[EventTopOdd].ThreeWay2Change as ThreeWay2Change,
						 Live.[EventTopOdd].RestThreeWay1Change as RestThreeWay1Change,
						 Live.[EventTopOdd].RestThreeWayXChange as RestThreeWayXChange,
						 Live.[EventTopOdd].RestThreeWay2Change as RestThreeWay2Change,
						 case when SportId <>1 then Live.[EventTopOdd].TotalOverChange else cast((select top 1 IsChanged from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  and SpecialBetValue=case when (select   COUNT(SpecialBetValue) from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  )>0 then  cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  order by SpecialBetValue2 desc) as nvarchar(10)) else cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) as nvarchar(10)) end) as int) end as TotalOverChange,
						 case when SportId <>1 then Live.[EventTopOdd].TotalUnderChange else cast((select top 1 IsChanged from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1  and SpecialBetValue=case when (select   COUNT(SpecialBetValue) from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  )>0 then  cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  order by SpecialBetValue2 desc) as nvarchar(10)) else cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) as nvarchar(10)) end) as int) end as TotalUnderChange,
						 --Live.[EventTopOdd].TotalOverChange as TotalOverChange,
						 --Live.[EventTopOdd].TotalUnderChange as TotalUnderChange,
						 Live.[EventTopOdd].NextGoal1Change as NextGoal1Change,
						 Live.[EventTopOdd].NextGoalXChange as NextGoalXChange,
						 Live.[EventTopOdd].NextGoal2Change as NextGoal2Change,
						 Live.[EventTopOdd].ThreeWay1Id as ThreeWay1Id,
						 Live.[EventTopOdd].ThreeWayXId as ThreeWayXId,
						 Live.[EventTopOdd].ThreeWay2Id as ThreeWay2Id,
						 Live.[EventTopOdd].RestThreeWay1Id as RestThreeWay1Id,
						 Live.[EventTopOdd].RestThreeWayXId as RestThreeWayXId,
						 Live.[EventTopOdd].RestThreeWay2Id as RestThreeWay2Id,
						 case when SportId<>1 then Live.[EventTopOdd].TotalOverId else cast((select top 1 OddId from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  and SpecialBetValue=case when (select   COUNT(SpecialBetValue) from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  )>0 then  cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  order by SpecialBetValue2 desc) as nvarchar(10)) else cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) as nvarchar(10)) end) as int)  end as TotalOverId,
						 case when SportId<>1 then Live.[EventTopOdd].TotalUnderId else cast((select top 1 OddId from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='u' and IsActive=1    and SpecialBetValue=case when (select   COUNT(SpecialBetValue) from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  )>0 then  cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1 and Oddvalue<=2.7  order by SpecialBetValue2 desc) as nvarchar(10)) else cast((select top 1 SpecialBetValue from #tempLiveOddTV2 where OddsTypeId=710 and MatchId=EventDetail.EventId and OutCome='o' and IsActive=1  order by SpecialBetValue2) as nvarchar(10)) end) as int) end as TotalUnderId,
						 --Live.[EventTopOdd].TotalOverId as TotalOverId,
						 --Live.[EventTopOdd].TotalUnderId as TotalUnderId,
						 Live.[EventTopOdd].NextGoal1Id as NextGoal1Id,
						 Live.[EventTopOdd].NextGoalXId as NextGoalXId,
						 Live.[EventTopOdd].NextGoal2Id as NextGoal2Id,
0 as ExtraOddCount,
						 EventDetail.BetStatus
						 ,EventDetail.HasStreaming,
						 EventDetail.Reason,
						 EventDetail.IsoName,
						 EventDetail.MatchServer,
						 EventDetail.ParameterReasonId,
						 EventDetail.SquanceNumber
						 ,EventDetail.LegScore as  GameScore 
						 ,(select top 1  SpecialBetValue from #tempLiveOddTV where ParameterOddId=23 and MatchId=EventDetail.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1   Order by  SpecialBetValue asc) as TenisSpecialComment
						 ,(select top 1  OddValue from #tempLiveOddTV where ParameterOddId=23 and MatchId=EventDetail.EventId    Order by  SpecialBetValue asc) as TenisSpecial1
						 ,(select top 1  OddValue from #tempLiveOddTV where ParameterOddId=24 and MatchId=EventDetail.EventId   Order by  SpecialBetValue asc) as TenisSpecialX
						 ,(select top 1  OddValue from #tempLiveOddTV where ParameterOddId=25 and MatchId=EventDetail.EventId   Order by  SpecialBetValue asc) as TenisSpecial2
						 ,CASE WHEN ((select top 1 OddValue from #tempLiveOddTV where ParameterOddId=23 and MatchId=EventDetail.EventId  ORDER BY SpecialBetValue asc) is null or EventDetail.BetStatus<>2) or ((select top 1 OddValue from #tempLiveOddTV where ParameterOddId=23 and MatchId=EventDetail.EventId ORDER BY SpecialBetValue asc)=1  ) THEN 'hidden' ELSE '' END as TenisSpecial1Visiblty
						 ,CASE WHEN ((select top 1 OddValue from #tempLiveOddTV where ParameterOddId=24 and MatchId=EventDetail.EventId ORDER BY SpecialBetValue asc) is null or EventDetail.BetStatus<>2) or ((select top 1 OddValue from #tempLiveOddTV where ParameterOddId=24 and MatchId=EventDetail.EventId  ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TenisSpecialXVisiblty
						 ,CASE WHEN ((select top 1 OddValue from #tempLiveOddTV where ParameterOddId=25 and MatchId=EventDetail.EventId   ORDER BY SpecialBetValue asc) is null or EventDetail.BetStatus<>2) or ((select top 1 OddValue from #tempLiveOddTV where ParameterOddId=25 and MatchId=EventDetail.EventId ORDER BY SpecialBetValue asc)=1  ) THEN 'hidden' ELSE '' END as TenisSpecial2Visiblty
						 ,(select top 1  IsChanged from #tempLiveOddTV where ParameterOddId=23 and MatchId=EventDetail.EventId  ORDER BY SpecialBetValue asc) as TenisSpecial1Change
						 ,(select top 1  IsChanged from #tempLiveOddTV where ParameterOddId=24 and MatchId=EventDetail.EventId  ORDER BY SpecialBetValue asc) as TenisSpecialXChange
						 ,(select top 1  IsChanged from #tempLiveOddTV where ParameterOddId=25 and MatchId=EventDetail.EventId  ORDER BY SpecialBetValue asc) as TenisSpecial2Change

						 ,(select top 1  SpecialBetValue from #tempLiveOddTV where OddsTypeId=77 and  OutCome='under' and MatchId=EventDetail.EventId   Order by  SpecialBetValue asc) as TenisTotal
						 ,(select top 1  OddValue from #tempLiveOddTV where OddsTypeId=77 and  OutCome='under' and MatchId=EventDetail.EventId  Order by  SpecialBetValue asc) as TenisTotalUnder
						 ,(select top 1  OddValue from #tempLiveOddTV where OddsTypeId=77 and  OutCome='over' and MatchId=EventDetail.EventId  Order by  SpecialBetValue asc) as TenisTotalOver
						 ,CASE WHEN ((select top 1 OddValue from #tempLiveOddTV where OddsTypeId=77 and  OutCome='under' and MatchId=EventDetail.EventId ORDER BY SpecialBetValue asc) is null or EventDetail.BetStatus<>2) or ((select top 1 OddValue from #tempLiveOddTV where OddsTypeId=77 and  OutCome='under' and MatchId=EventDetail.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1 ) THEN 'hidden' ELSE '' END as TenisTotalUnderVisiblty
						 ,CASE WHEN ((select top 1 OddValue from #tempLiveOddTV where OddsTypeId=77 and  OutCome='over' and MatchId=EventDetail.EventId   ORDER BY SpecialBetValue asc) is null or EventDetail.BetStatus<>2) or ((select top 1 OddValue from #tempLiveOddTV where OddsTypeId=77 and  OutCome='over' and MatchId=EventDetail.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1 ) THEN 'hidden' ELSE '' END as TenisTotalOverVisiblty
						 ,(select top 1  IsChanged from #tempLiveOddTV where OddsTypeId=77 and  OutCome='under' and MatchId=EventDetail.EventId   ORDER BY SpecialBetValue asc) as TenisTotalUnderChange
						 ,(select top 1  IsChanged from #tempLiveOddTV where OddsTypeId=77 and  OutCome='over' and MatchId=EventDetail.EventId   ORDER BY SpecialBetValue asc) as TenisTotalOverChange

FROM       
                         #tEventDetailTV1 as EventDetail INNER JOIN Live.[EventTopOdd] with (nolock) ON Live.[EventTopOdd].EventId=EventDetail.EventId


  
  end
GO
