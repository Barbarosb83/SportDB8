USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOutrigthsOddTypeOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcGameDataOutrigthsOddTypeOne] 
@OddTypeId int,
@MatchId bigint,
@LangId int,
@Username nvarchar(50)
AS
BEGIN
SET NOCOUNT ON;

declare @OddtypeSettingId bigint

select @OddtypeSettingId=Outrights.OddTypeSetting.OddTypeSettingId from Outrights.OddTypeSetting
where Outrights.OddTypeSetting.OddTypeId=@OddtypeId and MatchId=@MatchId


SELECT    Outrights.OddTypeSetting.OddTypeSettingId, Outrights.OddTypeSetting.OddTypeId, Outrights.OddTypeSetting.StateId, Outrights.OddTypeSetting.LossLimit, 
                      Outrights.OddTypeSetting.LimitPerTicket, Outrights.OddTypeSetting.AvailabilityId, Outrights.OddTypeSetting.StakeLimit, Outrights.OddTypeSetting.MinCombiBranch, 
                      Outrights.OddTypeSetting.MinCombiInternet, Outrights.OddTypeSetting.MinCombiMachine, Outrights.OddTypeSetting.MatchId, Outrights.OddTypeSetting.IsPopular, 
                      Language.[Parameter.OddsType].OddsType, Parameter.MatchState.State, Parameter.MatchState.StatuColor, Parameter.MatchAvailability.Availability,
                      (select top 1 ISNULL(Outrights.Odd.SpecialBetValue,'') from Outrights.Odd where Outrights.Odd.MatchId=Outrights.OddTypeSetting.MatchId and Outrights.Odd.OddsTypeId=Outrights.OddTypeSetting.OddTypeId) as SpecialBetValue
FROM         Outrights.OddTypeSetting INNER JOIN
                      Parameter.MatchAvailability ON Outrights.OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.MatchState ON Outrights.OddTypeSetting.StateId = Parameter.MatchState.StateId CROSS JOIN
                      Language.[Parameter.OddsType]
WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Outrights.OddTypeSetting.OddTypeSettingId = @OddTypeSettingId) 

END


GO
