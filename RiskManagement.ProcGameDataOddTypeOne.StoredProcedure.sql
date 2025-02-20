USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOddTypeOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcGameDataOddTypeOne] 
@OddTypeId int,
@MatchId bigint,
@LangId int,
@Username nvarchar(50)
AS
BEGIN
SET NOCOUNT ON;

declare @OddtypeSettingId bigint

select @OddtypeSettingId=Match.OddTypeSetting.OddTypeSettingId from Match.OddTypeSetting
where Match.OddTypeSetting.OddTypeId=@OddtypeId and MatchId=@MatchId


SELECT     Match.OddTypeSetting.OddTypeSettingId,Match.OddTypeSetting.OddTypeId, Language.[Parameter.OddsType].OddsType, Match.OddTypeSetting.StateId, Match.OddTypeSetting.LossLimit, 
                      Match.OddTypeSetting.LimitPerTicket, Match.OddTypeSetting.StakeLimit, Match.OddTypeSetting.AvailabilityId, Match.OddTypeSetting.MinCombiBranch, 
                      Match.OddTypeSetting.MinCombiInternet, Match.OddTypeSetting.MinCombiMachine, Parameter.MatchAvailability.Availability, Parameter.MatchState.State,
                      (select top 1 ISNULL(Match.Odd.SpecialBetValue,'') from Match.Odd where Match.Odd.MatchId=Match.OddTypeSetting.MatchId and Match.Odd.OddsTypeId=Match.OddTypeSetting.OddTypeId) as SpecialBetValue,Match.OddTypeSetting.IsPopular
FROM         Match.OddTypeSetting INNER JOIN
                      Language.[Parameter.OddsType] ON Match.OddTypeSetting.OddTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
                      Parameter.MatchState ON Match.OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON Match.OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Match.OddTypeSetting.OddTypeSettingId = @OddTypeSettingId) 

END


GO
