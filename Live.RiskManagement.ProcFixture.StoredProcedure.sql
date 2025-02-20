USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcFixture]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Live].[RiskManagement.ProcFixture]
	@BeginDate datetime,
	@EndDate datetime,
	@LangId int,
	@UserName nvarchar(50),
	@Where nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
declare @sqlcommand nvarchar(max)=''
declare @sqlcommand2 nvarchar(max)=''
if(@Where='Language.ParameterCompetitor.CompetitorName')
	set @Where=REPLACE(@Where,'Language.ParameterCompetitor.CompetitorName','LPC.CompetitorName')
	 
	set @Where=REPLACE(@Where,'Parameter.Competitor.CompetitorName','LPC.CompetitorName')


	set @Where=REPLACE(@Where,'Live.EventDetail.BetradarMatchId','Live.EventDetail.BetradarMatchIds')

	if(@Where='ParameterCompetitor_1.CompetitorName')
	set @Where=REPLACE(@Where,'ParameterCompetitor_1.CompetitorName','Competitor_1.CompetitorName') 
    
 
 set @sqlcommand= '   SELECT     Live.EventDetail.EventId, Live.EventDetail.BetStatus, '+
			' Live.[Parameter.BetStatu].BetStatu, '+
			' Live.[Parameter.BetStatu].StatuColor as BetStatuColor, '+
			' Live.[Parameter.TimeStatu].TimeStatu, '+
			' Live.[Parameter.TimeStatu].StatuColor as TimeStatuColor, '+
			' Parameter.MatchState.State as EventStatu, '+
			' Parameter.MatchState.StateId as EventStatuId, '+
			' Parameter.MatchState.StatuColor as EventStatuColor, '+
			'cast(LPC.CompetitorId as nvarchar(20))+'' - ''+ LPC.CompetitorName as HomeTeam,  '+
			'cast(Competitor_1.CompetitorId as nvarchar(20))+'' - ''+ Competitor_1.CompetitorName AS AwayTeam, '+
			' isnull(Live.EventDetail.Score,''-'') as Score, '+
			' Live.[Event].EventDate as EventDate, '+
			'  ISNULL((Select COUNT(*) from Customer.SlipOdd with (nolock) where MatchId=Live.EventDetail.EventId),0) as Bets, '+
			'  ISNULL(cast((Select SUM(CS.Amount) from Customer.slip CS with (nolock) INNER JOIN Customer.SlipOdd CSO with (nolock) ON CS.SlipId=CSO.SlipId and CSO.BetradarMatchId=Live.Event.EventId and CS.SlipTypeId<3 and CSO.BetTypeId=1 and CS.SlipStateId=1) as money),0)+ISNULL(cast((Select SUM(CS.Amount) from Customer.SlipSystem CS with (nolock) INNER JOIN Customer.SlipSystemSlip CSS with (nolock) On CSS.SystemSlipId=CS.SystemSlipId  INNER JOIN Customer.SlipOdd CSO with (nolock) ON CSS.SlipId=CSO.SlipId and CSO.BetradarMatchId=Live.Event.EventId and CSO.BetTypeId=1 where CS.SlipStateId=1 ) as money),0) as Stakes, '+
			' cast(0 as money) as Losses, '+
			' cast(0 as money) as Won, '+
			' cast(0 as int) as OpenOdds, '+
			' cast(0 as int) as CloseOdds, '+
			' cast(0 as int) as CancelOdds, '+
			' case when Oddlock=1 then cast(1 as int) else cast(0 as int) end as CompleteOdds, '+
			' '''' as Manager, '+
			' case when Msgnr is null or Msgnr=0 then 0 else 1 end as ManagerId, '+
		' Live.[Parameter.ConnectionStatu].ConnectionStatu, '+
		' Live.[Parameter.ConnectionStatu].StatuColor as ConnectionStatuColor, '+
		' Live.[Parameter.FeedStatu].FeedStatu, '+
		' Live.[Parameter.FeedStatu].StatuColor as FeedStatuColor, [Language].[Parameter.Sport].[SportName],case when Live.Event.BetradarMatchId>0 then ''Betradar'' else ''Betgenius'' end as FeedOperator,case when Live.Event.BetradarMatchId>0 then ''1'' else ''3'' end as FeedOperatorColor,Parameter.Tournament.TournamentName,Parameter.Tournament.TournamentId,Parameter.Category.CategoryName,Parameter.Category.CategoryId '
set @sqlcommand2= ' FROM         Live.Event with (nolock) INNER JOIN '+
                      ' Live.EventDetail with (nolock) ON Live.[Event].EventId = Live.EventDetail.EventId INNER JOIN '+
                       ' Language.ParameterCompetitor LPC with (nolock) ON    LPC.CompetitorId =Live.[Event].HomeTeam and LPC.LanguageId=2 INNER JOIN '+
                       ' Language.ParameterCompetitor AS Competitor_1 with (nolock) ON  Competitor_1.CompetitorId=Live.[Event].AwayTeam  and  Competitor_1.LanguageId=2 inner join '+
                      ' Live.[Parameter.BetStatu] with (nolock) on Live.[Parameter.BetStatu].BetStatuId=Live.EventDetail.BetStatus  inner join '+
                      ' Live.[Parameter.ConnectionStatu] with (nolock) on Live.[Parameter.ConnectionStatu].ConnectionStatuId=Live.[Event].ConnectionStatu left outer join '+
                      ' Live.[Parameter.FeedStatu] with (nolock) on Live.[Parameter.FeedStatu].FeedStatuId=Live.[Event].FeedStatu inner join '+
                      ' Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.[Event].EventId inner join '+
                      ' Parameter.MatchState with (nolock) on Parameter.MatchState.StateId=Live.[EventSetting].StateId inner join '+
                      ' Live.[Parameter.TimeStatu] with (nolock) ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN  '+
                      
					  ' Parameter.Tournament with (nolock) On Parameter.Tournament.TournamentId=Live.Event.TournamentId INNER JOIN '+
					  ' Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN  '+
					  ' [Language].[Parameter.Sport] with (nolock) On [Language].[Parameter.Sport].SportId=Parameter.Category.SportId and [Language].[Parameter.Sport].LanguageId='+cast(@LangId as nvarchar(3)) + 
  --' Where    ( Live.[Event].EventDate>=dbo.UserTimeZoneDate('''+cast(@UserName as nvarchar(50))+''','''+cast(@BeginDate as nvarchar(50))  +''',1) )  and  Live.[Event].EventDate<=(dbo.UserTimeZoneDate('''+cast(@UserName as nvarchar(50))+''','''+cast(@EndDate as nvarchar(50))  +''' ,0)) and '+@Where + 'Order by Live.[Event].EventDate'
 ' Where   ((dbo.UserTimeZoneDate('''+cast(@UserName as nvarchar(50))+''',Live.[Event].EventDate,0)>='''+cast(@BeginDate as nvarchar(50))  +''' ) and (dbo.UserTimeZoneDate('''+cast(@UserName as nvarchar(50))+''',Live.[Event].EventDate,0)<='''+cast(@EndDate as nvarchar(50)) + '''))  and '+@Where + 'Order by Live.[Event].EventDate'
 -- set @sqlcommand2=''
  exec  (@sqlcommand+@sqlcommand2)
    
END



GO
