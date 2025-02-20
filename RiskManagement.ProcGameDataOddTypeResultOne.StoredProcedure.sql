USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOddTypeResultOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcGameDataOddTypeResultOne] 
@OddTypeId int,
@MatchId bigint,
@LangId int,
@Username nvarchar(50)
AS
BEGIN
SET NOCOUNT ON;

declare @OddtypeSettingId bigint

select @OddtypeSettingId=[Archive].OddTypeSetting.OddTypeSettingId from [Archive].OddTypeSetting
where [Archive].OddTypeSetting.OddTypeId=@OddtypeId and MatchId=@MatchId


SELECT     [Archive].OddTypeSetting.OddTypeSettingId,[Archive].OddTypeSetting.OddTypeId, Language.[Parameter.OddsType].OddsType, [Archive].OddTypeSetting.StateId, [Archive].OddTypeSetting.LossLimit, 
                      [Archive].OddTypeSetting.LimitPerTicket, [Archive].OddTypeSetting.StakeLimit, [Archive].OddTypeSetting.AvailabilityId, [Archive].OddTypeSetting.MinCombiBranch, 
                      [Archive].OddTypeSetting.MinCombiInternet, [Archive].OddTypeSetting.MinCombiMachine, Parameter.MatchAvailability.Availability, Parameter.MatchState.State,
                      (select top 1 ISNULL([Archive].Odd.SpecialBetValue,'') from [Archive].Odd where [Archive].Odd.MatchId=[Archive].OddTypeSetting.MatchId and [Archive].Odd.OddsTypeId=[Archive].OddTypeSetting.OddTypeId) as SpecialBetValue,[Archive].OddTypeSetting.IsPopular
FROM         [Archive].OddTypeSetting INNER JOIN
                      Language.[Parameter.OddsType] ON [Archive].OddTypeSetting.OddTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
                      Parameter.MatchState ON [Archive].OddTypeSetting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON [Archive].OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) AND ([Archive].OddTypeSetting.OddTypeSettingId = @OddTypeSettingId) 

END


GO
