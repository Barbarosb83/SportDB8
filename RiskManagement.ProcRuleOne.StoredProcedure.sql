USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcRuleOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcRuleOne]
@RuleId bigint,
@username nvarchar(max)


AS



BEGIN
SET NOCOUNT ON;



--SELECT     RiskManagement.[Rule].RuleId, RiskManagement.[Rule].SportId, RiskManagement.[Rule].CategoryId, RiskManagement.[Rule].TournamentId, 
--                      RiskManagement.[Rule].CompetitorId, RiskManagement.[Rule].StateId, RiskManagement.[Rule].LossLimit, RiskManagement.[Rule].LimitPerTicket, 
--                      RiskManagement.[Rule].StakeLimit, RiskManagement.[Rule].AvailabilityId, RiskManagement.[Rule].MinCombiBranch, RiskManagement.[Rule].MinCombiInternet, 
--                      RiskManagement.[Rule].MinCombiMachine, RiskManagement.[Rule].StarDate, RiskManagement.[Rule].StopDate, RiskManagement.[Rule].IsActive, 
--                      RiskManagement.[Rule].Comment, Parameter.MatchAvailability.Availability, RiskManagement.[Rule].IsPopular, RiskManagement.[Rule].MaxGainTicket
--FROM         RiskManagement.[Rule] INNER JOIN
--                      Parameter.MatchAvailability ON RiskManagement.[Rule].AvailabilityId = Parameter.MatchAvailability.AvailabilityId
--WHERE     (RiskManagement.[Rule].RuleId = @RuleId)


SELECT     RiskManagement.[Rule].RuleId, RiskManagement.[Rule].SportId, CASE WHEN RiskManagement.[Rule].SportId != - 1 THEN
                          (SELECT     Parameter.Sport.SportName
                            FROM          Parameter.Sport
                            WHERE      Parameter.Sport.SportId = RiskManagement.[Rule].SportId) ELSE 'All' END AS SportName, RiskManagement.[Rule].CategoryId, 
                      CASE WHEN RiskManagement.[Rule].CategoryId != - 1 THEN
                          (SELECT     TOP 1 CategoryName
                            FROM          Parameter.Category
                            WHERE      Parameter.Category.CategoryId = RiskManagement.[Rule].CategoryId) ELSE 'All' END AS CategoryName, RiskManagement.[Rule].TournamentId, 
                      CASE WHEN RiskManagement.[Rule].TournamentId != - 1 THEN ISNULL
                          ((SELECT     Language.[Parameter.Tournament].TournamentName
                              FROM         Language.[Parameter.Tournament]
                              WHERE     Language.[Parameter.Tournament].TournamentId = Parameter.Tournament.TournamentId AND LanguageId = 1), '') ELSE 'All' END AS TournamentName, 
                      RiskManagement.[Rule].CompetitorId, 
                      CASE WHEN RiskManagement.[Rule].CompetitorId != - 1 THEN Parameter.Competitor.CompetitorName ELSE 'All' END AS CompetitorName, 
                      Parameter.MatchAvailability.AvailabilityId, Parameter.MatchAvailability.Availability, Parameter.MatchState.StateId, Parameter.MatchState.State, 
                      RiskManagement.[Rule].LossLimit, RiskManagement.[Rule].LimitPerTicket, RiskManagement.[Rule].StakeLimit, RiskManagement.[Rule].MinCombiBranch, 
                      RiskManagement.[Rule].MinCombiInternet, RiskManagement.[Rule].MinCombiMachine, RiskManagement.[Rule].StarDate, RiskManagement.[Rule].StopDate, 
                      RiskManagement.[Rule].IsActive, RiskManagement.[Rule].Comment, RiskManagement.[Rule].IsPopular, RiskManagement.[Rule].MaxGainTicket
FROM         Parameter.Category INNER JOIN
                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                      Parameter.Tournament ON Parameter.Category.CategoryId = Parameter.Tournament.CategoryId RIGHT OUTER JOIN
                      Parameter.Competitor RIGHT OUTER JOIN
                      RiskManagement.[Rule] INNER JOIN
                      Parameter.MatchAvailability ON RiskManagement.[Rule].AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.MatchState ON RiskManagement.[Rule].StateId = Parameter.MatchState.StateId ON 
                      Parameter.Competitor.CompetitorId = RiskManagement.[Rule].CompetitorId ON Parameter.Tournament.TournamentId = RiskManagement.[Rule].TournamentId AND 
                      Parameter.Category.CategoryId = RiskManagement.[Rule].CategoryId AND Parameter.Sport.SportId = RiskManagement.[Rule].SportId
WHERE     (RiskManagement.[Rule].RuleId = @RuleId)

END


GO
