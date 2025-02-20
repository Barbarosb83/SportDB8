USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcEventOddScoreBox_OLD]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[GamePlatform.ProcEventOddScoreBox_OLD] 
@LangId int,
@OddTypeGroupId int
AS

BEGIN
SET NOCOUNT ON;


if(@OddTypeGroupId=12)
	set @OddTypeGroupId=15

declare @tLiveEventOdd table (OddId bigint NOT NULL,
	OddsTypeId int NOT NULL,
	OutCome nvarchar(100) NULL,
	SpecialBetValue nvarchar(100) NULL,
	OddValue float NULL,
	MatchId bigint NULL,
	BettradarOddId bigint NULL,
	Suggestion float NULL,
	ParameterOddId int NULL,
	IsOddValueLock bit NULL,
	IsChanged int NULL,
	IsActive bit NULL,
	OddResult bit NULL,
	VoidFactor float NULL,
	IsCanceled bit NULL,
	IsEvaluated bit NULL,
	OddFactor float NULL ,
	BetradarTimeStamp datetime NULL,
	UpdatedDate datetime NULL,
	BetradarMatchId bigint NULL,
	EvaluatedDate datetime NULL,BetradarOddsTypeId bigint,BetradarOddsSubTypeId bigint,StateId int )




 


	insert @tLiveEventOdd
	select Live.EventOdd.* from Live.EventOdd with (nolock)  INNER JOIN  Live.EventDetail with (nolock) on Live.EventDetail.EventId=Live.EventOdd.MatchId INNER JOIN
                      Live.[Parameter.OddType] with (nolock) on Live.EventOdd.OddsTypeId=Live.[Parameter.OddType].OddTypeId  
					 INNER JOIN Live.[Parameter.OddTypeGroupOddType] On Live.[Parameter.OddTypeGroupOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId and Live.[Parameter.OddTypeGroupOddType].OddTypeGroupId=@OddTypeGroupId
					  where  
	-- Live.EventOdd.OddValue is not null
	--and 
	(Live.EventOdd.IsActive = 1 or (Live.EventOdd.IsActive = 1 and Live.EventOdd.OddsTypeId=710 and Live.EventOdd.OddValue<=20)) and
	--AND (Live.EventOdd.OddResult IS NULL) AND (Live.EventOdd.IsCanceled IS NULL) AND (Live.EventOdd.IsEvaluated IS NULL) 
	 (Select Count(Live.EventOddResult.OddresultId) from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=live.EventOdd.OddId and IsCanceled=0)=0
	and  Live.[Parameter.OddType].IsActive=1     and  Live.EventDetail.IsActive=1  

SELECT    ROW_NUMBER() over(partition by Live.[Parameter.OddType].OddTypeId order by LiveEventOdd.SpecialBetValue,live.[Parameter.Odds].MatchTimeTypeId  ) as RowNumber,
	Live.[Parameter.OddType].OddTypeId,Language.[Parameter.LiveOddType].OddsType as OddType,
  LiveEventOdd.OddId
  --,  case when Language.[Parameter.LiveOdds].OutComes like '%player%' 
  --then  LiveEventOdd.OutCome 
  --else case when Language.[Parameter.LiveOdds].OutComes like '%none%'  
  --then LiveEventOdd.OutCome 
  --else case when Live.[Parameter.OddType].OddTypeId  in (21,22,25,29,30,62,121,122,119,123,124,125,126,127,128,129,132,133,134,135,136,137,141,142,149,150,151,152,153,155,156,157,158,160,161,203,212,239,241,270,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,454,464,512,513,521,526,527,545,549,550,566,569,570,571,611,608,740) then Language.[Parameter.LiveOdds].OutComes 
  --else case when LiveEventOdd.OutCome='1' or LiveEventOdd.OutCome='home'  then '[home!]' 
  --else case when LiveEventOdd.OutCome='2' or LiveEventOdd.OutCome='away'  then '[away!]'
  --else case when  Live.[Parameter.OddType].OddTypeId not in (103,102,90,91,98) then Language.[Parameter.LiveOdds].OutComes  else LiveEventOdd.OutCome end end end end  end end 
   ,LiveEventOdd.OutCome as OutCome
  ,LiveEventOdd.OddValue
  --,case when LiveEventOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
  --then CAST( cast(LiveEventOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
  --else case when LiveEventOdd.SpecialBetValue<>'-1' then  ISNULL(LiveEventOdd.SpecialBetValue,'') else '' end end 
 ,LiveEventOdd.SpecialBetValue as SpecialBetValue
  ,isnull(LiveEventOdd.IsChanged,0) as IsChanged
  ,ISNULL(Live.[Parameter.OddType].[SeqNumber],99) as SeqNumber,
  Live.EventDetail.BetStatus,case when Live.EventDetail.BetStatus<>2 or LiveEventOdd.IsActive=0 or LiveEventOdd.OddValue is null then 'hidden' else '' end Visibility
  ,LiveEventOdd.MatchId
  ,LiveEventOdd.BetradarMatchId
  ,Language.[Parameter.LiveOddType] .ShortOddType
  ,LiveEventOdd.ParameterOddId
FROM      @tLiveEventOdd as   LiveEventOdd INNER JOIN
                      Live.[Parameter.OddType] with (nolock) on LiveEventOdd.OddsTypeId=Live.[Parameter.OddType].OddTypeId inner join
                      Live.EventDetail with (nolock) on Live.EventDetail.EventId=LiveEventOdd.MatchId INNER JOIN
                      Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId inner join
                      live.[Parameter.Odds] with (nolock) ON live.[Parameter.Odds].OddsId=LiveEventOdd.ParameterOddId
                       INNER JOIN
                      Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=live.[Parameter.Odds].OddsId 
                      and Language.[Parameter.LiveOdds].LanguageId=Language.[Parameter.LiveOddType].LanguageId INNER JOIN
					    
			Live.EventSetting with (nolock) On Live.EventSetting.MatchId=Live.EventDetail.EventId and Live.EventSetting.StateId=2
WHERE    Live.EventDetail.IsActive=1  
and Language.[Parameter.LiveOddType].LanguageId=@LangId and  Live.[Parameter.OddType].IsActive=1  --and Live.[Parameter.OddType].OddTypeId=@LangId


 




END





GO
