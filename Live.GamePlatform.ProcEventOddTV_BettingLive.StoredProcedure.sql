USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcEventOddTV_BettingLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[GamePlatform.ProcEventOddTV_BettingLive] 
@LangId int,
@OddTypeGroupId int
AS

BEGIN
SET NOCOUNT ON;

 
	set @OddTypeGroupId=16

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
					  where  (Live.EventOdd.IsActive = 1 or (Live.EventOdd.IsActive = 1 and Live.EventOdd.OddsTypeId=710 and Live.EventOdd.OddValue<=20)) and
	 (Select Count(Live.EventOddResult.OddresultId) from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=live.EventOdd.OddId and IsCanceled=0)=0
	and  Live.[Parameter.OddType].IsActive=1     and  Live.EventDetail.IsActive=1  

SELECT    ROW_NUMBER() over(partition by Live.[Parameter.OddType].OddTypeId order by LiveEventOdd.SpecialBetValue,live.[Parameter.Odds].MatchTimeTypeId  ) as RowNumber,
	Live.[Parameter.OddType].OddTypeId,Language.[Parameter.LiveOddType].OddsType as OddType,
  LiveEventOdd.OddId
   ,LiveEventOdd.OutCome as OutCome
  ,LiveEventOdd.OddValue
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
and Language.[Parameter.LiveOddType].LanguageId=@LangId and  Live.[Parameter.OddType].IsActive=1 


 




END





GO
