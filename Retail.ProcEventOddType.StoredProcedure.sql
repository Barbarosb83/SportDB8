USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcEventOddType]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Retail].[ProcEventOddType] 
@MatchId bigint,
@BetType int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;



if ( @BetType=0)
SELECT                       Language.[Parameter.OddsType].OddsType, Match.OddTypeSetting.OddTypeId,'' as SpecialBetValue
FROM         Parameter.OddsType with (nolock) INNER JOIN
                      Language.[Parameter.OddsType] with (nolock) ON Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId AND 
                      Parameter.OddsType.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
                      Match.OddTypeSetting with (nolock) ON Language.[Parameter.OddsType].OddsTypeId = Match.OddTypeSetting.OddTypeId INNER JOIN
                      Match.Match with (nolock) ON Match.OddTypeSetting.MatchId = Match.Match.MatchId
WHERE   (Match.OddTypeSetting.StateId = 2) AND (Match.OddTypeSetting.MatchId = @MatchId) AND Parameter.OddsType.OddsTypeId not in (1836) and
                      (Language.[Parameter.OddsType].LanguageId = @LangId) and Parameter.OddsType.IsActive=1
					    Order By Parameter.OddsType.SeqNumber
else if  (@BetType=1)
  Select distinct Language.[Parameter.LiveOddType].OddsType,Live.EventOdd.OddsTypeId as OddTypeId,
  '' as SpecialBetValue
  from Live.EventOdd with (nolock) INNER JOIN Live.[Parameter.OddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId=Live.EventOdd.OddsTypeId
  INNER JOIN Language.[Parameter.LiveOddType] with (nolock) ON Language.[Parameter.LiveOddType].OddTypeId=Live.[Parameter.OddType].OddTypeId
  where Live.EventOdd.MatchId=@MatchId and Language.[Parameter.LiveOddType].LanguageId=@LangId and Live.[Parameter.OddType].IsActive=1 and Live.EventOdd.OddValue is not null
and (Live.EventOdd.IsActive = 1)
--and (select count([BettingLive].Live.EventOddResult.OddId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=Live.EventOdd.OddId)=0
else 
SELECT   DISTINCT     Outrights.EventName.EventName as OddsType,cast(Outrights.Odd.OddsTypeId as int) as OddTypeId,'' as SpecialBetValue
FROM         Outrights.Odd   INNER JOIN
                    -- Outrights.[Competitor] On Outrights.Competitor.CompetitorId=Outrights.Odd.CompetitorId INNER JOIN
                      Outrights.[Event] ON Outrights.Odd.MatchId = Outrights.[Event].EventId  INNER JOIN
					  Outrights.EventName On Outrights.EventName.EventId=Outrights.Event.EventId and Outrights.EventName.LanguageId=@LangId
WHERE     (Outrights.Odd.MatchId = @MatchId)  
   


END



GO
