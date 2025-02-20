USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcRule]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcRule]
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int


AS



BEGIN
SET NOCOUNT ON;


--SELECT     RiskManagement.[Rule].RuleId, RiskManagement.[Rule].SportId, CASE WHEN RiskManagement.[Rule].SportId != - 1 THEN
--                          (SELECT     Parameter.Sport.SportName
--                            FROM          Parameter.Sport
--                            WHERE      Parameter.Sport.SportId = RiskManagement.[Rule].SportId) ELSE 'All' END AS SportName, RiskManagement.[Rule].CategoryId, 
--                      CASE WHEN RiskManagement.[Rule].CategoryId != - 1 THEN
--                          (SELECT     TOP 1 CategoryName
--                            FROM          Parameter.Category
--                            WHERE      Parameter.Category.CategoryId = RiskManagement.[Rule].CategoryId) ELSE 'All' END AS CategoryName, RiskManagement.[Rule].TournamentId, 
--                      CASE WHEN RiskManagement.[Rule].TournamentId != - 1 THEN ISNULL
--                          ((SELECT     Language.[Parameter.Tournament].TournamentName
--                              FROM         Language.[Parameter.Tournament]
--                              WHERE     Language.[Parameter.Tournament].TournamentId = Parameter.Tournament.TournamentId AND LanguageId = 1), '') ELSE 'All' END AS TournamentName, 
--                      RiskManagement.[Rule].CompetitorId, 
--                      CASE WHEN RiskManagement.[Rule].CompetitorId != - 1 THEN Parameter.Competitor.CompetitorName ELSE 'All' END AS CompetitorName, 
--                      Parameter.MatchAvailability.AvailabilityId, Parameter.MatchAvailability.Availability, Parameter.MatchState.StateId, Parameter.MatchState.State, 
--                      RiskManagement.[Rule].LossLimit, RiskManagement.[Rule].LimitPerTicket, RiskManagement.[Rule].StakeLimit, RiskManagement.[Rule].MinCombiBranch, 
--                      RiskManagement.[Rule].MinCombiInternet, RiskManagement.[Rule].MinCombiMachine, RiskManagement.[Rule].StarDate, RiskManagement.[Rule].StopDate, 
--                      RiskManagement.[Rule].IsActive, RiskManagement.[Rule].Comment, RiskManagement.[Rule].IsPopular, RiskManagement.[Rule].MaxGainTicket
--FROM         Parameter.Category INNER JOIN
--                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
--                      Parameter.Tournament ON Parameter.Category.CategoryId = Parameter.Tournament.CategoryId RIGHT OUTER JOIN
--                      Parameter.Competitor RIGHT OUTER JOIN
--                      RiskManagement.[Rule] INNER JOIN
--                      Parameter.MatchAvailability ON RiskManagement.[Rule].AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
--                      Parameter.MatchState ON RiskManagement.[Rule].StateId = Parameter.MatchState.StateId ON 
--                      Parameter.Competitor.CompetitorId = RiskManagement.[Rule].CompetitorId ON Parameter.Tournament.TournamentId = RiskManagement.[Rule].TournamentId AND 
--                      Parameter.Category.CategoryId = RiskManagement.[Rule].CategoryId AND Parameter.Sport.SportId = RiskManagement.[Rule].SportId
                      
                      
                      

declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)


set @sqlcommand='declare @total int '+
'select @total=COUNT(RiskManagement.[Rule].RuleId) '+
'FROM         Parameter.Category INNER JOIN
                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                      Parameter.Tournament ON Parameter.Category.CategoryId = Parameter.Tournament.CategoryId RIGHT OUTER JOIN
                      Parameter.Competitor RIGHT OUTER JOIN
                      RiskManagement.[Rule] INNER JOIN
                      Parameter.MatchAvailability ON RiskManagement.[Rule].AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.MatchState ON RiskManagement.[Rule].StateId = Parameter.MatchState.StateId ON 
                      Parameter.Competitor.CompetitorId = RiskManagement.[Rule].CompetitorId ON Parameter.Tournament.TournamentId = RiskManagement.[Rule].TournamentId AND 
                      Parameter.Category.CategoryId = RiskManagement.[Rule].CategoryId AND Parameter.Sport.SportId = RiskManagement.[Rule].SportId '+
'WHERE (1 = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'	RiskManagement.[Rule].RuleId, RiskManagement.[Rule].SportId, CASE WHEN RiskManagement.[Rule].SportId != - 1 THEN
                          (SELECT     Parameter.Sport.SportName
                            FROM          Parameter.Sport
                            WHERE      Parameter.Sport.SportId = RiskManagement.[Rule].SportId) ELSE ''All'' END AS SportName, RiskManagement.[Rule].CategoryId, 
                      CASE WHEN RiskManagement.[Rule].CategoryId != - 1 THEN
                          (SELECT     TOP 1 CategoryName
                            FROM          Parameter.Category
                            WHERE      Parameter.Category.CategoryId = RiskManagement.[Rule].CategoryId) ELSE ''All'' END AS CategoryName, RiskManagement.[Rule].TournamentId, 
                      CASE WHEN RiskManagement.[Rule].TournamentId != - 1 THEN ISNULL
                          ((SELECT     Language.[Parameter.Tournament].TournamentName
                              FROM         Language.[Parameter.Tournament]
                              WHERE     Language.[Parameter.Tournament].TournamentId = Parameter.Tournament.TournamentId AND LanguageId = 1), '''') ELSE ''All'' END AS TournamentName, 
                      RiskManagement.[Rule].CompetitorId, 
                      CASE WHEN RiskManagement.[Rule].CompetitorId != - 1 THEN Parameter.Competitor.CompetitorName ELSE ''All'' END AS CompetitorName, 
                      Parameter.MatchAvailability.AvailabilityId, Parameter.MatchAvailability.Availability, Parameter.MatchState.StateId, Parameter.MatchState.State, 
                      RiskManagement.[Rule].LossLimit, RiskManagement.[Rule].LimitPerTicket, RiskManagement.[Rule].StakeLimit, RiskManagement.[Rule].MinCombiBranch, 
                      RiskManagement.[Rule].MinCombiInternet, RiskManagement.[Rule].MinCombiMachine, RiskManagement.[Rule].StarDate, RiskManagement.[Rule].StopDate, 
                      RiskManagement.[Rule].IsActive, RiskManagement.[Rule].Comment, RiskManagement.[Rule].IsPopular, RiskManagement.[Rule].MaxGainTicket '


set @sqlcommand2= 'FROM         Parameter.Category INNER JOIN
                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                      Parameter.Tournament ON Parameter.Category.CategoryId = Parameter.Tournament.CategoryId RIGHT OUTER JOIN
                      Parameter.Competitor RIGHT OUTER JOIN
                      RiskManagement.[Rule] INNER JOIN
                      Parameter.MatchAvailability ON RiskManagement.[Rule].AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.MatchState ON RiskManagement.[Rule].StateId = Parameter.MatchState.StateId ON 
                      Parameter.Competitor.CompetitorId = RiskManagement.[Rule].CompetitorId ON Parameter.Tournament.TournamentId = RiskManagement.[Rule].TournamentId AND 
                      Parameter.Category.CategoryId = RiskManagement.[Rule].CategoryId AND Parameter.Sport.SportId = RiskManagement.[Rule].SportId '+
'WHERE 1=1 and '+@where+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand+@sqlcommand2)                    
                      
                      
                      
END


GO
