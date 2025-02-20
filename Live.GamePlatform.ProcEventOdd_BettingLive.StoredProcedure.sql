USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcEventOdd_BettingLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Live].[GamePlatform.ProcEventOdd_BettingLive] 
@EventId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;


SELECT    ROW_NUMBER() over(partition by Live.[Parameter.OddType].OddTypeId order by Live.EventOdd.SpecialBetValue,Live.EventOdd.OddId) as RowNumber,
	Live.[Parameter.OddType].OddTypeId,Language.[Parameter.LiveOddType].OddsType as OddType,
  Live.EventOdd.OddId
  ,Language.[Parameter.LiveOdds].OutComes as OutCome
  ,Live.EventOdd.OddValue
  , case when Live.EventOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
  then CAST( cast(Live.EventOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
  else case when Live.EventOdd.SpecialBetValue<>'-1' then  ISNULL(Live.EventOdd.SpecialBetValue,'') 
  else case when Live.EventOdd.OddsTypeId in (35) then case when cast(Live.EventOdd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(Live.EventOdd.SpecialBetValue  AS float)*-1 AS nvarchar(10)) else  ISNULL(Live.EventOdd.SpecialBetValue , '')+':0' end else ''   end end end as SpecialBetValue
  ,isnull(Live.EventOdd.IsChanged,0) as IsChanged
FROM         Live.EventOdd with (nolock) INNER JOIN
                      Live.[Parameter.OddType] with (nolock) on Live.EventOdd.OddsTypeId=Live.[Parameter.OddType].OddTypeId inner join
                      Live.EventDetail with (nolock) on Live.EventDetail.EventId=Live.EventOdd.MatchId INNER JOIN
                      Language.[Parameter.LiveOddType]  with (nolock)ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId inner join
                      live.[Parameter.Odds] with (nolock) ON live.[Parameter.Odds].OddsId=Live.EventOdd.ParameterOddId
                       INNER JOIN
                      Language.[Parameter.LiveOdds] with (nolock) ON Language.[Parameter.LiveOdds].OddsId=live.[Parameter.Odds].OddsId 
                      and Language.[Parameter.LiveOdds].LanguageId=Language.[Parameter.LiveOddType].LanguageId INNER JOIN
			Live.EventSetting with (nolock) On Live.EventSetting.MatchId=Live.EventDetail.EventId and Live.EventSetting.StateId=2
WHERE   Live.EventDetail.IsActive=1 and   Live.EventOdd.MatchId=@EventId and Live.EventOdd.OddValue is not null
and (Live.EventOdd.IsActive = 1) 
and (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=live.EventOdd.OddId and IsCanceled=0)=0
and Live.EventDetail.BetStatus=2 and Language.[Parameter.LiveOddType].LanguageId=@LangId and  Live.[Parameter.OddType].IsActive=1  --and Live.[Parameter.OddType].OddTypeId=@LangId
order by [Parameter.OddType].OddTypeId, Live.EventOdd.OddId





END


GO
