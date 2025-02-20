USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOddTypeDetailOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcGameDataOddTypeDetailOne] 
@OddId int,
@LangId int,
@Username nvarchar(50)
AS
BEGIN
SET NOCOUNT ON;


SELECT     Match.Odd.OddId, Match.OddTypeSetting.OddTypeSettingId as OddSettingId, Language.[Parameter.OddsType].OddsTypeId, Language.[Parameter.OddsType].OddsType, Match.Odd.OutCome, 
                     0 as OutComeId, Match.Odd.SpecialBetValue, Match.Odd.OddValue, Match.Odd.Suggestion, Match.Odd.StateId, Match.OddTypeSetting.LossLimit, Match.OddTypeSetting.LimitPerTicket, 
                      Match.OddTypeSetting.StakeLimit, Match.OddTypeSetting.AvailabilityId, Match.OddTypeSetting.MinCombiBranch, Match.OddTypeSetting.MinCombiInternet, 
                      Match.OddTypeSetting.MinCombiMachine, Parameter.MatchAvailability.Availability, Parameter.MatchState.State, Match.Odd.MatchId
                      ,case when Match.Odd.IsOddValueLock=1 then 'Manuel' else 'Auto' end as OddChange,Match.Odd.IsOddValueLock
FROM         Match.Odd INNER JOIN
                      Match.OddTypeSetting ON Match.Odd.OddsTypeId = Match.OddTypeSetting.OddTypeId and Match.Odd.MatchId=Match.OddTypeSetting.MatchId INNER JOIN
                      Language.[Parameter.OddsType] ON Match.Odd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
                      Parameter.MatchState ON Match.Odd.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON Match.OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Match.Odd.OddId= @OddId)

END


GO
