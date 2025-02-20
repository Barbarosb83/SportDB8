USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataResult]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameDataResult] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(200)
AS
BEGIN
SET NOCOUNT ON;


declare @sqlcommand0 nvarchar(max)=' declare @TempTable table (RowNum bigint,MatchId bigint not null,FixtureId int not null,MatchDate datetime,Team1Id bigint not null,Team1 nvarchar(250),Team2Id bigint not null,Team2 nvarchar(250),TournamentId int not null
,StateId int,State nvarchar(50),StatuColor int,LossLimit money,LimitPerTicket money,StakeLimit money,AvailabilityId int,Availability nvarchar(50),MinCombiBranch int,MinCombiInternet int,MinCombiMachine int
,Icon nvarchar(50),IconColor nvarchar(50),SportName nvarchar(50),TournamentName nvarchar(250),CashFlow money,IsPopular bit,CategoryName nvarchar(150),bet int,totalrow int)'
declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)
declare @sqlcommand3 nvarchar(max)
declare @sqlcommand4 nvarchar(max)

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
'  insert @TempTable SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' )  '


 set @where=REPLACE(@where,'Archive','Match')
 set @orderby=REPLACE(@orderby,'Archive','Match')


 set @sqlcommand3='select @total+= COUNT([Match].Match.MatchId) '+
'FROM         Parameter.Competitor with (nolock) INNER JOIN
                      [Match].FixtureCompetitor AS FixtureCompetiTip_1 with (nolock) ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
                      [Match].Match with (nolock) INNER JOIN
                      [Match].Fixture with (nolock) ON [Match].Match.MatchId = [Match].Fixture.MatchId INNER JOIN
                      [Match].FixtureDateInfo with (nolock) ON [Match].Fixture.FixtureId = [Match].FixtureDateInfo.FixtureId AND [Match].Fixture.FixtureId = [Match].FixtureDateInfo.FixtureId ON 
                      FixtureCompetiTip_1.FixtureId = [Match].Fixture.FixtureId INNER JOIN
                      Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN
                      [Match].FixtureCompetitor with (nolock) ON CompetiTip_1.CompetitorId = [Match].FixtureCompetitor.CompetitorId ON 
                      [Match].Fixture.FixtureId = [Match].FixtureCompetitor.FixtureId INNER JOIN
                      [Match].Setting with (nolock) ON [Match].Match.MatchId = [Match].Setting.MatchId INNER JOIN
                      Parameter.MatchState with (nolock) ON [Match].Setting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON [Match].Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.Tournament with (nolock) ON [Match].Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                      Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId '+
'WHERE (FixtureCompetiTip_1.TypeId = 1) AND ([Match].FixtureCompetitor.TypeId = 2) AND ([Match].FixtureDateInfo.LanguageId = 1) and Match.FixtureDateInfo.MatchDate<GETDATE() and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY '+@orderby+') AS RowNum, '+
'[Match].Match.MatchId,[Match].Fixture.FixtureId,dbo.UserTimeZoneDate('''+@Username+''',[Match].FixtureDateInfo.MatchDate,0) as MatchDate,Parameter.Competitor.CompetitorId AS Team1Id, '+
'Parameter.Competitor.CompetitorName AS Team1,CompetiTip_1.CompetitorId AS Team2Id,CompetiTip_1.CompetitorName AS Team2,[Match].Match.TournamentId, '+
'[Match].Setting.StateId,Parameter.MatchState.State,Parameter.MatchState.StatuColor,[Match].Setting.LossLimit,[Match].Setting.LimitPerTicket,[Match].Setting.StakeLimit,[Match].Setting.AvailabilityId, '+
'Parameter.MatchAvailability.Availability,[Match].Setting.MinCombiBranch,[Match].Setting.MinCombiInternet,[Match].Setting.MinCombiMachine,Parameter.Sport.Icon,Parameter.Sport.IconColor, Parameter.Sport.SportName,Parameter.Tournament.TournamentName,cast(0 as money) as CashFlow,[Match].Setting.IsPopular,Parameter.Category.CategoryName,(Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd with (nolock) where MatchId=[Match].Match.MatchId) as bet '

set @sqlcommand4= 'FROM Parameter.Competitor with (nolock) INNER JOIN
                      [Match].FixtureCompetitor AS FixtureCompetiTip_1 with (nolock) ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN
                      [Match].Match with (nolock) INNER JOIN
                      [Match].Fixture with (nolock) ON [Match].Match.MatchId = [Match].Fixture.MatchId INNER JOIN
                      [Match].FixtureDateInfo with (nolock) ON [Match].Fixture.FixtureId = [Match].FixtureDateInfo.FixtureId AND [Match].Fixture.FixtureId = [Match].FixtureDateInfo.FixtureId ON 
                      FixtureCompetiTip_1.FixtureId = [Match].Fixture.FixtureId INNER JOIN
                      Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN
                      [Match].FixtureCompetitor with (nolock) ON CompetiTip_1.CompetitorId = [Match].FixtureCompetitor.CompetitorId ON 
                      [Match].Fixture.FixtureId = [Match].FixtureCompetitor.FixtureId INNER JOIN
                      [Match].Setting with (nolock) ON [Match].Match.MatchId = [Match].Setting.MatchId INNER JOIN
                      Parameter.MatchState with (nolock) ON [Match].Setting.StateId = Parameter.MatchState.StateId INNER JOIN
                      Parameter.MatchAvailability with (nolock) ON [Match].Setting.AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
                      Parameter.Tournament with (nolock) ON [Match].Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                      Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId '+
'WHERE (FixtureCompetiTip_1.TypeId = 1) AND ([Match].FixtureCompetitor.TypeId = 2) AND ([Match].FixtureDateInfo.LanguageId = 1) and Match.FixtureDateInfo.MatchDate<GETDATE() and '+@where+
 ') '+  
'  insert @TempTable SELECT RowNum+(select ISNULL(Count(RowNum),0) from @TempTable) ,MatchId ,FixtureId ,MatchDate ,Team1Id ,Team1 ,Team2Id ,Team2 ,TournamentId,StateId ,State ,StatuColor ,LossLimit ,LimitPerTicket ,StakeLimit ,AvailabilityId ,Availability ,MinCombiBranch ,MinCombiInternet ,MinCombiMachine ,Icon ,IconColor ,SportName ,TournamentName ,CashFlow ,IsPopular ,CategoryName ,bet ,@total  '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' )  select * from @TempTable WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' )'
  
execute (@sqlcommand0+@sqlcommand+@sqlcommand2+@sqlcommand3+@sqlcommand4)
END


GO
