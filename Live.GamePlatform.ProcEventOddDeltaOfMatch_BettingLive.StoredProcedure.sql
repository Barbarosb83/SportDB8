USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcEventOddDeltaOfMatch_BettingLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[GamePlatform.ProcEventOddDeltaOfMatch_BettingLive] 
@EventId bigint
AS

BEGIN
SET NOCOUNT ON;

SELECT    
  Live.EventOdd.OddId, 
  Live.EventOdd.OddValue,case when Live.EventOdd.ParameterOddId in (108,112,116,129,137,143,149,192,387,389,426,428,1947,2059,2503,2505,2553,2965,3257) 
  then CAST( cast(Live.EventOdd.SpecialBetValue AS float)*-1 AS nvarchar(10))
  else case when Live.EventOdd.SpecialBetValue<>'-1' then  ISNULL(Live.EventOdd.SpecialBetValue,'') else case when Live.EventOdd.OddsTypeId in (35) then case when cast(Live.EventOdd.SpecialBetValue AS float)<0 then  '0:'+CAST( cast(Live.EventOdd.SpecialBetValue  AS float)*-1 AS nvarchar(10)) else  ISNULL(Live.EventOdd.SpecialBetValue , '')+':0' end else ''   end end end as SpecialBetValue,
  isnull(Live.EventOdd.IsChanged,0) as IsChanged
,case when ((Live.EventOdd.IsActive = 1) 
and (Select Count([BettingLive].Live.EventOddResult.OddresultId) from [BettingLive].Live.EventOddResult with (nolock) where [BettingLive].Live.EventOddResult.OddId=live.EventOdd.OddId)=0 )
then cast(1 as bit) else cast(0 as bit) end as  IsActive
,Live.EventOdd.MatchId, case when Live.EventDetail.MatchTime is null then Live.[Parameter.TimeStatu].TimeStatu  else cast(Live.EventDetail.MatchTime as nvarchar(max)) end AS MatchTime ,Live.EventDetail.Score
,Live.EventDetail.BetStatus
FROM         Live.EventOdd with (nolock) INNER JOIN
                      Live.EventDetail with (nolock) on Live.EventDetail.EventId=Live.EventOdd.MatchId INNER JOIN
                      live.[Parameter.Odds] with (nolock) ON live.[Parameter.Odds].OddsId=Live.EventOdd.ParameterOddId
                      INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId
						  where Live.[Parameter.TimeStatu].TimeStatuId not in (5,24) and Live.EventOdd.MatchId=@EventId
						  and DATEDIFF(SECOND,  Live.EventOdd.UpdatedDate,GETDATE())<5



END


GO
