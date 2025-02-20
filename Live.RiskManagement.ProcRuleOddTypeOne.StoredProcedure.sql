USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcRuleOddTypeOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[RiskManagement.ProcRuleOddTypeOne]
@RuleOddTypeId bigint,
@username nvarchar(max)


AS



BEGIN
SET NOCOUNT ON;



SELECT     Live.[RiskManagement.RuleOddType].RuleOddTypeId, Live.[RiskManagement.RuleOddType].RuleId, Live.[RiskManagement.RuleOddType].OddTypeId, Live.[Parameter.OddType].OddType, 
                      Live.[RiskManagement.RuleOddType].StateId, Live.[RiskManagement.RuleOddType].LossLimit, Live.[RiskManagement.RuleOddType].LimitPerTicket, 
                      Live.[RiskManagement.RuleOddType].StakeLimit, Live.[RiskManagement.RuleOddType].AvailabilityId, Live.[RiskManagement.RuleOddType].MinCombiBranch, 
                      Live.[RiskManagement.RuleOddType].MinCombiInternet, Live.[RiskManagement.RuleOddType].MinCombiMachine, Live.[RiskManagement.RuleOddType].Comment, 
                      Parameter.MatchState.State, Parameter.MatchAvailability.Availability,Live.[RiskManagement.RuleOddType].IsPopular,Live.[RiskManagement.RuleOddType].MaxGainTicket
FROM         Live.[Parameter.OddType] with (nolock) INNER JOIN
                      Live.[RiskManagement.RuleOddType] with (nolock) ON Live.[Parameter.OddType].OddTypeId = Live.[RiskManagement.RuleOddType].OddTypeId INNER JOIN
                      Parameter.MatchState with (nolock) ON Live.[RiskManagement.RuleOddType].StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON Live.[RiskManagement.RuleOddType].AvailabilityId = Parameter.MatchAvailability.AvailabilityId
Where Live.[RiskManagement.RuleOddType].RuleOddTypeId=@RuleOddTypeId




END


GO
