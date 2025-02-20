USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcRuleOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[RiskManagement.ProcRuleOne]
@RuleId bigint,
@username nvarchar(max)


AS



BEGIN
SET NOCOUNT ON;


SELECT     Live.[RiskManagement.Rule].RuleId, Live.[RiskManagement.Rule].SportId, 
CASE WHEN Live.[RiskManagement.Rule].SportId != - 1 THEN
                          (SELECT     Parameter.Sport.SportName
                            FROM          Parameter.Sport with (nolock)
                            WHERE      Parameter.Sport.SportId = Live.[RiskManagement.Rule].SportId) ELSE 'All' END AS SportName,

Live.[RiskManagement.Rule].CategoryId, 
CASE WHEN Live.[RiskManagement.Rule].CategoryId != - 1 THEN
                          (SELECT     TOP 1 CategoryName
                            FROM          Parameter.Category with (nolock)
                            WHERE      Parameter.Category.CategoryId = Live.[RiskManagement.Rule].CategoryId) ELSE 'All' END AS CategoryName,
Live.[RiskManagement.Rule].TournamentId, 
CASE WHEN Live.[RiskManagement.Rule].TournamentId != - 1 THEN ISNULL
                          ((SELECT    Parameter.Tournament.TournamentName
                              FROM         Parameter.Tournament with (nolock)
                              WHERE     Parameter.Tournament.TournamentId=Live.[RiskManagement.Rule].TournamentId ), '') ELSE 'All' END AS TournamentName,
                      Live.[RiskManagement.Rule].CompetitorId, Live.[RiskManagement.Rule].StateId, Live.[RiskManagement.Rule].LossLimit, Live.[RiskManagement.Rule].LimitPerTicket, 
                      Live.[RiskManagement.Rule].StakeLimit, Live.[RiskManagement.Rule].AvailabilityId, Live.[RiskManagement.Rule].MinCombiBranch, Live.[RiskManagement.Rule].MinCombiInternet, 
                      Live.[RiskManagement.Rule].MinCombiMachine, Live.[RiskManagement.Rule].StarDate, Live.[RiskManagement.Rule].StopDate, Live.[RiskManagement.Rule].IsActive, 
                      Live.[RiskManagement.Rule].Comment, Parameter.MatchAvailability.Availability, Live.[RiskManagement.Rule].IsPopular, Live.[RiskManagement.Rule].MaxGainTicket
FROM         Live.[RiskManagement.Rule] with (nolock) INNER JOIN
                      Parameter.MatchAvailability  with (nolock) ON Live.[RiskManagement.Rule].AvailabilityId = Parameter.MatchAvailability.AvailabilityId
WHERE     (Live.[RiskManagement.Rule].RuleId = @RuleId)



END


GO
