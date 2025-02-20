USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOddTypeResultDetailOne_BettingLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcGameDataOddTypeResultDetailOne_BettingLive] 
@OddId int,
@LangId int,
@Username nvarchar(50),
@BetType int
AS
BEGIN
SET NOCOUNT ON;

if(@BetType=0)
begin
if exists(select Archive.Odd.OddId from Archive.Odd with (nolock) where Archive.Odd.OddId=@OddId)
begin
	SELECT     [Archive].Odd.OddId, [Archive].OddTypeSetting.OddTypeSettingId as OddSettingId, Language.[Parameter.OddsType].OddsTypeId, Language.[Parameter.OddsType].OddsType, [Archive].Odd.OutCome, 
						  0 as OutComeId, [Archive].Odd.SpecialBetValue, [Archive].Odd.OddValue, [Archive].Odd.Suggestion, [Archive].Odd.StateId, [Archive].OddTypeSetting.LossLimit, [Archive].OddTypeSetting.LimitPerTicket, 
						  [Archive].OddTypeSetting.StakeLimit, [Archive].OddTypeSetting.AvailabilityId, [Archive].OddTypeSetting.MinCombiBranch, [Archive].OddTypeSetting.MinCombiInternet, 
						  [Archive].OddTypeSetting.MinCombiMachine, Parameter.MatchAvailability.Availability, Parameter.MatchState.State, [Archive].Odd.MatchId
						  ,case when [Archive].Odd.IsOddValueLock=1 then 'Manuel' else 'Auto' end as OddChange,[Archive].Odd.IsOddValueLock
	FROM         [Archive].Odd  with (nolock)  INNER JOIN
						  [Archive].OddTypeSetting  with (nolock)  ON [Archive].Odd.OddsTypeId = [Archive].OddTypeSetting.OddTypeId and [Archive].Odd.MatchId = [Archive].OddTypeSetting.MatchId INNER JOIN
						  Language.[Parameter.OddsType] with (nolock)  ON [Archive].Odd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
						  Parameter.MatchState with (nolock)  ON [Archive].Odd.StateId = Parameter.MatchState.StateId INNER JOIN
						  Parameter.MatchAvailability with (nolock)  ON [Archive].OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
	WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) AND ([Archive].Odd.OddId= @OddId)
end
else
begin
	SELECT     [Match].Odd.OddId, [Match].OddTypeSetting.OddTypeSettingId as OddSettingId, Language.[Parameter.OddsType].OddsTypeId, Language.[Parameter.OddsType].OddsType, [Match].Odd.OutCome, 
						  0 as OutComeId, [Match].Odd.SpecialBetValue, [Match].Odd.OddValue, [Match].Odd.Suggestion, [Match].Odd.StateId, [Match].OddTypeSetting.LossLimit, [Match].OddTypeSetting.LimitPerTicket, 
						  [Match].OddTypeSetting.StakeLimit, [Match].OddTypeSetting.AvailabilityId, [Match].OddTypeSetting.MinCombiBranch, [Match].OddTypeSetting.MinCombiInternet, 
						  [Match].OddTypeSetting.MinCombiMachine, Parameter.MatchAvailability.Availability, Parameter.MatchState.State, [Match].Odd.MatchId
						  ,case when [Match].Odd.IsOddValueLock=1 then 'Manuel' else 'Auto' end as OddChange,[Match].Odd.IsOddValueLock
	FROM         [Match].Odd  with (nolock)  INNER JOIN
						  [Match].OddTypeSetting  with (nolock)  ON [Match].Odd.OddsTypeId = [Match].OddTypeSetting.OddTypeId and [Match].Odd.MatchId = [Match].OddTypeSetting.MatchId INNER JOIN
						  Language.[Parameter.OddsType] with (nolock)  ON [Match].Odd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
						  Parameter.MatchState with (nolock)  ON [Match].Odd.StateId = Parameter.MatchState.StateId INNER JOIN
						  Parameter.MatchAvailability with (nolock)  ON [Match].OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
	WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) AND ([Match].Odd.OddId= @OddId)
end
end
else
begin
	if exists (select [Archive].[Live.EventOdd].OddId from [Archive].[Live.EventOdd] with (nolock) where [Archive].[Live.EventOdd].OddId= @OddId)
	begin
	SELECT      [Archive].[Live.EventOdd].OddId,[Archive].[Live.EventOddTypeSetting].OddTypeSettingId as OddSettingId , Language.[Parameter.LiveOddType].OddTypeId as OddsTypeId, Language.[Parameter.LiveOddType].OddsType,  [Archive].[Live.EventOdd].OutCome, 
						  0 as OutComeId,  [Archive].[Live.EventOdd].SpecialBetValue, [Archive].[Live.EventOdd].Suggestion as OddValue,  [Archive].[Live.EventOdd].Suggestion,ISNULL([BettingLive].[Archive].[Live.EventOddResult].StateId,1) as StateId,[Archive].[Live.EventOddTypeSetting].LossLimit,[Archive].[Live.EventOddTypeSetting].LimitPerTicket, 
						 [Archive].[Live.EventOddTypeSetting].StakeLimit,[Archive].[Live.EventOddTypeSetting].AvailabilityId,[Archive].[Live.EventOddTypeSetting].MinCombiBranch,[Archive].[Live.EventOddTypeSetting].MinCombiInternet, 
						 [Archive].[Live.EventOddTypeSetting].MinCombiMachine, Parameter.MatchAvailability.Availability, Parameter.MatchState.State,  [Archive].[Live.EventOdd].MatchId
						  ,case when  [Archive].[Live.EventOdd].IsOddValueLock=1 then 'Manuel' else 'Auto' end as OddChange, [Archive].[Live.EventOdd].IsOddValueLock
	FROM         [Archive].[Live.EventOdd] with (nolock)  INNER JOIN
						  [Archive].[Live.EventOddTypeSetting]  with (nolock)  ON  [Archive].[Live.EventOdd].OddsTypeId = [Archive].[Live.EventOddTypeSetting].OddTypeId and [Archive].[Live.EventOdd].MatchId = [Archive].[Live.EventOddTypeSetting].MatchId INNER JOIN
						  Language.[Parameter.LiveOddType] with (nolock)  ON [Archive].[Live.EventOdd].OddsTypeId = Language.[Parameter.LiveOddType].OddTypeId LEFT OUTER JOIN 
						  [BettingLive].Archive.[Live.EventOddResult] with (nolock)  On [BettingLive].Archive.[Live.EventOddResult].OddId=Archive.[Live.EventOdd].OddId INNER JOIN
						  Parameter.MatchState ON ISNULL([BettingLive].[Archive].[Live.EventOddResult].StateId,1) = Parameter.MatchState.StateId INNER JOIN
						  Parameter.MatchAvailability ON [Archive].[Live.EventOddTypeSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId
	WHERE     (Language.[Parameter.LiveOddType].LanguageId = @LangId) AND ([Archive].[Live.EventOdd].OddId= @OddId)
	end
	else
	begin
		SELECT      Live.EventOdd.OddId,Live.EventOddTypeSetting.OddTypeSettingId as OddSettingId, Language.[Parameter.LiveOddType].OddTypeId as OddsTypeId, Language.[Parameter.LiveOddType].OddsType,  Live.EventOdd.OutCome, 
						  0 as OutComeId,  Live.EventOdd.SpecialBetValue,  Live.EventOdd.Suggestion as OddValue,  Live.EventOdd.Suggestion,[BettingLive].Live.EventOddResult.StateId,Live.EventOddTypeSetting.LossLimit,Live.EventOddTypeSetting.LimitPerTicket, 
						 Live.EventOddTypeSetting.StakeLimit,Live.EventOddTypeSetting.AvailabilityId,Live.EventOddTypeSetting.MinCombiBranch,Live.EventOddTypeSetting.MinCombiInternet, 
						 Live.EventOddTypeSetting.MinCombiMachine, Parameter.MatchAvailability.Availability, Parameter.MatchState.State,  Live.EventOdd.MatchId
						  ,case when  Live.EventOdd.IsOddValueLock=1 then 'Manuel' else 'Auto' end as OddChange, Live.EventOdd.IsOddValueLock
	FROM         Live.EventOdd with (nolock) INNER JOIN
						  Live.EventOddTypeSetting with (nolock) ON  Live.EventOdd.OddsTypeId = Live.EventOddTypeSetting.OddTypeId and Live.EventOdd.MatchId = Live.EventOddTypeSetting.MatchId INNER JOIN
						  Language.[Parameter.LiveOddType] with (nolock)  ON Live.EventOdd.OddsTypeId = Language.[Parameter.LiveOddType].OddTypeId LEFT OUTER JOIN 
						  [BettingLive].Live.EventOddResult with (nolock)  On [BettingLive].Live.EventOddResult.OddId=Live.EventOdd.OddId INNER JOIN
						  Parameter.MatchState with (nolock)  ON ISNULL([BettingLive].Live.EventOddResult.StateId,1) = Parameter.MatchState.StateId INNER JOIN
						  Parameter.MatchAvailability with (nolock)  ON Live.EventOddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
	WHERE     (Language.[Parameter.LiveOddType].LanguageId = @LangId) AND (Live.EventOdd.OddId= @OddId)
	end

end
END


GO
