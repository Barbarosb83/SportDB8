USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcEventOddOfSingleMatch_OLD]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [Live].[GamePlatform.ProcEventOddOfSingleMatch_OLD] 
@EventId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;




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
	select * from Live.EventOdd with (nolock) where Live.EventOdd.MatchId=@EventId



SELECT    ROW_NUMBER() over(partition by cast( Live.[Parameter.OddType].OddTypeId as nvarchar(max))+LiveEventOdd.SpecialBetValue order by LiveEventOdd.SpecialBetValue,LiveEventOdd.OutCome) as RowNumber,
	Live.[Parameter.OddType].OddTypeId,Language.[Parameter.LiveOddType].OddsType as OddType,
  LiveEventOdd.OddId
  ,    case when Language.[Parameter.LiveOdds].OutComes like '%player%' 
  then  LiveEventOdd.OutCome 
  else case when Language.[Parameter.LiveOdds].OutComes like '%none%'  
  then LiveEventOdd.OutCome 
  else case when Language.[Parameter.LiveOdds].OutComes  like '%هيچکدام%' then LiveEventOdd.OutCome 
  else 
  case when Live.[Parameter.OddType].OddTypeId  in (21,22,25,29,30,62,121,122,119,123,124,125,126,127,128,129,132,133,134,135,136,137,141,142,149,150,151,152,153,155,156,157,158,160,161,203,212,239,241,270,294,295,296,297,298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,340,341,342,343,344,345,346,347,348,349,350,351,352,353,354,355,356,357,358,359,360,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,422,423,424,454,464,512,513,521,526,527,545,549,550,566,569,570,571,611,608,740) then Language.[Parameter.LiveOdds].OutComes 
  else case when LiveEventOdd.OutCome='1' or LiveEventOdd.OutCome='home'  then '[home!]' 
  else case when LiveEventOdd.OutCome='2' or LiveEventOdd.OutCome='away'  then '[away!]'
  else case when  Live.[Parameter.OddType].OddTypeId not in (103,102,90,91,98) then Language.[Parameter.LiveOdds].OutComes  else  LiveEventOdd.OutCome end end end end end  end end as OutCome
  --,LiveEventOdd.OutCome as OutCome
  ,LiveEventOdd.OddValue,case when LiveEventOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
  then CAST( cast(LiveEventOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
  else case when LiveEventOdd.SpecialBetValue<>'-1' then  ISNULL(LiveEventOdd.SpecialBetValue,'') else  case when LiveEventOdd.OddsTypeId in (35) then case when cast(LiveEventOdd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(LiveEventOdd.SpecialBetValue  AS float)*-1 AS nvarchar(10)) else  ISNULL(LiveEventOdd.SpecialBetValue , '')+':0' end else ''   end  end end as SpecialBetValue
  , case when LiveEventOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
  then CAST( cast(LiveEventOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
  else case when LiveEventOdd.SpecialBetValue='-1' then  '' else case when Live.[Parameter.OddType].OddTypeId =463 then case when   LiveEventOdd.ParameterOddId=2554 then  CAST( cast( PARSENAME(REPLACE(LiveEventOdd.SpecialBetValue,'/','.'),2)+'.'+PARSENAME(REPLACE(LiveEventOdd.SpecialBetValue,'/','.'),1) AS float)*-1 AS nvarchar(10)) else   PARSENAME(REPLACE(LiveEventOdd.SpecialBetValue,'/','.'),2)+'.'+PARSENAME(REPLACE(LiveEventOdd.SpecialBetValue,'/','.'),1) end else case when Live.[Parameter.OddType].OddTypeId in (10,519,521,522,523,524,525,526,527,530,538,539,500,504,503,520,653,506,560,274,457,528,529,531,466,507,561,505,559,469,558,465,654,655,453,454,455,464,456,615,613,614,467,468,452,451,501,275,276,450,502,83,84,91,103) then '' else   case when LiveEventOdd.OddsTypeId in (35) then case when cast(LiveEventOdd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(LiveEventOdd.SpecialBetValue  AS float)*-1 AS nvarchar(10)) else  ISNULL(LiveEventOdd.SpecialBetValue , '')+':0' end else ''   end  end end end end as SpecialBetValue2
  ,isnull(LiveEventOdd.IsChanged,0) as IsChanged,
  TypeTable.OddTypeCount,					  
  row_number() over (partition by cast( Live.[Parameter.OddType].OddTypeId as nvarchar(max))+LiveEventOdd.SpecialBetValue order by cast( Live.[Parameter.OddType].OddTypeId as nvarchar(max))+LiveEventOdd.SpecialBetValue) as RowNumber,
  cast( Live.[Parameter.OddType].OddTypeId as nvarchar(max))+LiveEventOdd.SpecialBetValue as OddGroupId,
  Live.EventDetail.BetStatus,Live.[Parameter.OddType].OddType as OddTypeDescription
FROM     @tLiveEventOdd as  LiveEventOdd INNER JOIN
                      Live.[Parameter.OddType] with (nolock) on LiveEventOdd.OddsTypeId=Live.[Parameter.OddType].OddTypeId inner join
                      Live.EventDetail with (nolock) on Live.EventDetail.EventId=LiveEventOdd.MatchId inner join 
                      (Select cast( Live.[Parameter.OddType].OddTypeId as nvarchar(max))+LiveEventOdd.SpecialBetValue as ExOddTypeId
					  , count(cast( Live.[Parameter.OddType].OddTypeId as nvarchar(max))+LiveEventOdd.SpecialBetValue) as OddTypeCount
								FROM      @tLiveEventOdd as   LiveEventOdd INNER JOIN
											 Live.[Parameter.OddType] with (nolock) ON LiveEventOdd.OddsTypeId = Live.[Parameter.OddType].OddTypeId 
											 Where LiveEventOdd.MatchId=@EventId  and LiveEventOdd.IsActive = 1
											 group by cast( Live.[Parameter.OddType].OddTypeId as nvarchar(max))+LiveEventOdd.SpecialBetValue) 
						as TypeTable on cast( Live.[Parameter.OddType].OddTypeId as nvarchar(max))+LiveEventOdd.SpecialBetValue = TypeTable.ExOddTypeId INNER JOIN
			Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId INNER JOIN
			Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=LiveEventOdd.ParameterOddId and Language.[Parameter.LiveOddType].LanguageId=Language.[Parameter.LiveOdds].LanguageId  INNER JOIN
			Live.[Event] with (nolock) ON Live.[Event].EventId=Live.EventDetail.EventId INNER JOIN
			Live.EventSetting with (nolock) On Live.EventSetting.MatchId=Live.EventDetail.EventId and Live.EventSetting.StateId=2
WHERE      LiveEventOdd.MatchId=@EventId and LiveEventOdd.OddValue is not null and 
Live.[EventDetail].TimeStatu not in (0,1,5,14,27,84,21,22,23,24,25,26,11,86) 
and (LiveEventOdd.IsActive = 1) and Live.[Event].ConnectionStatu=2 
--AND (LiveEventOdd.OddResult IS NULL) AND (LiveEventOdd.IsCanceled IS NULL) AND (LiveEventOdd.IsEvaluated IS NULL) 
and (Select Count(Live.EventOddResult.OddresultId) from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=LiveEventOdd.OddId and IsCanceled=0)=0
and  Language.[Parameter.LiveOddType].LanguageId=@LangId and  Live.[Parameter.OddType].IsActive=1  --and LiveEventOdd.SpecialBetValue<>-1
order by [Parameter.OddType].OddTypeId, LiveEventOdd.OddId




END




GO
