USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcFixtureHalfTime_OLD]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Live].[GamePlatform.ProcFixtureHalfTime_OLD]
	@LangId int,
	@SportId int
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
	[EvaluatedDate] datetime,BetradarOddsTypeId bigint,BetradarOddsSubTypeId bigint,StateId int  )



	insert @tempLiveOdd
	select Live.EventOdd.*  FROM           
                         Live.Event with (nolock) INNER JOIN
						 Live.EventOdd with (nolock) ON Live.EventOdd.MatchId=Live.Event.EventId and Live.EventOdd.OddsTypeId in (18,19,20,101) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
						 Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId 
						 
Where
((Live.[EventSetting].StateId=2 and --Match State Open
EventDetail.IsActive=1 --Match Active 
and (Select Count(Live.EventOddResult.OddresultId) from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=live.EventOdd.OddId)=0
and EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  )  OR (EventDetail.TimeStatu=1 and Live.[Event].ConnectionStatu=2
 and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2))   






	--declare @temptable table (EventId bigint,ThreeWay1 float,ThreeWayX float,ThreeWay2 float,RestThreeWay1 float,RestThreeWayX float,RestThreeWay2 float,Total nvarchar(10),TotalUnder float,TotalOver float,NextGol1 float,NextGolX float,NextGol2 float
	--,ThreeWay1Visibility nvarchar(15),ThreeWay2Visibility nvarchar(15),ThreeWay3Visibility nvarchar(15),RestThreeWay1Visibility nvarchar(15),RestThreeWayXVisibility nvarchar(15),RestThreeWay2Visibility nvarchar(15),TotalUnderVisibility nvarchar(15)
	--,TotalOverVisibility nvarchar(15),NextGoal1Visibility nvarchar(15),NextGoalXVisibility nvarchar(15),NextGoal2Visibility nvarchar(15)
	--,ThreeWay1Change int,ThreeWayXChange int,ThreeWay2Change int,RestThreeWay1Change int,RestThreeWayXChange int,RestThreeWay2Change int,TotalUnderChange int,TotalOverChange int,NextGol1Change int,NextGolXChange int,NextGol2Change int
	--,ThreeWay1Id bigint,ThreeWayXId bigint,ThreeWay2Id bigint,RestThreeWay1Id bigint,RestThreeWayXId bigint,RestThreeWay2Id bigint,TotalUnderId bigint,TotalOverId bigint,NextGol1Id bigint,NextGolXId bigint,NextGol2Id bigint)
  




if (@SportId=0)
begin
    
  
  --insert @temptable
select Live.Event.EventId
,(select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and IsActive=1) as ThreeWay1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId and IsActive=1) as ThreeWayX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId  and IsActive=1) as ThreeWay2,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId  and IsActive=1 Order by  SpecialBetValue asc) as RestThreeWay1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId  and IsActive=1 Order by  SpecialBetValue asc) as RestThreeWayX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId  and IsActive=1 Order by  SpecialBetValue asc) as RestThreeWay2,
(select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as Total,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as TotalUnder,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId  and IsActive=1  Order by  SpecialBetValue asc) as TotalOver
,(select top 1 OddValue from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue desc) as NextGol1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as NextGolX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as NextGol2
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as ThreeWay1Visibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as ThreeWay2Visibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as ThreeWay3Visibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as RestThreeWay1Visibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as RestThreeWayXVisibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as RestThreeWay2Visibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as TotalUnderVisibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as TotalOverVisibility
						,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as NextGoal1Visibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as NextGoalXVisibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as NextGoal2Visibility
						 ,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId) as ThreeWay1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId) as ThreeWayXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId) as ThreeWay2Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as RestThreeWay1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as RestThreeWayXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as RestThreeWay2Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and   IsActive=1  ORDER BY SpecialBetValue asc) as TotalUnderChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as TotalOverChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as NextGol1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as NextGolXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as NextGol2Change
,(select top 1 OddId from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId  and IsActive=1 ) as ThreeWay1Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId and IsActive=1) as ThreeWayXId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId  and IsActive=1) as ThreeWay2Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as RestThreeWay1Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as RestThreeWayXId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId and  IsActive=1   ORDER BY SpecialBetValue asc) as RestThreeWay2Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and  IsActive=1   ORDER BY SpecialBetValue asc) as TotalUnderId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as TotalOverId
,(select top 1 OddId from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as NextGol1Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as NextGolXId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as NextGol2Id
						
FROM           
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
                         Live.[Parameter.TimeStatu]  with (nolock) ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 --Language.[Parameter.LiveTimeStatu] On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=@LangId INNER JOIN
						 Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId  LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Live.Event.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId
						 
Where
Live.[EventDetail].TimeStatu not in (0,1,5,14,27,84,21,22,23,24,25,26,11,86,83) and ((Live.[EventSetting].StateId=2 and --Match State Open
Live.[EventDetail].IsActive=1  --Match Active
  ) OR (Live.[EventDetail].TimeStatu=5  )  and 
Live.[Event].ConnectionStatu=2 OR ( Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and Live.[EventDetail].IsActive=1 and Live.[EventDetail].BetStatus=2)) 


end
else
begin

 
  --insert @temptable
select Live.Event.EventId
,(select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and IsActive=1) as ThreeWay1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId and IsActive=1) as ThreeWayX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId  and IsActive=1) as ThreeWay2,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId  and IsActive=1 Order by  SpecialBetValue asc) as RestThreeWay1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId  and IsActive=1 Order by  SpecialBetValue asc) as RestThreeWayX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId  and IsActive=1 Order by  SpecialBetValue asc) as RestThreeWay2,
(select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as Total,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as TotalUnder,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId  and IsActive=1  Order by  SpecialBetValue asc) as TotalOver
,(select top 1 OddValue from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue desc) as NextGol1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as NextGolX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as NextGol2
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as ThreeWay1Visibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as ThreeWay2Visibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as ThreeWay3Visibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as RestThreeWay1Visibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as RestThreeWayXVisibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as RestThreeWay2Visibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as TotalUnderVisibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as TotalOverVisibility
						,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as NextGoal1Visibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as NextGoalXVisibility
						 ,CASE WHEN (select top 1 OddValue from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId and IsActive=1) is null or Live.[EventDetail].BetStatus<>2 or (select top 1 OddValue from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId and IsActive=1)=1 /*or (select top 1 ISNULL(IsEvaluated,0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 or (select top 1 ISNULL(COUNT(IsActive),0) from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId and ((IsEvaluated IS NULL) and (OddResult is null)) and IsActive=1 )=0)*/ THEN 'hidden' ELSE '' END as NextGoal2Visibility
						 ,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId) as ThreeWay1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId) as ThreeWayXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId) as ThreeWay2Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as RestThreeWay1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as RestThreeWayXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as RestThreeWay2Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and   IsActive=1  ORDER BY SpecialBetValue asc) as TotalUnderChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as TotalOverChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as NextGol1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as NextGolXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as NextGol2Change
,(select top 1 OddId from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId  and IsActive=1 ) as ThreeWay1Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId and IsActive=1) as ThreeWayXId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId  and IsActive=1) as ThreeWay2Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as RestThreeWay1Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as RestThreeWayXId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId and  IsActive=1   ORDER BY SpecialBetValue asc) as RestThreeWay2Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and  IsActive=1   ORDER BY SpecialBetValue asc) as TotalUnderId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as TotalOverId
,(select top 1 OddId from @tempLiveOdd where ParameterOddId=358 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as NextGol1Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=359 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as NextGolXId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=360 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as NextGol2Id
						
FROM           
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 Language.[Parameter.LiveTimeStatu] with (nolock) On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=@LangId INNER JOIN
						 Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId  LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Live.Event.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId INNER JOIN
						 Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Live.Event.TournamentId INNER JOIN
						 Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId
						 
Where Parameter.Category.SportId=@SportId and
Live.[EventDetail].TimeStatu not in (0,1,5,14,27,84,21,22,23,24,25,26,11,86,83) and ((Live.[EventSetting].StateId=2 and --Match State Open
Live.[EventDetail].IsActive=1  --Match Active
  ) OR (Live.[EventDetail].TimeStatu=5 and DATEDIFF(MINUTE,  Live.[EventDetail].UpdatedDate,GETDATE())<2)  and 
Live.[Event].ConnectionStatu=2 OR ( Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and Live.[EventDetail].IsActive=1 and Live.[EventDetail].BetStatus=2)) 

--and live.[Event].EventDate<=DATEADD(MINUTE,10,GETDATE())
--and Live.[EventDetail].BetStatus in (2)  --BetStatus 1,2 olanlar listeye gelir
--Tarih de gelecek
--order by Parameter.Sport.SportId,Live.[Parameter.TimeStatu].TimeStatu desc,Live.EventDetail.MatchTime desc

end
    

	--select * from @temptable


END




GO
