USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcRuleOddTypeOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcRuleOddTypeOne]
@RuleOddTypeId bigint,
@username nvarchar(max)


AS



BEGIN
SET NOCOUNT ON;



SELECT     RiskManagement.RuleOddType.RuleOddTypeId, RiskManagement.RuleOddType.RuleId, RiskManagement.RuleOddType.OddTypeId, Parameter.OddsType.OddsType, 
                      RiskManagement.RuleOddType.StateId, RiskManagement.RuleOddType.LossLimit, RiskManagement.RuleOddType.LimitPerTicket, 
                      RiskManagement.RuleOddType.StakeLimit, RiskManagement.RuleOddType.AvailabilityId, RiskManagement.RuleOddType.MinCombiBranch, 
                      RiskManagement.RuleOddType.MinCombiInternet, RiskManagement.RuleOddType.MinCombiMachine, RiskManagement.RuleOddType.Comment, 
                      Parameter.MatchState.State, Parameter.MatchAvailability.Availability,RiskManagement.RuleOddType.IsPopular,RiskManagement.RuleOddType.MaxGainTicket
FROM         Parameter.OddsType INNER JOIN
                      RiskManagement.RuleOddType ON Parameter.OddsType.OddsTypeId = RiskManagement.RuleOddType.OddTypeId INNER JOIN
                      Parameter.MatchState ON RiskManagement.RuleOddType.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability ON RiskManagement.RuleOddType.AvailabilityId = Parameter.MatchAvailability.AvailabilityId
WHERE     (RiskManagement.RuleOddType.RuleOddTypeId = @RuleOddTypeId)


END


GO
