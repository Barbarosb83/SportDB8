USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcLiveGameDataResult]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcLiveGameDataResult] 
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(250),
@MatchDate datetime
AS
BEGIN
SET NOCOUNT ON;

declare @sqlcommand0 nvarchar(max)
declare @sqlcommand nvarchar(max)
declare @sqlcommand1 nvarchar(max)
declare @sqlcommand2 nvarchar(max)
declare @sqlcommand3 nvarchar(max)
declare @sqlcommand33 nvarchar(max)
declare @sqlcommand4 nvarchar(max)
declare @sqlcommand5 nvarchar(max)



set  @sqlcommand0='declare @temptable table (RowNum int,EventId bigint,EventDetailId bigint,MatchDate datetime,Team1Id bigint,Team1 nvarchar(150),Team2Id bigint,Team2 nvarchar(150),StateId int,[State] nvarchar(30),StatuColor int '+
',LossLimit money '+
',LimitPerTicket money,StakeLimit money,AvailabilityId int,MinCombiBranch int,MinCombiInternet int,MinCombiMachine int,SportId int,Icon nvarchar(50),IconColor nvarchar(50),SportName nvarchar(100), '+
'TournamentName nvarchar(100),CategoryName nvarchar(100),[Availability] nvarchar(50),IsPopular bit,CashFlow money,Bets int,totalrow int) '

--declare @total int 

--select @total=COUNT( Archive.[Live.Event].EventId) 
--FROM         Parameter.Tournament INNER JOIN
--                      Language.[Parameter.Tournament] ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
--                      Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId INNER JOIN
--                      Language.[Parameter.Category] ON Parameter.Tournament.CategoryId = Language.[Parameter.Category].CategoryId AND 
--                      Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Category].LanguageId INNER JOIN
--                      Archive.[Live.Event] INNER JOIN
--                     Archive.[Live.EventDetail] ON Archive.[Live.Event].EventId = Archive.[Live.EventDetail].EventId INNER JOIN
--                      Archive.[Live.EventSetting]  ON Archive.[Live.EventDetail].EventId = Archive.[Live.EventSetting].MatchId INNER JOIN
--                      Language.ParameterCompetitor AS ParameterCompetiTip_1 ON Archive.[Live.Event].HomeTeam = ParameterCompetiTip_1.CompetitorId INNER JOIN
--                      Language.ParameterCompetitor ON Archive.[Live.Event].AwayTeam = Language.ParameterCompetitor.CompetitorId AND 
--                      ParameterCompetiTip_1.LanguageId = Language.ParameterCompetitor.LanguageId  ON 
--                      Language.[Parameter.Tournament].LanguageId = ParameterCompetiTip_1.LanguageId AND 
--                      Language.[Parameter.Tournament].LanguageId = Language.ParameterCompetitor.LanguageId AND 
--                      Language.[Parameter.Tournament].TournamentId = Archive.[Live.Event].TournamentId INNER JOIN
--                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
--                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId AND 
--                      Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId INNER JOIN
--                      Language.[Parameter.Sport] ON Parameter.Category.SportId = Language.[Parameter.Sport].SportId AND 
--                      Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN
--                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId  INNER JOIN
--                      Parameter.MatchAvailability ON Archive.[Live.EventSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
--                      Live.[Parameter.TimeStatu] ON Live.[Parameter.TimeStatu].TimeStatuId=Archive.[Live.EventDetail].TimeStatu
--WHERE (Language.ParameterCompetitor.LanguageId = 2) ; 
--WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY  Archive.[Live.Event].EventId) AS RowNum,
-- Archive.[Live.Event].EventId, Archive.[Live.EventDetail].EventDetailId,dbo.UserTimeZoneDate('''+@Username+''', Archive.[Live.Event].EventDate, 0) as MatchDate, ParameterCompetiTip_1.CompetitorId AS Team1Id, 
--                      ParameterCompetiTip_1.CompetitorName AS Team1, Language.ParameterCompetitor.CompetitorId AS Team2Id, 
--                      Language.ParameterCompetitor.CompetitorName AS Team2, Live.[Parameter.TimeStatu].TimeStatuId as StateId, Live.[Parameter.TimeStatu].TimeStatu as State, Live.[Parameter.TimeStatu].StatuColor, 
--                      Archive.[Live.EventSetting].LossLimit,Archive.[Live.EventSetting].LimitPerTicket, Archive.[Live.EventSetting].StakeLimit, Archive.[Live.EventSetting].AvailabilityId, Archive.[Live.EventSetting].MinCombiBranch, 
--                      Archive.[Live.EventSetting].MinCombiInternet, Archive.[Live.EventSetting].MinCombiMachine, Language.[Parameter.Sport].SportId, Parameter.Sport.Icon, Parameter.Sport.IconColor, 
--                      Language.[Parameter.Sport].SportName, Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName, 
--                      Parameter.MatchAvailability.Availability, Archive.[Live.EventSetting].IsPopular,dbo.FuncCashFlow(0, Archive.[Live.Event].EventId, 4, 1) AS CashFlow
--FROM         Parameter.Tournament INNER JOIN
--                      Language.[Parameter.Tournament] ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
--                      Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId INNER JOIN
--                      Language.[Parameter.Category] ON Parameter.Tournament.CategoryId = Language.[Parameter.Category].CategoryId AND 
--                      Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Category].LanguageId INNER JOIN
--                      Archive.[Live.Event] INNER JOIN
--                     Archive.[Live.EventDetail] ON Archive.[Live.Event].EventId = Archive.[Live.EventDetail].EventId INNER JOIN
--                      Archive.[Live.EventSetting]  ON Archive.[Live.EventDetail].EventId = Archive.[Live.EventSetting].MatchId INNER JOIN
--                      Language.ParameterCompetitor AS ParameterCompetiTip_1 ON Archive.[Live.Event].HomeTeam = ParameterCompetiTip_1.CompetitorId INNER JOIN
--                      Language.ParameterCompetitor ON Archive.[Live.Event].AwayTeam = Language.ParameterCompetitor.CompetitorId AND 
--                      ParameterCompetiTip_1.LanguageId = Language.ParameterCompetitor.LanguageId  ON 
--                      Language.[Parameter.Tournament].LanguageId = ParameterCompetiTip_1.LanguageId AND 
--                      Language.[Parameter.Tournament].LanguageId = Language.ParameterCompetitor.LanguageId AND 
--                      Language.[Parameter.Tournament].TournamentId = Archive.[Live.Event].TournamentId INNER JOIN
--                      Parameter.Category ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
--                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId AND 
--                      Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId INNER JOIN
--                      Language.[Parameter.Sport] ON Parameter.Category.SportId = Language.[Parameter.Sport].SportId AND 
--                      Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN
--                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId  INNER JOIN
--                      Parameter.MatchAvailability ON Archive.[Live.EventSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN
--                      Live.[Parameter.TimeStatu] ON Live.[Parameter.TimeStatu].TimeStatuId=Archive.[Live.EventDetail].TimeStatu
--WHERE     (Language.ParameterCompetitor.LanguageId = 2) and Archive.[Live.EventDetail].TimeStatu in (14,5,27,84) 
--)  
--SELECT *,@total as totalrow 
--FROM OrdersRN 
--WHERE RowNum BETWEEN ((@PageNum-1 )*(@PageSize))+1 AND (@PageNum * @PageSize ) 
 if(CHARINDEX('Live.Event.',@where) > 0)
	set @where=REPLACE(@where,'Live.Event.','Archive.[Live.Event].')

set @sqlcommand='declare @total int '+
'select @total=COUNT(Archive.[Live.Event].EventId) '+
'FROM         Parameter.Tournament with (nolock) INNER JOIN '+
                      'Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND  '+
                      'Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId INNER JOIN '+
                      'Language.[Parameter.Category] with (nolock) ON Parameter.Tournament.CategoryId = Language.[Parameter.Category].CategoryId AND  '+
                      'Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Category].LanguageId INNER JOIN '+
                      'Archive.[Live.Event] with (nolock) INNER JOIN '+
                     'Archive.[Live.EventDetail]  with (nolock) ON Archive.[Live.Event].EventId = Archive.[Live.EventDetail].EventId INNER JOIN '+
                     ' Archive.[Live.EventSetting] with (nolock)  ON Archive.[Live.EventDetail].EventId = Archive.[Live.EventSetting].MatchId INNER JOIN '+
                      'Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON Archive.[Live.Event].HomeTeam = ParameterCompetiTip_1.CompetitorId INNER JOIN '+
                      'Language.ParameterCompetitor with (nolock) ON Archive.[Live.Event].AwayTeam = Language.ParameterCompetitor.CompetitorId AND  '+
                      'ParameterCompetiTip_1.LanguageId = Language.ParameterCompetitor.LanguageId  ON  '+
                      'Language.[Parameter.Tournament].LanguageId = ParameterCompetiTip_1.LanguageId AND  '+
                      'Language.[Parameter.Tournament].LanguageId = Language.ParameterCompetitor.LanguageId AND  '+
                      'Language.[Parameter.Tournament].TournamentId = Archive.[Live.Event].TournamentId INNER JOIN '+
                      'Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND  '+
                      'Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId AND  '+
                      'Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId INNER JOIN '+
                      'Language.[Parameter.Sport] with (nolock) ON Parameter.Category.SportId = Language.[Parameter.Sport].SportId AND  '+
                      'Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN '+
                      'Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId  INNER JOIN '+
                      'Parameter.MatchAvailability with (nolock) ON Archive.[Live.EventSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN '+
                      'Live.[Parameter.TimeStatu] with (nolock) ON Live.[Parameter.TimeStatu].TimeStatuId=Archive.[Live.EventDetail].TimeStatu '
set @sqlcommand1='WHERE  (Language.ParameterCompetitor.LanguageId = 2) and (Archive.[Live.EventDetail].TimeStatu in (4,5, 14, 27, 84, 21, 22, 23, 24, 25, 26,1,11,0,86) or Archive.[Live.EventSetting].StateId=1)  and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Archive.[Live.Event].EventId) AS RowNum, '+
'Archive.[Live.Event].EventId, Archive.[Live.EventDetail].EventDetailId,dbo.UserTimeZoneDate('''+@Username+''', Archive.[Live.Event].EventDate, 0) as MatchDate, ParameterCompetiTip_1.CompetitorId AS Team1Id, ' +
                      'ParameterCompetiTip_1.CompetitorName AS Team1, Language.ParameterCompetitor.CompetitorId AS Team2Id, ' +
                      'Language.ParameterCompetitor.CompetitorName AS Team2, Live.[Parameter.TimeStatu].TimeStatuId as StateId, Live.[Parameter.TimeStatu].TimeStatu as State, Live.[Parameter.TimeStatu].StatuColor, ' +
                      'Archive.[Live.EventSetting].LossLimit,Archive.[Live.EventSetting].LimitPerTicket, Archive.[Live.EventSetting].StakeLimit, Archive.[Live.EventSetting].AvailabilityId, Archive.[Live.EventSetting].MinCombiBranch, ' +
                      'Archive.[Live.EventSetting].MinCombiInternet, Archive.[Live.EventSetting].MinCombiMachine, Language.[Parameter.Sport].SportId, Parameter.Sport.Icon, Parameter.Sport.IconColor, ' +
                      'Language.[Parameter.Sport].SportName, Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName, ' +
                      'Parameter.MatchAvailability.Availability, Archive.[Live.EventSetting].IsPopular,dbo.FuncCashFlow(0, Archive.[Live.Event].EventId, 4, 1) AS CashFlow' +

 ' ,(Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd where MatchId=Archive.[Live.Event].EventId) as bet  FROM         Parameter.Tournament with (nolock) INNER JOIN '+
                      'Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND '+
                      'Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId INNER JOIN '+
                      'Language.[Parameter.Category] ON Parameter.Tournament.CategoryId = Language.[Parameter.Category].CategoryId AND '+
                      'Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Category].LanguageId INNER JOIN '+
                      'Archive.[Live.Event] with (nolock) INNER JOIN '+
                     'Archive.[Live.EventDetail] with (nolock) ON Archive.[Live.Event].EventId = Archive.[Live.EventDetail].EventId INNER JOIN '+
                      'Archive.[Live.EventSetting] with (nolock)  ON Archive.[Live.EventDetail].EventId = Archive.[Live.EventSetting].MatchId INNER JOIN '+
                      'Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON Archive.[Live.Event].HomeTeam = ParameterCompetiTip_1.CompetitorId INNER JOIN '+
                      'Language.ParameterCompetitor with (nolock) ON Archive.[Live.Event].AwayTeam = Language.ParameterCompetitor.CompetitorId AND '+
                      'ParameterCompetiTip_1.LanguageId = Language.ParameterCompetitor.LanguageId  ON '+
                      'Language.[Parameter.Tournament].LanguageId = ParameterCompetiTip_1.LanguageId AND '+
                      'Language.[Parameter.Tournament].LanguageId = Language.ParameterCompetitor.LanguageId AND '+
                      'Language.[Parameter.Tournament].TournamentId = Archive.[Live.Event].TournamentId INNER JOIN '
   set @sqlcommand2=                   'Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND  '+
                      'Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId AND '+
                      'Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId INNER JOIN '+
                      'Language.[Parameter.Sport]  with (nolock) ON Parameter.Category.SportId = Language.[Parameter.Sport].SportId AND '+
                      'Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN '+
                      'Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId  INNER JOIN '+
                      'Parameter.MatchAvailability with (nolock) ON Archive.[Live.EventSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN '+
                      'Live.[Parameter.TimeStatu] with (nolock) ON Live.[Parameter.TimeStatu].TimeStatuId=Archive.[Live.EventDetail].TimeStatu  '+
'WHERE  (Language.ParameterCompetitor.LanguageId = 2) and (Archive.[Live.EventDetail].TimeStatu in (4,5, 14, 27, 84, 21, 22, 23, 24, 25, 26,1,11,0,86) or Archive.[Live.EventSetting].StateId=1) and '+@where+
 ') '+  
' insert @temptable SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '



 if(CHARINDEX('Archive.[Live.Event]',@where) > 0)
	set @where=REPLACE(@where,'Archive.[Live.Event]','Live.[Event]')


set @sqlcommand3='select @total=COUNT(Live.[Event].EventId) '+
'FROM         Parameter.Tournament with (nolock) INNER JOIN '+
                      'Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND '+
                      'Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId INNER JOIN '+
                      'Language.[Parameter.Category] with (nolock) ON Parameter.Tournament.CategoryId = Language.[Parameter.Category].CategoryId AND '+
                      'Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Category].LanguageId INNER JOIN '+
                      'Live.[Event] with (nolock) INNER JOIN '+
                     'Live.[EventDetail] with (nolock) ON Live.[Event].EventId = Live.[EventDetail].EventId INNER JOIN '+
                      'Live.[EventSetting] with (nolock)  ON Live.[EventDetail].EventId = Live.[EventSetting].MatchId INNER JOIN '+
                      'Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON Live.[Event].HomeTeam = ParameterCompetiTip_1.CompetitorId INNER JOIN '+
                      'Language.ParameterCompetitor with (nolock) ON Live.[Event].AwayTeam = Language.ParameterCompetitor.CompetitorId AND '+
                      'ParameterCompetiTip_1.LanguageId = Language.ParameterCompetitor.LanguageId  ON '+
                      'Language.[Parameter.Tournament].LanguageId = ParameterCompetiTip_1.LanguageId AND '+
                      'Language.[Parameter.Tournament].LanguageId = Language.ParameterCompetitor.LanguageId AND '+
                      'Language.[Parameter.Tournament].TournamentId = Live.[Event].TournamentId INNER JOIN '+
                      'Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND '+
                      'Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId AND '+
                      'Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId INNER JOIN '+
                      'Language.[Parameter.Sport] with (nolock) ON Parameter.Category.SportId = Language.[Parameter.Sport].SportId AND '+
                      'Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN '+
                      'Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId  INNER JOIN '+
                      'Parameter.MatchAvailability with (nolock) ON Live.[EventSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN '+
                      'Live.[Parameter.TimeStatu] with (nolock) ON Live.[Parameter.TimeStatu].TimeStatuId=Live.[EventDetail].TimeStatu '
set @sqlcommand33='WHERE  (Language.ParameterCompetitor.LanguageId = 2) and (Live.[EventDetail].TimeStatu in (5, 14, 27, 84, 21, 22, 23, 24, 25, 26) or Live.EventSetting.StateId=1)  and '+@where +' ; ' +
'WITH OrdersRN AS ( SELECT ROW_NUMBER() OVER(ORDER BY Live.[Event].EventId desc) AS RowNum, '+
'Live.[Event].EventId, Live.[EventDetail].EventDetailId,dbo.UserTimeZoneDate('''+@Username+''', Live.[Event].EventDate, 0) as MatchDate, ParameterCompetiTip_1.CompetitorId AS Team1Id, 
                      ParameterCompetiTip_1.CompetitorName AS Team1, Language.ParameterCompetitor.CompetitorId AS Team2Id, 
                      Language.ParameterCompetitor.CompetitorName AS Team2, Live.[Parameter.TimeStatu].TimeStatuId as StateId, Live.[Parameter.TimeStatu].TimeStatu as State, Live.[Parameter.TimeStatu].StatuColor, 
                      Live.[EventSetting].LossLimit,Live.[EventSetting].LimitPerTicket, Live.[EventSetting].StakeLimit, Live.[EventSetting].AvailabilityId, Live.[EventSetting].MinCombiBranch, 
                      Live.[EventSetting].MinCombiInternet, Live.[EventSetting].MinCombiMachine, Language.[Parameter.Sport].SportId, Parameter.Sport.Icon, Parameter.Sport.IconColor, 
                      Language.[Parameter.Sport].SportName, Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName, 
                      Parameter.MatchAvailability.Availability, Live.[EventSetting].IsPopular,dbo.FuncCashFlow(0, Live.[Event].EventId, 4, 1) AS CashFlow,(Select Count(Customer.SlipOdd.SlipId) from Customer.SlipOdd where MatchId=Live.[Event].EventId) as bet '+

 'FROM         Parameter.Tournament with (nolock) INNER JOIN '+
                      'Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND '+ 
                      'Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId INNER JOIN '+
                      'Language.[Parameter.Category] ON Parameter.Tournament.CategoryId = Language.[Parameter.Category].CategoryId AND  '+
                      'Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Category].LanguageId INNER JOIN '+
                      'Live.[Event] with (nolock) INNER JOIN '+
                      'Live.[EventDetail] with (nolock) ON Live.[Event].EventId = Live.[EventDetail].EventId INNER JOIN '+
                      'Live.[EventSetting] with (nolock)  ON Live.[EventDetail].EventId = Live.[EventSetting].MatchId INNER JOIN '
    set @sqlcommand4=                  'Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON Live.[Event].HomeTeam = ParameterCompetiTip_1.CompetitorId INNER JOIN '+
                      'Language.ParameterCompetitor with (nolock) ON Live.[Event].AwayTeam = Language.ParameterCompetitor.CompetitorId AND  '+
                      'ParameterCompetiTip_1.LanguageId = Language.ParameterCompetitor.LanguageId  ON  '+
                      'Language.[Parameter.Tournament].LanguageId = ParameterCompetiTip_1.LanguageId AND  '+
                      'Language.[Parameter.Tournament].LanguageId = Language.ParameterCompetitor.LanguageId AND '+ 
                      'Language.[Parameter.Tournament].TournamentId = Live.[Event].TournamentId INNER JOIN '+
                      'Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND '+ 
                      'Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId AND '+
                      'Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId INNER JOIN '+
                      'Language.[Parameter.Sport] ON Parameter.Category.SportId = Language.[Parameter.Sport].SportId AND  '+
                      'Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN '+
                      'Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId  INNER JOIN '+
                      'Parameter.MatchAvailability with (nolock) ON Live.[EventSetting].AvailabilityId = Parameter.MatchAvailability.AvailabilityId INNER JOIN '+
                      'Live.[Parameter.TimeStatu] with (nolock) ON Live.[Parameter.TimeStatu].TimeStatuId=Live.[EventDetail].TimeStatu '+
'WHERE  (Language.ParameterCompetitor.LanguageId = 2) and (Live.[EventDetail].TimeStatu in (5, 14, 27, 84, 21, 22, 23, 24, 25, 26) or Live.EventSetting.StateId=1)  and '+@where+
 ') '+  
' insert @temptable  SELECT *,@total as totalrow '+
  'FROM OrdersRN '+
 ' WHERE RowNum BETWEEN (('+cast(@PageNum-1 as nvarchar(5))+')*('+cast(@PageSize  as nvarchar(5))+'))+1 AND ('+cast(@PageNum * @PageSize as nvarchar(10))+' ) '


 set @sqlcommand5=' select * from @temptable ' -- order by '+@orderby

exec (@sqlcommand0+@sqlcommand+@sqlcommand1+@sqlcommand2+@sqlcommand3+@sqlcommand33+@sqlcommand4+@sqlcommand5)
END



GO
