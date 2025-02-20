USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcRule]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[RiskManagement.ProcRule]
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int


AS



BEGIN
SET NOCOUNT ON;
SELECT     Live.[RiskManagement.Rule].RuleId, Live.[RiskManagement.Rule].SportId, CASE WHEN Live.[RiskManagement.Rule].SportId != - 1 THEN
                          (SELECT     Parameter.Sport.SportName
                            FROM          Parameter.Sport with (nolock)
                            WHERE      Parameter.Sport.SportId = Live.[RiskManagement.Rule].SportId) ELSE 'All' END AS SportName, Live.[RiskManagement.Rule].CategoryId, 
                      CASE WHEN Live.[RiskManagement.Rule].CategoryId != - 1 THEN
                          (SELECT     TOP 1 CategoryName
                            FROM          Parameter.Category with (nolock)
                            WHERE      Parameter.Category.CategoryId = Live.[RiskManagement.Rule].CategoryId) ELSE 'All' END AS CategoryName, Live.[RiskManagement.Rule].TournamentId, 
                      CASE WHEN Live.[RiskManagement.Rule].TournamentId != - 1 THEN ISNULL
                          ((SELECT     PT.TournamentName
                              FROM       Parameter.Tournament as PT with (nolock)
                              WHERE     PT.TournamentId = Parameter.Tournament.TournamentId ), '') ELSE 'All' END AS TournamentName, 
                       Live.[RiskManagement.Rule].CompetitorId, 
                      CASE WHEN Live.[RiskManagement.Rule].CompetitorId != - 1 THEN Parameter.Competitor.CompetitorName ELSE 'All' END AS CompetitorName, 
                      Parameter.MatchAvailability.AvailabilityId, Parameter.MatchAvailability.Availability, Parameter.MatchState.StateId, Parameter.MatchState.State, 
                      Live.[RiskManagement.Rule].LossLimit, Live.[RiskManagement.Rule].LimitPerTicket, Live.[RiskManagement.Rule].StakeLimit, Live.[RiskManagement.Rule].MinCombiBranch, 
                      Live.[RiskManagement.Rule].MinCombiInternet, Live.[RiskManagement.Rule].MinCombiMachine, Live.[RiskManagement.Rule].StarDate, Live.[RiskManagement.Rule].StopDate, 
                      Live.[RiskManagement.Rule].IsActive, Live.[RiskManagement.Rule].Comment, Live.[RiskManagement.Rule].IsPopular, Live.[RiskManagement.Rule].MaxGainTicket
FROM         Parameter.Category with (nolock) INNER JOIN
                      Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                      Parameter.Tournament with (nolock) ON Parameter.Category.CategoryId = Parameter.Tournament.CategoryId RIGHT OUTER JOIN
                      Parameter.Competitor with (nolock) RIGHT OUTER JOIN
                      Live.[RiskManagement.Rule] with (nolock) INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON Live.[RiskManagement.Rule].AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.MatchState with (nolock) ON Live.[RiskManagement.Rule].StateId = Parameter.MatchState.StateId ON 
                      Parameter.Competitor.CompetitorId = Live.[RiskManagement.Rule].CompetitorId ON Parameter.Tournament.TournamentId = Live.[RiskManagement.Rule].TournamentId AND 
                      Parameter.Category.CategoryId = Live.[RiskManagement.Rule].CategoryId AND Parameter.Sport.SportId = Live.[RiskManagement.Rule].SportId
END


GO
