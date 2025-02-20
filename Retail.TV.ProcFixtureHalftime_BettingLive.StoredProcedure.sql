USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[TV.ProcFixtureHalftime_BettingLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Retail].[TV.ProcFixtureHalftime_BettingLive]
	@LangId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
declare @tempLiveOdd table (
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
	[EvaluatedDate] datetime,BetradarOddsTypeId bigint,BetradarOddsSubTypeId bigint ,StateId int )



	insert @tempLiveOdd
	select Live.EventOdd.*  FROM           
                         Live.Event with (nolock) INNER JOIN
						 Live.EventOdd with (nolock) ON Live.EventOdd.MatchId=Live.Event.EventId and (Live.EventOdd.ParameterOddId in (50,51,52,53,54,55,56,57,358,359,360) or Live.EventOdd.OddsTypeId in (78,79,80,81,82,9,709,27) )INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
						 Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId   INNER JOIN
						   Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId and Parameter.Sport.SportId in (1,5) 
						 
Where
 Live.EventOdd.IsActive=1 and  (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=live.EventOdd.OddId)=0 and
((Live.[EventDetail].TimeStatu  in (2) and Live.[EventSetting].StateId=2 and Live.[EventDetail].IsActive=1 ) 
or 
(Live.[EventSetting].StateId=2 and EventDetail.IsActive=1  and EventDetail.TimeStatu not in (0,1,2,5,14,15,27,84,21,22,23,24,25,26,11,86,83))  
OR 
(EventDetail.TimeStatu=1 AND  Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2))
 



	--declare @temptable table (EventId bigint,ThreeWay1 float,ThreeWayX float,ThreeWay2 float,RestThreeWay1 float,RestThreeWayX float,RestThreeWay2 float,Total nvarchar(10),TotalUnder float,TotalOver float,NextGol1 float,NextGolX float,NextGol2 float
	--,ThreeWay1Visibility nvarchar(15),ThreeWay2Visibility nvarchar(15),ThreeWay3Visibility nvarchar(15),RestThreeWay1Visibility nvarchar(15),RestThreeWayXVisibility nvarchar(15),RestThreeWay2Visibility nvarchar(15),TotalUnderVisibility nvarchar(15)
	--,TotalOverVisibility nvarchar(15),NextGoal1Visibility nvarchar(15),NextGoalXVisibility nvarchar(15),NextGoal2Visibility nvarchar(15)
	--,ThreeWay1Change int,ThreeWayXChange int,ThreeWay2Change int,RestThreeWay1Change int,RestThreeWayXChange int,RestThreeWay2Change int,TotalUnderChange int,TotalOverChange int,NextGol1Change int,NextGolXChange int,NextGol2Change int
	--,ThreeWay1Id bigint,ThreeWayXId bigint,ThreeWay2Id bigint,RestThreeWay1Id bigint,RestThreeWayXId bigint,RestThreeWay2Id bigint,TotalUnderId bigint,TotalOverId bigint,NextGol1Id bigint,NextGolXId bigint,NextGol2Id bigint)
  

 
    
  
  --insert @temptable
select Live.Event.EventId
,'1.Halbzeit [HZ]' as ThreeWayComment
,(select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId ) as ThreeWay1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId ) as ThreeWayX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId ) as ThreeWay2,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId Order by  SpecialBetValue asc) as RestThreeWay1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId  Order by  SpecialBetValue asc) as RestThreeWayX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId Order by  SpecialBetValue asc) as RestThreeWay2,
(select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId   Order by  SpecialBetValue asc) as Total,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId   Order by  SpecialBetValue asc) as TotalUnder,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId  Order by  SpecialBetValue asc) as TotalOver
,(select top 1 OddValue from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId    Order by  SpecialBetValue desc) as NextGol1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId   Order by  SpecialBetValue desc) as NextGolX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId Order by  SpecialBetValue desc) as NextGol2
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as ThreeWay1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as ThreeWay2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as ThreeWay3Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as RestThreeWay1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as RestThreeWayXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as RestThreeWay2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId  ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalOverVisibility
						,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as NextGoal1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as NextGoalXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as NextGoal2Visibility
						 ,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId) as ThreeWay1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId) as ThreeWayXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId) as ThreeWay2Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as RestThreeWay1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as RestThreeWayXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as RestThreeWay2Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalUnderChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalOverChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as NextGol1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as NextGolXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as NextGol2Change
,null as ThreeWay1Id,
null as ThreeWayXId,
null as ThreeWay2Id,
null as RestThreeWay1Id,
null as RestThreeWayXId,
null as RestThreeWay2Id,
null as TotalUnderId,
null as TotalOverId
,null as NextGol1Id,
null as NextGolXId,
null as NextGol2Id
						
FROM           
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 --Language.[Parameter.LiveTimeStatu] On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=@LangId INNER JOIN
						 Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId  LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Live.Event.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId INNER JOIN 
						   Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId
						 
Where Parameter.Sport.SportId=1 and
Live.[EventDetail].TimeStatu in (2) 
UNION ALL
select Live.Event.EventId
,(select top 1 SpecialBetValue from @tempLiveOdd where OddsTypeId=9 and OutCome='1' and MatchId=Live.Event.EventId and (IsEvaluated IS NULL) and (OddResult is null) and IsActive=1 ORDer By SpecialBetValue)+'.Satz [HZ]' as ThreeWayComment
,(select top 1 OddValue from @tempLiveOdd where OddsTypeId=9 and OutCome='1' and MatchId=Live.Event.EventId ORDer By SpecialBetValue) as ThreeWay1
,(select top 1 OddValue from @tempLiveOdd where OddsTypeId=9 and OutCome='x' and MatchId=Live.Event.EventId ORDer By SpecialBetValue) as ThreeWayX
,(select top 1 OddValue from @tempLiveOdd where OddsTypeId=9 and OutCome='2' and MatchId=Live.Event.EventId ORDer By SpecialBetValue) as ThreeWay2,
null as RestThreeWay1,
null as RestThreeWayX,
null as RestThreeWay2,
(select top 1 SpecialBetValue from @tempLiveOdd where OddsTypeId in (78,79,80,81,82) and OutCome='under' and MatchId=Live.Event.EventId  ORDer By OddsTypeId asc,SpecialBetValue desc) as Total,
(select top 1 OddValue from @tempLiveOdd where OddsTypeId in (78,79,80,81,82) and OutCome='under' and MatchId=Live.Event.EventId  ORDer By OddsTypeId asc,SpecialBetValue desc) as TotalUnder,
(select top 1 OddValue from @tempLiveOdd where OddsTypeId in (78,79,80,81,82) and OutCome='over' and MatchId=Live.Event.EventId ORDer By OddsTypeId asc,SpecialBetValue desc) as TotalOver
,null as NextGol1,
null as NextGolX,
null as NextGol2
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where OddsTypeId=9 and OutCome='1' and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where OddsTypeId=9 and OutCome='1' and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as ThreeWay1Visibility
						 ,'hidden'  as ThreeWay2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where OddsTypeId=9 and OutCome='2' and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where OddsTypeId=9 and OutCome='2' and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as ThreeWay3Visibility 
						 , 'hidden'   as RestThreeWay1Visibility
						 ,  'hidden'  as RestThreeWayXVisibility
						 ,  'hidden'  as RestThreeWay2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where OddsTypeId in (78,79,80,81,82) and OutCome='under' and MatchId=Live.Event.EventId ORDER BY OddsTypeId asc,SpecialBetValue desc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where OddsTypeId in (78,79,80,81,82) and OutCome='under' and MatchId=Live.Event.EventId ORDER BY OddsTypeId asc,SpecialBetValue desc)=1) THEN 'hidden' ELSE '' END as TotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where OddsTypeId in (78,79,80,81,82) and OutCome='over' and MatchId=Live.Event.EventId ORDER BY OddsTypeId asc,SpecialBetValue desc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where OddsTypeId in (78,79,80,81,82) and OutCome='over' and MatchId=Live.Event.EventId ORDER BY OddsTypeId asc,SpecialBetValue desc)=1) THEN 'hidden' ELSE '' END as TotalOverVisibility
						, 'hidden'  as NextGoal1Visibility
						 ,'hidden'   as NextGoalXVisibility
						 , 'hidden'   as NextGoal2Visibility
						 ,(select top 1 IsChanged from @tempLiveOdd where OddsTypeId=9 and OutCome='1' and MatchId=Live.Event.EventId) as ThreeWay1Change,
null as ThreeWayXChange,
(select top 1  IsChanged from @tempLiveOdd where OddsTypeId=9 and OutCome='2' and MatchId=Live.Event.EventId) as ThreeWay2Change,
null as RestThreeWay1Change,
null as RestThreeWayXChange,
null as RestThreeWay2Change,
(select top 1 IsChanged from @tempLiveOdd where OddsTypeId in (78,79,80,81,82) and OutCome='under' and MatchId=Live.Event.EventId ORDer By OddsTypeId asc,SpecialBetValue desc) as TotalUnderChange,
(select top 1 IsChanged from @tempLiveOdd where OddsTypeId in (78,79,80,81,82) and OutCome='over' and MatchId=Live.Event.EventId ORDer By OddsTypeId asc,SpecialBetValue desc) as TotalOverChange
,null as NextGol1Change,
null as NextGolXChange,
null as NextGol2Change
,null as ThreeWay1Id,
null as ThreeWayXId,
null as ThreeWay2Id,
null as RestThreeWay1Id,
null as RestThreeWayXId,
null as RestThreeWay2Id,
null as TotalUnderId,
null as TotalOverId
,null as NextGol1Id,
null as NextGolXId,
null as NextGol2Id
						
FROM           
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 --Language.[Parameter.LiveTimeStatu] On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=@LangId INNER JOIN
						 Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId  LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Live.Event.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId INNER JOIN 
						   Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId and  Parameter.Sport.SportId=5
						 
Where 
 Live.[EventSetting].StateId=2 and --Match State Open
Live.[EventDetail].IsActive=1  and ((Live.[EventSetting].StateId=2   and--Match Active
EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  ) OR
 (EventDetail.TimeStatu=1 AND  Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2  and EventDetail.BetStatus=2))
UNION ALL
select Live.Event.EventId
,'Handicap '+(select top 1 SpecialBetValue from @tempLiveOdd where OddsTypeId=709 and MatchId=Live.Event.EventId and OddValue<2.70 ORDer By OddValue desc,SpecialBetValue)+' [HC]' as ThreeWayComment
,(select top 1 OddValue from @tempLiveOdd where OddsTypeId=709 and OutCome='1' and MatchId=Live.Event.EventId and SpecialBetValue=(select top 1 SpecialBetValue from @tempLiveOdd where OddsTypeId=709 and MatchId=Live.Event.EventId and OddValue<2.70 ORDer By OddValue desc,SpecialBetValue)) as ThreeWay1
,(select top 1 OddValue from @tempLiveOdd where OddsTypeId=709 and OutCome='x' and MatchId=Live.Event.EventId and SpecialBetValue=(select top 1 SpecialBetValue from @tempLiveOdd where OddsTypeId=709 and MatchId=Live.Event.EventId and OddValue<2.70 ORDer By OddValue desc,SpecialBetValue)) as ThreeWayX
,(select top 1 OddValue from @tempLiveOdd where OddsTypeId=709 and OutCome='2' and MatchId=Live.Event.EventId and SpecialBetValue=(select top 1 SpecialBetValue from @tempLiveOdd where OddsTypeId=709 and MatchId=Live.Event.EventId and OddValue<2.70 ORDer By OddValue desc,SpecialBetValue)) as ThreeWay2,
null as RestThreeWay1,
null as RestThreeWayX,
null as RestThreeWay2,
'' as Total,
(select top 1  OddValue from @tempLiveOdd where OddsTypeId=27 and OutCome='nogoal' and MatchId=Live.Event.EventId   Order by  SpecialBetValue,OddsTypeId asc) as TotalUnder,
(select top 1  OddValue from @tempLiveOdd where OddsTypeId=27 and OutCome='goal' and MatchId=Live.Event.EventId   Order by  SpecialBetValue,OddsTypeId asc) as TotalOver
,null as NextGol1,
null as NextGolX,
null as NextGol2
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where  OddsTypeId=709 and OutCome='1' and MatchId=Live.Event.EventId and SpecialBetValue=(select top 1 SpecialBetValue from @tempLiveOdd where OddsTypeId=709 and MatchId=Live.Event.EventId and OddValue<2.70 ORDer By OddValue desc,SpecialBetValue) ) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where  OddsTypeId=709 and OutCome='1' and MatchId=Live.Event.EventId  and SpecialBetValue=(select top 1 SpecialBetValue from @tempLiveOdd where OddsTypeId=709 and MatchId=Live.Event.EventId and OddValue<2.70 ORDer By OddValue desc,SpecialBetValue))=1) THEN 'hidden' ELSE '' END as ThreeWay1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where OddsTypeId=709 and OutCome='x' and MatchId=Live.Event.EventId and SpecialBetValue=(select top 1 SpecialBetValue from @tempLiveOdd where OddsTypeId=709 and MatchId=Live.Event.EventId and OddValue<2.70 ORDer By OddValue desc,SpecialBetValue)) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where OddsTypeId=709 and OutCome='x' and MatchId=Live.Event.EventId and SpecialBetValue=(select top 1 SpecialBetValue from @tempLiveOdd where OddsTypeId=709 and MatchId=Live.Event.EventId and OddValue<2.70 ORDer By OddValue desc,SpecialBetValue))=1) THEN 'hidden' ELSE '' END as ThreeWay2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where  OddsTypeId=709 and OutCome='2' and MatchId=Live.Event.EventId and SpecialBetValue=(select top 1 SpecialBetValue from @tempLiveOdd where OddsTypeId=709 and MatchId=Live.Event.EventId and OddValue<2.70 ORDer By OddValue desc,SpecialBetValue)) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where  OddsTypeId=709 and OutCome='2' and MatchId=Live.Event.EventId and SpecialBetValue=(select top 1 SpecialBetValue from @tempLiveOdd where OddsTypeId=709 and MatchId=Live.Event.EventId and OddValue<2.70 ORDer By OddValue desc,SpecialBetValue))=1) THEN 'hidden' ELSE '' END as ThreeWay3Visibility
						 , 'hidden'  as RestThreeWay1Visibility
						 , 'hidden' as RestThreeWayXVisibility
						 ,'hidden'  as RestThreeWay2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where OddsTypeId=27 and OutCome='nogoal' and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where OddsTypeId=27 and OutCome='nogoal' and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where OddsTypeId=27 and OutCome='goal' and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where OddsTypeId=27 and OutCome='goal' and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalOverVisibility
						,  'hidden' as NextGoal1Visibility
						 , 'hidden'  as NextGoalXVisibility
						 ,  'hidden' as NextGoal2Visibility
						 ,(select top 1 IsChanged from @tempLiveOdd where OddsTypeId=709 and OutCome='1' and MatchId=Live.Event.EventId ORDer By OddId) as ThreeWay1Change,
(select top 1  IsChanged from @tempLiveOdd where OddsTypeId=709 and OutCome='x' and MatchId=Live.Event.EventId ORDer By OddId) as ThreeWayXChange,
(select top 1  IsChanged from @tempLiveOdd where OddsTypeId=709 and OutCome='2'  and MatchId=Live.Event.EventId ORDer By OddId) as ThreeWay2Change,
null as RestThreeWay1Change,
null as RestThreeWayXChange,
null as RestThreeWay2Change,
(select top 1  IsChanged from @tempLiveOdd where OddsTypeId=27 and OutCome='nogoal' and MatchId=Live.Event.EventId   ORDER BY SpecialBetValue asc) as TotalUnderChange,
(select top 1  IsChanged from @tempLiveOdd where OddsTypeId=27 and OutCome='goal' and MatchId=Live.Event.EventId  ORDER BY SpecialBetValue asc) as TotalOverChange
,null as NextGol1Change,
null as NextGolXChange,
null as NextGol2Change
,null as ThreeWay1Id,
null as ThreeWayXId,
null as ThreeWay2Id,
null as RestThreeWay1Id,
null as RestThreeWayXId,
null as RestThreeWay2Id,
null as TotalUnderId,
null as TotalOverId
,null as NextGol1Id,
null as NextGolXId,
null as NextGol2Id
						
FROM           
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId and Live.EventDetail.TimeStatu not in (2,1) INNER JOIN 
						 --Language.[Parameter.LiveTimeStatu] On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=@LangId INNER JOIN
						 Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId  LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Live.Event.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId INNER JOIN 
						   Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId  and Parameter.Sport.SportId=1
						 
Where 
((Live.[EventSetting].StateId=2 and --Match State Open
EventDetail.IsActive=1 and --Match Active
EventDetail.TimeStatu not in (0,1,2,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  ) OR  
 (EventDetail.TimeStatu=1   AND  Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2))


    

	--select * from @temptable


END


 

GO
