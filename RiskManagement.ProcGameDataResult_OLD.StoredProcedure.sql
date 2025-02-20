USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataResult_OLD]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameDataResult_OLD] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(200)
AS

BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)

--declare @total int 

--select @total=COUNT([Archive].Match.MatchId) 
--FROM         Parameter.Competitor INNER JOIN
--                      [Archive].FixtureCompetitor AS FixtureCompetiTip_1 ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
--                      [Archive].Match INNER JOIN
--                      [Archive].Fixture ON [Archive].Match.MatchId = [Archive].Fixture.MatchId INNER JOIN
--                      [Archive].FixtureDateInfo ON [Archive].Fixture.FixtureId = [Archive].FixtureDateInfo.FixtureId AND [Archive].Fixture.FixtureId = [Archive].FixtureDateInfo.FixtureId ON 
--                      FixtureCompetiTip_1.FixtureId = [Archive].Fixture.FixtureId INNER JOIN
--                      Parameter.Competitor AS CompetiTip_1 INNER JOIN
--                      [Archive].FixtureCompetitor ON CompetiTip_1.CompetitorId = [Archive].FixtureCompetitor.CompetitorId ON 
--                      [Archive].Fixture.FixtureId = [Archive].FixtureCompetitor.FixtureId INNER JOIN
--                      [Archive].Setting ON [Archive].Match.MatchId = [Archive].Setting.MatchId INNER JOIN
--                      Parameter.MatchState ON [Archive].Setting.StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON [Archive].Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
--                      Parameter.Tournament ON [Archive].Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
--                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
--                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
--                      Language.[Parameter.Sport] ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId INNER JOIN
--                      Language.[Parameter.Tournament] ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
--                      [Archive].FixtureDateInfo.LanguageId = Language.[Parameter.Tournament].LanguageId AND 
--                      Language.[Parameter.Sport].LanguageId = Language.[Parameter.Tournament].LanguageId 
--WHERE (FixtureCompetiTip_1.TypeId = 1) AND ([Archive].FixtureCompetitor.TypeId = 2) AND ([Archive].FixtureDateInfo.LanguageId = 1) ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY [Archive].Match.MatchId) AS RowNum,
-- [Archive].Match.MatchId,[Archive].Fixture.FixtureId,[Archive].FixtureDateInfo.MatchDate,Parameter.Competitor.CompetitorId AS Team1Id, 
--Parameter.Competitor.CompetitorName AS Team1,CompetiTip_1.CompetitorId AS Team2Id,CompetiTip_1.CompetitorName AS Team2,[Archive].Match.TournamentId, 
--[Archive].Setting.StateId,Parameter.MatchState.State,Parameter.MatchState.StatuColor,[Archive].Setting.LossLimit,[Archive].Setting.LimitPerTicket,[Archive].Setting.StakeLimit,[Archive].Setting.AvailabilityId, 
--Parameter.MatchAvailability.Availability,[Archive].Setting.MinCombiBranch,[Archive].Setting.MinCombiInternet,[Archive].Setting.MinCombiMachine,Parameter.Sport.Icon,Parameter.Sport.IconColor, Language.[Parameter.Sport].SportName,Language.[Parameter.Tournament].TournamentName,dbo.FuncCashFlow(0,[Archive].Setting.MatchId,2,0) as CashFlow,[Archive].Setting.IsPopular,Parameter.Category.CategoryName
--FROM         Parameter.Competitor INNER JOIN
--                      [Archive].FixtureCompetitor AS FixtureCompetiTip_1 ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
--                      [Archive].Match INNER JOIN
--                      [Archive].Fixture ON [Archive].Match.MatchId = [Archive].Fixture.MatchId INNER JOIN
--                      [Archive].FixtureDateInfo ON [Archive].Fixture.FixtureId = [Archive].FixtureDateInfo.FixtureId AND [Archive].Fixture.FixtureId = [Archive].FixtureDateInfo.FixtureId ON 
--                      FixtureCompetiTip_1.FixtureId = [Archive].Fixture.FixtureId INNER JOIN
--                      Parameter.Competitor AS CompetiTip_1 INNER JOIN
--                      [Archive].FixtureCompetitor ON CompetiTip_1.CompetitorId = [Archive].FixtureCompetitor.CompetitorId ON 
--                      [Archive].Fixture.FixtureId = [Archive].FixtureCompetitor.FixtureId INNER JOIN
--                      [Archive].Setting ON [Archive].Match.MatchId = [Archive].Setting.MatchId INNER JOIN
--                      Parameter.MatchState ON [Archive].Setting.StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON [Archive].Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
--                      Parameter.Tournament ON [Archive].Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
--                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
--                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
--                      Language.[Parameter.Sport] ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId INNER JOIN
--                      Language.[Parameter.Tournament] ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
--                      [Archive].FixtureDateInfo.LanguageId = Language.[Parameter.Tournament].LanguageId AND 
--                      Language.[Parameter.Sport].LanguageId = Language.[Parameter.Tournament].LanguageId
--WHERE (FixtureCompetiTip_1.TypeId = 1) AND ([Archive].FixtureCompetitor.TypeId = 2) AND ([Archive].FixtureDateInfo.LanguageId = 1)
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 

--dbo.FuncCashFlow(0,[Archive].Setting.MatchId,4,0)



set @sqlcommand='declare @total int '+
'select @total=COUNT([Archive].Match.MatchId) '+
'FROM         Parameter.Competitor with (nolock) INNER JOIN
                      [Archive].FixtureCompetitor AS FixtureCompetiTip_1 with (nolock) ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
                      [Archive].Match with (nolock) INNER JOIN
                      [Archive].Fixture with (nolock) ON [Archive].Match.MatchId = [Archive].Fixture.MatchId INNER JOIN
                      [Archive].FixtureDateInfo with (nolock) ON [Archive].Fixture.FixtureId = [Archive].FixtureDateInfo.FixtureId AND [Archive].Fixture.FixtureId = [Archive].FixtureDateInfo.FixtureId ON 
                      FixtureCompetiTip_1.FixtureId = [Archive].Fixture.FixtureId INNER JOIN
                      Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN
                      [Archive].FixtureCompetitor with (nolock) ON CompetiTip_1.CompetitorId = [Archive].FixtureCompetitor.CompetitorId ON 
                      [Archive].Fixture.FixtureId = [Archive].FixtureCompetitor.FixtureId INNER JOIN
                      [Archive].Setting with (nolock) ON [Archive].Match.MatchId = [Archive].Setting.MatchId INNER JOIN
                      Parameter.MatchState with (nolock) ON [Archive].Setting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON [Archive].Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.Tournament with (nolock) ON [Archive].Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                      Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId '+
'WHERE (FixtureCompetiTip_1.TypeId = 1) AND ([Archive].FixtureCompetitor.TypeId = 2) AND ([Archive].FixtureDateInfo.LanguageId = 1) and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'[Archive].Match.MatchId,[Archive].Fixture.FixtureId,dbo.UserTimeZoneDate('''+@Username+''',[Archive].FixtureDateInfo.MatchDate,0) as MatchDate,Parameter.Competitor.CompetitorId AS Team1Id, '+
'Parameter.Competitor.CompetitorName AS Team1,CompetiTip_1.CompetitorId AS Team2Id,CompetiTip_1.CompetitorName AS Team2,[Archive].Match.TournamentId, '+
'[Archive].Setting.StateId,Parameter.MatchState.State,Parameter.MatchState.StatuColor,[Archive].Setting.LossLimit,[Archive].Setting.LimitPerTicket,[Archive].Setting.StakeLimit,[Archive].Setting.AvailabilityId, '+
'Parameter.MatchAvailability.Availability,[Archive].Setting.MinCombiBranch,[Archive].Setting.MinCombiInternet,[Archive].Setting.MinCombiMachine,Parameter.Sport.Icon,Parameter.Sport.IconColor, Parameter.Sport.SportName,Parameter.Tournament.TournamentName,cast(0 as money) as CashFlow,[Archive].Setting.IsPopular,Parameter.Category.CategoryName,(Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where MatchId=Archive.Match.MatchId) as bet '

set @sqlcommand2= 'FROM Parameter.Competitor with (nolock) INNER JOIN
                      [Archive].FixtureCompetitor AS FixtureCompetiTip_1 with (nolock) ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
                      [Archive].Match with (nolock) INNER JOIN
                      [Archive].Fixture with (nolock) ON [Archive].Match.MatchId = [Archive].Fixture.MatchId INNER JOIN
                      [Archive].FixtureDateInfo with (nolock) ON [Archive].Fixture.FixtureId = [Archive].FixtureDateInfo.FixtureId AND [Archive].Fixture.FixtureId = [Archive].FixtureDateInfo.FixtureId ON 
                      FixtureCompetiTip_1.FixtureId = [Archive].Fixture.FixtureId INNER JOIN
                      Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN
                      [Archive].FixtureCompetitor with (nolock) ON CompetiTip_1.CompetitorId = [Archive].FixtureCompetitor.CompetitorId ON 
                      [Archive].Fixture.FixtureId = [Archive].FixtureCompetitor.FixtureId INNER JOIN
                      [Archive].Setting with (nolock) ON [Archive].Match.MatchId = [Archive].Setting.MatchId INNER JOIN
                      Parameter.MatchState with (nolock) ON [Archive].Setting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON [Archive].Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.Tournament with (nolock) ON [Archive].Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                      Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId '+
'WHERE (FixtureCompetiTip_1.TypeId = 1) AND ([Archive].FixtureCompetitor.TypeId = 2) AND ([Archive].FixtureDateInfo.LanguageId = 1) and '+@where+
 ') '+  
'SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand+@sqlcommand2)
END


GO
