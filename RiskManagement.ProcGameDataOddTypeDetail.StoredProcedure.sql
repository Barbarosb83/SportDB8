USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOddTypeDetail]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcGameDataOddTypeDetail] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(200),
@orderby nvarchar(100),
@MatchId int,
@OddTypeId int, 
@LangId int
AS
BEGIN
SET NOCOUNT ON;


SELECT     Match.Odd.OddId, Match.OddTypeSetting.OddTypeSettingId as OddSettingId, Language.[Parameter.OddsType].OddsTypeId, Language.[Parameter.OddsType].OddsType, Match.Odd.OutCome+' '+ISNULL(Match.Odd.SpecialBetValue,'') as OutCome, 
                      0 as OutComeId, Match.Odd.SpecialBetValue, Match.Odd.OddValue, Match.Odd.Suggestion, 
                      CASE WHEN Parameter.MatchState.StateId=1 THEN 3 ELSE 1 END AS StatuColor, Match.Odd.StateId, Match.OddTypeSetting.LossLimit, 
                      Match.OddTypeSetting.LimitPerTicket, Match.OddTypeSetting.StakeLimit, Match.OddTypeSetting.AvailabilityId, Match.OddTypeSetting.MinCombiBranch, 
                      Match.OddTypeSetting.MinCombiInternet, Match.OddTypeSetting.MinCombiMachine, Parameter.MatchAvailability.Availability, Parameter.MatchState.State, Match.Odd.MatchId, 
                      CASE WHEN Match.Odd.IsOddValueLock = 1 THEN 'Manuel' ELSE 'Auto' END AS OddChange, dbo.FuncCashFlow(Match.Odd.OddId, 88123, 0,0) AS Cashflow,(dbo.FuncCashFlow(Match.Odd.OddId, 88123, 0,0)*Match.Odd.OddValue) as PossibleLost
FROM         Match.Odd INNER JOIN
                      Match.OddTypeSetting ON Match.Odd.OddsTypeId = Match.OddTypeSetting.OddTypeId and Match.Odd.MatchId=Match.OddTypeSetting.MatchId INNER JOIN
                      Language.[Parameter.OddsType] ON Match.Odd.OddsTypeId = Language.[Parameter.OddsType].OddsTypeId INNER JOIN
                      Parameter.MatchState ON Match.Odd.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON Match.OddTypeSetting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
WHERE     (Language.[Parameter.OddsType].LanguageId = @LangId) AND (Match.Odd.MatchId = @MatchId) AND (Match.Odd.OddsTypeId=@OddTypeId )
END


GO
