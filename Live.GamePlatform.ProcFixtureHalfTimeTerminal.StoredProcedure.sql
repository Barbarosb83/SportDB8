USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcFixtureHalfTimeTerminal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Live].[GamePlatform.ProcFixtureHalfTimeTerminal]
	@LangId int,
	@SportId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
declare @tempLiveOdd table (
	[OddId] bigint NOT NULL ,
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
	[EvaluatedDate] datetime ,BetradarOddsTypeId bigint,BetradarOddsSubTypeId bigint ,StateId int
	)
	 


	insert @tempLiveOdd
		select Live.EventOdd.*  FROM           
                         Live.Event with (nolock) INNER JOIN
						 Live.EventOdd with (nolock) ON Live.EventOdd.MatchId=Live.Event.EventId and Live.EventOdd.OddsTypeId in (11,18,19,20,40,44,47,50,64,478,479,480,481,9,78,79,80) 
						 and Live.EventOdd.IsActive=1   
						 INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
						 Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId 			 
Where
((Live.[EventSetting].StateId=2 and --Match State Open
EventDetail.IsActive=1 --Match Active
 and (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=live.EventOdd.OddId)=0
and EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  )  OR (EventDetail.TimeStatu=1 and Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2))   


	--declare @temptable table (EventId bigint,ThreeWay1 float,ThreeWayX float,ThreeWay2 float,RestThreeWay1 float,RestThreeWayX float,RestThreeWay2 float,Total nvarchar(10),TotalUnder float,TotalOver float,NextGol1 float,NextGolX float,NextGol2 float
	--,ThreeWay1Visibility nvarchar(15),ThreeWay2Visibility nvarchar(15),ThreeWay3Visibility nvarchar(15),RestThreeWay1Visibility nvarchar(15),RestThreeWayXVisibility nvarchar(15),RestThreeWay2Visibility nvarchar(15),TotalUnderVisibility nvarchar(15)
	--,TotalOverVisibility nvarchar(15),NextGoal1Visibility nvarchar(15),NextGoalXVisibility nvarchar(15),NextGoal2Visibility nvarchar(15)
	--,ThreeWay1Change int,ThreeWayXChange int,ThreeWay2Change int,RestThreeWay1Change int,RestThreeWayXChange int,RestThreeWay2Change int,TotalUnderChange int,TotalOverChange int,NextGol1Change int,NextGolXChange int,NextGol2Change int
	--,ThreeWay1Id bigint,ThreeWayXId bigint,ThreeWay2Id bigint,RestThreeWay1Id bigint,RestThreeWayXId bigint,RestThreeWay2Id bigint,TotalUnderId bigint,TotalOverId bigint,NextGol1Id bigint,NextGolXId bigint,NextGol2Id bigint)
  




if (@SportId=0)
begin
    
  
  --insert @temptable
select Live.Event.EventId
,(select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId  and IsActive=1) as ThreeWay1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId  and IsActive=1) as ThreeWayX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId  and IsActive=1) as ThreeWay2,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId   and IsActive=1 Order by  SpecialBetValue asc) as RestThreeWay1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId   and IsActive=1 Order by  SpecialBetValue asc) as RestThreeWayX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId   and IsActive=1 Order by  SpecialBetValue asc) as RestThreeWay2,
(select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as Total,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId   and IsActive=1   Order by  SpecialBetValue asc) as TotalUnder,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId  and IsActive=1  Order by  SpecialBetValue asc) as TotalOver
,(select top 1 OddValue from @tempLiveOdd where ParameterOddId=26 and MatchId=Live.Event.EventId   and IsActive=1   Order by  SpecialBetValue desc) as NextGol1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=27 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as NextGolX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=28 and MatchId=Live.Event.EventId   and IsActive=1    Order by  SpecialBetValue desc) as NextGol2
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2591 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as FirstPeriod1
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2592 and MatchId=Live.Event.EventId and IsActive=1    Order by  SpecialBetValue desc) as FirstPeriodX
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2593 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as FirstPeriod2
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2594 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as SecondPeriod1
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2595 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as SecondPeriodX
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2596 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as SecondPeriod2
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2597 and MatchId=Live.Event.EventId and IsActive=1    Order by  SpecialBetValue desc) as ThirdPeriod1
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2598 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as ThirdPeriodX
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2599 and MatchId=Live.Event.EventId and IsActive=1    Order by  SpecialBetValue desc) as ThirdPeriod2
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2600 and MatchId=Live.Event.EventId and IsActive=1    Order by  SpecialBetValue desc) as FourPeriod1
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2601 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as FourPeriodX
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2602 and MatchId=Live.Event.EventId and IsActive=1    Order by  SpecialBetValue desc) as FourPeriod2

, (select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=126 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as FirstPeriodTotal
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=126 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as FirstPeriodTotalUnder
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=127 and MatchId=Live.Event.EventId  and IsActive=1  Order by  SpecialBetValue asc) as FirstPeriodTotalOver

, (select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=134 and MatchId=Live.Event.EventId   and IsActive=1   Order by  SpecialBetValue asc) as SecondPeriodTotal
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=134 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as SecondPeriodTotalUnder
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=135 and MatchId=Live.Event.EventId  and IsActive=1  Order by  SpecialBetValue asc) as SecondPeriodTotalOver

, (select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=140 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as ThirdPeriodTotal
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=140 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as ThirdPeriodTotalUnder
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=141 and MatchId=Live.Event.EventId  and IsActive=1  Order by  SpecialBetValue asc) as ThirdPeriodTotalOver

, (select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=146 and MatchId=Live.Event.EventId and IsActive=1   Order by  SpecialBetValue asc) as FourPeriodTotal
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=146 and MatchId=Live.Event.EventId and IsActive=1   Order by  SpecialBetValue asc) as FourPeriodTotalUnder
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=147 and MatchId=Live.Event.EventId and IsActive=1  Order by  SpecialBetValue asc) as FourPeriodTotalOver

,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=21 and MatchId=Live.Event.EventId  and IsActive=1 Order by  SpecialBetValue asc) as TenniSetWin1
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=22 and MatchId=Live.Event.EventId and IsActive=1 Order by  SpecialBetValue asc) as TenniSetWin2

,(select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=212 and MatchId=Live.Event.EventId and IsActive=1   Order by  SpecialBetValue asc) as TotalSet1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=212 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as TotalSet1Under,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=213 and MatchId=Live.Event.EventId  and IsActive=1  Order by  SpecialBetValue asc) as TotalSet1Over

,(select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=214 and MatchId=Live.Event.EventId and IsActive=1   Order by  SpecialBetValue asc) as TotalSet2,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=214 and MatchId=Live.Event.EventId and IsActive=1   Order by  SpecialBetValue asc) as TotalSet2Under,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=215 and MatchId=Live.Event.EventId and IsActive=1  Order by  SpecialBetValue asc) as TotalSet2Over

,(select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=216 and MatchId=Live.Event.EventId and IsActive=1   Order by  SpecialBetValue asc) as TotalSet3,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=216 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as TotalSet3Under,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=217 and MatchId=Live.Event.EventId and IsActive=1  Order by  SpecialBetValue asc) as TotalSet3Over

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as ThreeWay1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as ThreeWay2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as ThreeWay3Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as RestThreeWay1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as RestThreeWayXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as RestThreeWay2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1 ) THEN 'hidden' ELSE '' END as TotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1 ) THEN 'hidden' ELSE '' END as TotalOverVisibility
						,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=26 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=26 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as NextGoal1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=27 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=27 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as NextGoalXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=28 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=28 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as NextGoal2Visibility
						 
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2591 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2591 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as FirstPeriod1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2592 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2592 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as FirstPeriodXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2593 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2593 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as FirstPeriod2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2594 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2594 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as SecondPeriod1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2595 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2595 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as SecondPeriodXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2596 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2596 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as SecondPeriod2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2597 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2597 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as ThirdPeriod1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2598 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2598 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as ThirdPeriodXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2599 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2599 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as ThirdPeriod2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2600 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2600 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as FourPeriod1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2601 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2601 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as FourPeriodXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2602 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2602 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as FourPeriod2Visibility


						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=126 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=126 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as FirstPeriodTotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=127 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=127 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as FirstPeriodTotalOverVisibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=134 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=134 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as SecondPeriodTotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=135 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=135 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as SecondPeriodTotalOverVisibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=140 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=140 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as ThirdPeriodTotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=141 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=141 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as ThirdPeriodTotalOverVisibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=146 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=146 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as FourPeriodTotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=147 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=147 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as FourPeriodTotalOverVisibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=21 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=21 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as TenniSetWin1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=22 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=22 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as TenniSetWin2Visibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=212 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=212 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalSet1UnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=213 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=213 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalSet1OverVisibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=214 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=214 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalSet2UnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=215 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=215 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalSet2OverVisibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=216 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=216 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalSet3UnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=217 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=217 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalSet3OverVisibility

						 ,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId) as ThreeWay1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId) as ThreeWayXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId) as ThreeWay2Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as RestThreeWay1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as RestThreeWayXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as RestThreeWay2Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as TotalUnderChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as TotalOverChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=26 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as NextGol1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=27 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as NextGolXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=28 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as NextGol2Change

,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2591 and MatchId=Live.Event.EventId) as FirstPeriod1Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2592 and MatchId=Live.Event.EventId) as FirstPeriodXChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2593 and MatchId=Live.Event.EventId) as FirstPeriod2Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2594 and MatchId=Live.Event.EventId) as SecondPeriod1Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2595 and MatchId=Live.Event.EventId) as SecondPeriodXChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2596 and MatchId=Live.Event.EventId) as SecondPeriod2Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2597 and MatchId=Live.Event.EventId) as ThirdPeriod1Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2598 and MatchId=Live.Event.EventId) as ThirdPeriodXChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2599 and MatchId=Live.Event.EventId) as ThirdPeriod2Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2600 and MatchId=Live.Event.EventId) as FourPeriod1Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2601 and MatchId=Live.Event.EventId) as FourPeriodXChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2602 and MatchId=Live.Event.EventId) as FourPeriod2Change

,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=126 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as FirstPeriodTotalUnderChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=127 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as FirstPeriodTotalOverChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=134 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as SecondPeriodTotalUnderChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=135 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as SecondPeriodTotalOverChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=140 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as ThirdPeriodTotalUnderChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=141 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as ThirdPeriodTotalOverChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=146 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as FourPeriodTotalUnderChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=147 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as FourPeriodTotalOverChange

,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=21 and MatchId=Live.Event.EventId) as TenniSetWin1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=22 and MatchId=Live.Event.EventId) as TenniSetWin2Change

,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=212 and MatchId=Live.Event.EventId and   IsActive=1  ORDER BY SpecialBetValue asc) as TotalSet1UnderChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=213 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as TotalSet1OverChange

,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=214 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as TotalSet2UnderChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=215 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as TotalSet2OverChange

,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=216 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as TotalSet3UnderChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=217 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as TotalSet3OverChange

,(select top 1 OddId from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId ) as ThreeWay1Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId ) as ThreeWayXId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId ) as ThreeWay2Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as RestThreeWay1Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as RestThreeWayXId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as RestThreeWay2Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalUnderId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalOverId
,(select top 1 OddId from @tempLiveOdd where ParameterOddId=26 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as NextGol1Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=27 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as NextGolXId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=28 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as NextGol2Id
						
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2591 and MatchId=Live.Event.EventId ) as FirstPeriod1Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2592 and MatchId=Live.Event.EventId ) as FirstPeriodXId
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2593 and MatchId=Live.Event.EventId ) as FirstPeriod2Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2594 and MatchId=Live.Event.EventId ) as SecondPeriod1Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2595 and MatchId=Live.Event.EventId ) as SecondPeriodXId
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2596 and MatchId=Live.Event.EventId ) as SecondPeriod2Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2597 and MatchId=Live.Event.EventId ) as ThirdPeriod1Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2598 and MatchId=Live.Event.EventId ) as ThirdPeriodXId
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2599 and MatchId=Live.Event.EventId ) as ThirdPeriod2Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2600 and MatchId=Live.Event.EventId ) as FourPeriod1Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2601 and MatchId=Live.Event.EventId ) as FourPeriodXId
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2602 and MatchId=Live.Event.EventId ) as FourPeriod2Id

						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=126 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as FirstPeriodTotalUnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=127 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as FirstPeriodTotalOverId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=134 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as SecondPeriodTotalUnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=135 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as SecondPeriodTotalOverId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=140 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as ThirdPeriodTotalUnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=141 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as ThirdPeriodTotalOverId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=146 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as FourPeriodTotalUnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=147 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as FourPeriodTotalOverId
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=21 and MatchId=Live.Event.EventId ) as TenniSetWin1Id,
						 (select top 1  OddId from @tempLiveOdd where ParameterOddId=22 and MatchId=Live.Event.EventId ) as TenniSetWin2Id

						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=212 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalSet1UnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=213 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalSet1OverId

						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=214 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalSet2UnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=215 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalSet2OverId

						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=216 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalSet3UnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=217 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalSet3OverId

						 ,RTRIM(EventDetail.LegScore) as  GameScore 
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

 
select Live.Event.EventId
,(select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId  and IsActive=1) as ThreeWay1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId  and IsActive=1) as ThreeWayX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId  and IsActive=1) as ThreeWay2,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId   and IsActive=1 Order by  SpecialBetValue asc) as RestThreeWay1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId   and IsActive=1 Order by  SpecialBetValue asc) as RestThreeWayX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId   and IsActive=1 Order by  SpecialBetValue asc) as RestThreeWay2,
(select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as Total,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId   and IsActive=1   Order by  SpecialBetValue asc) as TotalUnder,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId  and IsActive=1  Order by  SpecialBetValue asc) as TotalOver
,(select top 1 OddValue from @tempLiveOdd where ParameterOddId=26 and MatchId=Live.Event.EventId   and IsActive=1   Order by  SpecialBetValue desc) as NextGol1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=27 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as NextGolX,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=28 and MatchId=Live.Event.EventId   and IsActive=1    Order by  SpecialBetValue desc) as NextGol2
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2591 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as FirstPeriod1
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2592 and MatchId=Live.Event.EventId and IsActive=1    Order by  SpecialBetValue desc) as FirstPeriodX
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2593 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as FirstPeriod2
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2594 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as SecondPeriod1
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2595 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as SecondPeriodX
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2596 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as SecondPeriod2
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2597 and MatchId=Live.Event.EventId and IsActive=1    Order by  SpecialBetValue desc) as ThirdPeriod1
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2598 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as ThirdPeriodX
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2599 and MatchId=Live.Event.EventId and IsActive=1    Order by  SpecialBetValue desc) as ThirdPeriod2
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2600 and MatchId=Live.Event.EventId and IsActive=1    Order by  SpecialBetValue desc) as FourPeriod1
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2601 and MatchId=Live.Event.EventId  and IsActive=1    Order by  SpecialBetValue desc) as FourPeriodX
 ,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=2602 and MatchId=Live.Event.EventId and IsActive=1    Order by  SpecialBetValue desc) as FourPeriod2

, (select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=126 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as FirstPeriodTotal
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=126 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as FirstPeriodTotalUnder
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=127 and MatchId=Live.Event.EventId  and IsActive=1  Order by  SpecialBetValue asc) as FirstPeriodTotalOver

, (select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=134 and MatchId=Live.Event.EventId   and IsActive=1   Order by  SpecialBetValue asc) as SecondPeriodTotal
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=134 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as SecondPeriodTotalUnder
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=135 and MatchId=Live.Event.EventId  and IsActive=1  Order by  SpecialBetValue asc) as SecondPeriodTotalOver

, (select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=140 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as ThirdPeriodTotal
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=140 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as ThirdPeriodTotalUnder
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=141 and MatchId=Live.Event.EventId  and IsActive=1  Order by  SpecialBetValue asc) as ThirdPeriodTotalOver

, (select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=146 and MatchId=Live.Event.EventId and IsActive=1   Order by  SpecialBetValue asc) as FourPeriodTotal
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=146 and MatchId=Live.Event.EventId and IsActive=1   Order by  SpecialBetValue asc) as FourPeriodTotalUnder
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=147 and MatchId=Live.Event.EventId and IsActive=1  Order by  SpecialBetValue asc) as FourPeriodTotalOver

,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=21 and MatchId=Live.Event.EventId  and IsActive=1 Order by  SpecialBetValue asc) as TenniSetWin1
,(select top 1  OddValue from @tempLiveOdd where ParameterOddId=22 and MatchId=Live.Event.EventId and IsActive=1 Order by  SpecialBetValue asc) as TenniSetWin2

,(select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=212 and MatchId=Live.Event.EventId and IsActive=1   Order by  SpecialBetValue asc) as TotalSet1,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=212 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as TotalSet1Under,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=213 and MatchId=Live.Event.EventId  and IsActive=1  Order by  SpecialBetValue asc) as TotalSet1Over

,(select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=214 and MatchId=Live.Event.EventId and IsActive=1   Order by  SpecialBetValue asc) as TotalSet2,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=214 and MatchId=Live.Event.EventId and IsActive=1   Order by  SpecialBetValue asc) as TotalSet2Under,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=215 and MatchId=Live.Event.EventId and IsActive=1  Order by  SpecialBetValue asc) as TotalSet2Over

,(select top 1  SpecialBetValue from @tempLiveOdd where ParameterOddId=216 and MatchId=Live.Event.EventId and IsActive=1   Order by  SpecialBetValue asc) as TotalSet3,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=216 and MatchId=Live.Event.EventId  and IsActive=1   Order by  SpecialBetValue asc) as TotalSet3Under,
(select top 1  OddValue from @tempLiveOdd where ParameterOddId=217 and MatchId=Live.Event.EventId and IsActive=1  Order by  SpecialBetValue asc) as TotalSet3Over

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as ThreeWay1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as ThreeWay2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as ThreeWay3Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as RestThreeWay1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as RestThreeWayXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId)=1 ) THEN 'hidden' ELSE '' END as RestThreeWay2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1 ) THEN 'hidden' ELSE '' END as TotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1 ) THEN 'hidden' ELSE '' END as TotalOverVisibility
						,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=26 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=26 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as NextGoal1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=27 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=27 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as NextGoalXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=28 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=28 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as NextGoal2Visibility
						 
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2591 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2591 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as FirstPeriod1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2592 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2592 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as FirstPeriodXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2593 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2593 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as FirstPeriod2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2594 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2594 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as SecondPeriod1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2595 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2595 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as SecondPeriodXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2596 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2596 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as SecondPeriod2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2597 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2597 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as ThirdPeriod1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2598 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2598 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as ThirdPeriodXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2599 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2599 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as ThirdPeriod2Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2600 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2600 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as FourPeriod1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2601 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2601 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as FourPeriodXVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2602 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=2602 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as FourPeriod2Visibility


						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=126 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=126 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as FirstPeriodTotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=127 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=127 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as FirstPeriodTotalOverVisibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=134 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=134 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as SecondPeriodTotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=135 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=135 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as SecondPeriodTotalOverVisibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=140 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=140 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as ThirdPeriodTotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=141 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=141 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as ThirdPeriodTotalOverVisibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=146 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=146 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as FourPeriodTotalUnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=147 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=147 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as FourPeriodTotalOverVisibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=21 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=21 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as TenniSetWin1Visibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=22 and MatchId=Live.Event.EventId) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=22 and MatchId=Live.Event.EventId)=1) THEN 'hidden' ELSE '' END as TenniSetWin2Visibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=212 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=212 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalSet1UnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=213 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=213 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalSet1OverVisibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=214 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=214 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalSet2UnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=215 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=215 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalSet2OverVisibility

						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=216 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=216 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalSet3UnderVisibility
						 ,CASE WHEN ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=217 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc) is null or Live.[EventDetail].BetStatus<>2) or ((select top 1 OddValue from @tempLiveOdd where ParameterOddId=217 and MatchId=Live.Event.EventId and IsActive=1 ORDER BY SpecialBetValue asc)=1) THEN 'hidden' ELSE '' END as TotalSet3OverVisibility

						 ,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId) as ThreeWay1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId) as ThreeWayXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId) as ThreeWay2Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as RestThreeWay1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as RestThreeWayXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as RestThreeWay2Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as TotalUnderChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as TotalOverChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=26 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as NextGol1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=27 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as NextGolXChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=28 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as NextGol2Change

,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2591 and MatchId=Live.Event.EventId) as FirstPeriod1Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2592 and MatchId=Live.Event.EventId) as FirstPeriodXChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2593 and MatchId=Live.Event.EventId) as FirstPeriod2Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2594 and MatchId=Live.Event.EventId) as SecondPeriod1Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2595 and MatchId=Live.Event.EventId) as SecondPeriodXChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2596 and MatchId=Live.Event.EventId) as SecondPeriod2Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2597 and MatchId=Live.Event.EventId) as ThirdPeriod1Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2598 and MatchId=Live.Event.EventId) as ThirdPeriodXChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2599 and MatchId=Live.Event.EventId) as ThirdPeriod2Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2600 and MatchId=Live.Event.EventId) as FourPeriod1Change
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2601 and MatchId=Live.Event.EventId) as FourPeriodXChange
,(select top 1 IsChanged from @tempLiveOdd where ParameterOddId=2602 and MatchId=Live.Event.EventId) as FourPeriod2Change

,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=126 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as FirstPeriodTotalUnderChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=127 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as FirstPeriodTotalOverChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=134 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as SecondPeriodTotalUnderChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=135 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as SecondPeriodTotalOverChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=140 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as ThirdPeriodTotalUnderChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=141 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as ThirdPeriodTotalOverChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=146 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as FourPeriodTotalUnderChange
,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=147 and MatchId=Live.Event.EventId and  IsActive=1 ORDER BY SpecialBetValue asc) as FourPeriodTotalOverChange

,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=21 and MatchId=Live.Event.EventId) as TenniSetWin1Change,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=22 and MatchId=Live.Event.EventId) as TenniSetWin2Change

,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=212 and MatchId=Live.Event.EventId and   IsActive=1  ORDER BY SpecialBetValue asc) as TotalSet1UnderChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=213 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as TotalSet1OverChange

,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=214 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as TotalSet2UnderChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=215 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as TotalSet2OverChange

,(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=216 and MatchId=Live.Event.EventId and   IsActive=1 ORDER BY SpecialBetValue asc) as TotalSet3UnderChange,
(select top 1  IsChanged from @tempLiveOdd where ParameterOddId=217 and MatchId=Live.Event.EventId and  IsActive=1  ORDER BY SpecialBetValue asc) as TotalSet3OverChange

,(select top 1 OddId from @tempLiveOdd where ParameterOddId=55 and MatchId=Live.Event.EventId ) as ThreeWay1Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=56 and MatchId=Live.Event.EventId ) as ThreeWayXId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=57 and MatchId=Live.Event.EventId ) as ThreeWay2Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=50 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as RestThreeWay1Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=51 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as RestThreeWayXId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=52 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as RestThreeWay2Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=53 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalUnderId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=54 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalOverId
,(select top 1 OddId from @tempLiveOdd where ParameterOddId=26 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as NextGol1Id,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=27 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as NextGolXId,
(select top 1  OddId from @tempLiveOdd where ParameterOddId=28 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as NextGol2Id
						
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2591 and MatchId=Live.Event.EventId ) as FirstPeriod1Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2592 and MatchId=Live.Event.EventId ) as FirstPeriodXId
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2593 and MatchId=Live.Event.EventId ) as FirstPeriod2Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2594 and MatchId=Live.Event.EventId ) as SecondPeriod1Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2595 and MatchId=Live.Event.EventId ) as SecondPeriodXId
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2596 and MatchId=Live.Event.EventId ) as SecondPeriod2Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2597 and MatchId=Live.Event.EventId ) as ThirdPeriod1Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2598 and MatchId=Live.Event.EventId ) as ThirdPeriodXId
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2599 and MatchId=Live.Event.EventId ) as ThirdPeriod2Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2600 and MatchId=Live.Event.EventId ) as FourPeriod1Id
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2601 and MatchId=Live.Event.EventId ) as FourPeriodXId
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=2602 and MatchId=Live.Event.EventId ) as FourPeriod2Id

						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=126 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as FirstPeriodTotalUnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=127 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as FirstPeriodTotalOverId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=134 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as SecondPeriodTotalUnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=135 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as SecondPeriodTotalOverId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=140 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as ThirdPeriodTotalUnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=141 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as ThirdPeriodTotalOverId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=146 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as FourPeriodTotalUnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=147 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as FourPeriodTotalOverId
						,(select top 1 OddId from @tempLiveOdd where ParameterOddId=21 and MatchId=Live.Event.EventId ) as TenniSetWin1Id,
						 (select top 1  OddId from @tempLiveOdd where ParameterOddId=22 and MatchId=Live.Event.EventId ) as TenniSetWin2Id

						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=212 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalSet1UnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=213 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalSet1OverId

						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=214 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalSet2UnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=215 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalSet2OverId

						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=216 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalSet3UnderId
						,(select top 1  OddId from @tempLiveOdd where ParameterOddId=217 and MatchId=Live.Event.EventId ORDER BY SpecialBetValue asc) as TotalSet3OverId

						 ,RTRIM(EventDetail.LegScore) as  GameScore 
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
