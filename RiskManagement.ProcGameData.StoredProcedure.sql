USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameData]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameData] 
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
declare @sqlcommand3 nvarchar(max)



  insert dbo.betslip values (@PageNum,@where,GETDATE())

 -----  select * from dbo.betslip order by CreateDate desc

--declare @total int 

--select @total=COUNT(Match.Match.MatchId) 
--FROM         Parameter.Competitor INNER JOIN
--                      Match.FixtureCompetitor AS FixtureCompetiTip_1 ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
--                      Match.Match INNER JOIN
--                      Match.Fixture ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN
--                      Match.FixtureDateInfo ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId AND Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId ON 
--                      FixtureCompetiTip_1.FixtureId = Match.Fixture.FixtureId INNER JOIN
--                      Parameter.Competitor AS CompetiTip_1 INNER JOIN
--                      Match.FixtureCompetitor ON CompetiTip_1.CompetitorId = Match.FixtureCompetitor.CompetitorId ON 
--                      Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId INNER JOIN
--                      Match.Setting ON Match.Match.MatchId = Match.Setting.MatchId INNER JOIN
--                      Parameter.MatchState ON Match.Setting.StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON Match.Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
--                      Parameter.Tournament ON Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
--                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
--                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
--                      Language.[Parameter.Sport] ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId INNER JOIN
--                      Language.[Parameter.Tournament] ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
--                      Match.FixtureDateInfo.LanguageId = Language.[Parameter.Tournament].LanguageId AND 
--                      Language.[Parameter.Sport].LanguageId = Language.[Parameter.Tournament].LanguageId 
--WHERE (FixtureCompetiTip_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) AND (Match.FixtureDateInfo.LanguageId = 1) ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Match.MatchId) AS RowNum,
-- Match.Match.MatchId,Match.Fixture.FixtureId,Match.FixtureDateInfo.MatchDate,Parameter.Competitor.CompetitorId AS Team1Id, 
--Parameter.Competitor.CompetitorName AS Team1,CompetiTip_1.CompetitorId AS Team2Id,CompetiTip_1.CompetitorName AS Team2,Match.Match.TournamentId, 
--Match.Setting.StateId,Parameter.MatchState.State,Parameter.MatchState.StatuColor,Match.Setting.LossLimit,Match.Setting.LimitPerTicket,Match.Setting.StakeLimit,Match.Setting.AvailabilityId, 
--Parameter.MatchAvailability.Availability,Match.Setting.MinCombiBranch,Match.Setting.MinCombiInternet,Match.Setting.MinCombiMachine,Parameter.Sport.Icon,Parameter.Sport.IconColor, Language.[Parameter.Sport].SportName,Language.[Parameter.Tournament].TournamentName,dbo.FuncCashFlow(0,Match.Setting.MatchId,2,0) as CashFlow,Match.Setting.IsPopular,Parameter.Category.CategoryName,Match.Fixture.NeutralGround,Match.Match.BetradarMatchId,Match.Match.MonitoringMatchId
--FROM         Parameter.Competitor INNER JOIN
--                      Match.FixtureCompetitor AS FixtureCompetiTip_1 ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
--                      Match.Match INNER JOIN
--                      Match.Fixture ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN
--                      Match.FixtureDateInfo ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId AND Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId ON 
--                      FixtureCompetiTip_1.FixtureId = Match.Fixture.FixtureId INNER JOIN
--                      Parameter.Competitor AS CompetiTip_1 INNER JOIN
--                      Match.FixtureCompetitor ON CompetiTip_1.CompetitorId = Match.FixtureCompetitor.CompetitorId ON 
--                      Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId INNER JOIN
--                      Match.Setting ON Match.Match.MatchId = Match.Setting.MatchId INNER JOIN
--                      Parameter.MatchState ON Match.Setting.StateId = Parameter.MatchState.StateId INNER JOIN
--                      Parameter.MatchAvailability ON Match.Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
--                      Parameter.Tournament ON Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
--                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
--                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
--                      Language.[Parameter.Sport] ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId INNER JOIN
--                      Language.[Parameter.Tournament] ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
--                      Match.FixtureDateInfo.LanguageId = Language.[Parameter.Tournament].LanguageId AND 
--                      Language.[Parameter.Sport].LanguageId = Language.[Parameter.Tournament].LanguageId
--WHERE (FixtureCompetiTip_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) AND (Match.FixtureDateInfo.LanguageId = 1)
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 

--dbo.FuncCashFlow(0,Match.Setting.MatchId,4,0)



set @sqlcommand='declare @total int '+
'select @total=COUNT(Match.Match.MatchId) '+
'FROM Parameter.Competitor INNER JOIN ' +
                      ' Match.FixtureCompetitor AS FixtureCompetiTip_1 with (nolock) ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN ' +
                      ' Match.Match with (nolock) INNER JOIN ' +
                      ' Match.Fixture with (nolock) ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN ' +
                      ' Match.FixtureDateInfo with (nolock) ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId AND Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId ON  ' +
                      ' FixtureCompetiTip_1.FixtureId = Match.Fixture.FixtureId INNER JOIN ' +
                      ' Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN ' +
                      ' Match.FixtureCompetitor with (nolock) ON CompetiTip_1.CompetitorId = Match.FixtureCompetitor.CompetitorId ON  ' +
                      ' Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId INNER JOIN ' +
                      ' Match.Setting with (nolock) ON Match.Match.MatchId = Match.Setting.MatchId INNER JOIN ' +
                      ' [Language].[Parameter.MatchState] with (nolock) ON Match.Setting.StateId = [Language].[Parameter.MatchState].[MatchStateId] INNER JOIN ' +
					  ' Parameter.MatchState with (nolock) ON Parameter.MatchState.StateId=Match.Setting.StateId INNER JOIN ' +
                      ' Parameter.MatchAvailability with (nolock) ON Match.Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN ' +
					  ' Parameter.Tournament with (nolock) ON Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN ' +
                      ' Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN ' +
					  ' Language.[Parameter.Category] with (nolock) ON Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId INNER JOIN ' +
                      ' Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN ' +
                      ' Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId INNER JOIN ' +
                      ' Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND  ' +
                      '  Language.[Parameter.Tournament].LanguageId=Language.[Parameter.Sport].LanguageId  AND Language.[Parameter.Category].LanguageId= Language.[Parameter.Sport].LanguageId AND [Language].[Parameter.MatchState].LanguageId=Language.[Parameter.Sport].LanguageId '+
'WHERE (FixtureCompetiTip_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) 
 and '+@where+' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
' Match.Match.MatchId,Match.Fixture.FixtureId,dbo.UserTimeZoneDate('''+@Username+''',Match.FixtureDateInfo.MatchDate,0) as MatchDate,Parameter.Competitor.CompetitorId AS Team1Id, '


set @sqlcommand2= 'Parameter.Competitor.CompetitorName AS Team1,CompetiTip_1.CompetitorId AS Team2Id,CompetiTip_1.CompetitorName AS Team2,Match.Match.TournamentId, '+
'Match.Setting.StateId,[Language].[Parameter.MatchState].[MatchState] as State,Parameter.MatchState.StatuColor,Match.Setting.LossLimit,Match.Setting.LimitPerTicket,Match.Setting.StakeLimit,Match.Setting.AvailabilityId,' +
'Parameter.MatchAvailability.Availability,Match.Setting.MinCombiBranch,Match.Setting.MinCombiInternet,Match.Setting.MinCombiMachine,Parameter.Sport.Icon,Parameter.Sport.IconColor, Language.[Parameter.Sport].SportName,Language.[Parameter.Tournament].TournamentName,cast((Select SUM(Amount) from Customer.slip with (nolock) where Customer.slip.SlipId in ((Select SlipId from Customer.SlipOdd with (nolock) where BetradarMatchId=Match.Match.BetradarMatchId and BetTypeId=0 )) and SlipStateId=1) as money) as CashFlow,Match.Setting.IsPopular,Language.[Parameter.Category].CategoryName,Match.Fixture.NeutralGround,Match.Match.BetradarMatchId,Match.Match.MonitoringMatchId,(Select COUNT(DISTINCT SlipId) from Customer.SlipOdd with (nolock) where BetradarMatchId=Match.Match.BetradarMatchId) as bet  '+
'FROM Parameter.Competitor INNER JOIN ' +
                      ' Match.FixtureCompetitor AS FixtureCompetiTip_1 with (nolock) ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN ' +
                      ' Match.Match with (nolock) INNER JOIN ' +
                      ' Match.Fixture with (nolock) ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN ' +
                      ' Match.FixtureDateInfo with (nolock) ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId AND Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId ON  ' +
                      ' FixtureCompetiTip_1.FixtureId = Match.Fixture.FixtureId INNER JOIN ' +
                      ' Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN ' +
                      ' Match.FixtureCompetitor with (nolock) ON CompetiTip_1.CompetitorId = Match.FixtureCompetitor.CompetitorId ON  ' +
                      ' Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId INNER JOIN ' +
                      ' Match.Setting with (nolock) ON Match.Match.MatchId = Match.Setting.MatchId INNER JOIN ' +
                      ' [Language].[Parameter.MatchState] with (nolock) ON Match.Setting.StateId = [Language].[Parameter.MatchState].[MatchStateId] INNER JOIN ' +
					  ' Parameter.MatchState with (nolock) ON Parameter.MatchState.StateId=Match.Setting.StateId INNER JOIN ' +
                      ' Parameter.MatchAvailability with (nolock) ON Match.Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN ' +
					  ' Parameter.Tournament with (nolock) ON Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN ' +
                      ' Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN '
set @sqlcommand3=' Language.[Parameter.Category] with (nolock) ON Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId INNER JOIN ' +
                      ' Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN ' +
                      ' Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId INNER JOIN ' +
                      ' Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND  ' +
                      '  Language.[Parameter.Tournament].LanguageId=Language.[Parameter.Sport].LanguageId  AND Language.[Parameter.Category].LanguageId= Language.[Parameter.Sport].LanguageId AND [Language].[Parameter.MatchState].LanguageId=Language.[Parameter.Sport].LanguageId '+
'WHERE (FixtureCompetiTip_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) 
and '+@where+
') '+  
'SELECT DISTINCT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


execute (@sqlcommand+@sqlcommand2+@sqlcommand3)
END



GO
