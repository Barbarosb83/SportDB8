USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[RiskManagement.ProcFixture]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[RiskManagement.ProcFixture]
	@BeginDate datetime,
	@EndDate datetime,
	@LangId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
    SELECT     Virtual.EventDetail.EventId, Virtual.EventDetail.BetStatus, 
			Virtual.[Parameter.BetStatu].BetStatu,
			Virtual.[Parameter.BetStatu].StatuColor as BetStatuColor,
			Virtual.[Parameter.TimeStatu].TimeStatu,
			Virtual.[Parameter.TimeStatu].StatuColor as TimeStatuColor,
			Parameter.MatchState.State as EventStatu,
			Parameter.MatchState.StateId as EventStatuId,
			Parameter.MatchState.StatuColor as EventStatuColor,
			Language.ParameterCompetitor.CompetitorName as HomeTeam, 
			ParameterCompetiTip_1.CompetitorName AS AwayTeam,
			isnull(Virtual.Event.LastScore,'-') as Score,
			Virtual.Event.EventDate,
			0 as Bets,
			0 as Stakes,
			0 as Losses,
			(select COUNT(Virtual.EventOdd.OddId) from Virtual.EventOdd where Virtual.EventOdd.MatchId=Virtual.EventDetail.EventId and Virtual.EventOdd.IsActive=1 and Virtual.EventOdd.OddResult is null and Virtual.EventOdd.IsCanceled is null) as OpenOdds,
			(select COUNT(Virtual.EventOdd.OddId) from Virtual.EventOdd where Virtual.EventOdd.MatchId=Virtual.EventDetail.EventId and Virtual.EventOdd.IsActive=0 and Virtual.EventOdd.OddResult is null and Virtual.EventOdd.IsCanceled is null) as CloseOdds,
			(select COUNT(Virtual.EventOdd.OddId) from Virtual.EventOdd where Virtual.EventOdd.MatchId=Virtual.EventDetail.EventId and Virtual.EventOdd.OddResult is null and Virtual.EventOdd.IsCanceled=1) as CancelOdds,
			(select COUNT(Virtual.EventOdd.OddId) from Virtual.EventOdd where Virtual.EventOdd.MatchId=Virtual.EventDetail.EventId and Virtual.EventOdd.OddResult is not null) as CompleteOdds,
			isnull(Users.Name,'')+' '+isnull(Users.Surname,'')  as Manager,
			isnull(Virtual.Event.Manager,0) as ManagerId,
		Virtual.[Parameter.ConnectionStatu].ConnectionStatu,
		Virtual.[Parameter.ConnectionStatu].StatuColor as ConnectionStatuColor,
		Virtual.[Parameter.FeedStatu].FeedStatu,
		Virtual.[Parameter.FeedStatu].StatuColor as FeedStatuColor
			
FROM         Virtual.Event INNER JOIN
                      Virtual.EventDetail ON Virtual.Event.EventId = Virtual.EventDetail.EventId INNER JOIN
                      Language.ParameterCompetitor INNER JOIN
																Parameter.Competitor ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND 
																						Language.ParameterCompetitor.LanguageId=@LangId ON Virtual.Event.HomeTeam = Parameter.Competitor.CompetitorId 
				      INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 INNER JOIN
                      Parameter.Competitor AS CompetiTip_1 ON ParameterCompetiTip_1.CompetitorId = CompetiTip_1.CompetitorId AND 
                      ParameterCompetiTip_1.LanguageId=@LangId ON Virtual.Event.AwayTeam = CompetiTip_1.CompetitorId inner join
                      Virtual.[Parameter.BetStatu] on Virtual.[Parameter.BetStatu].BetStatuId=Virtual.EventDetail.BetStatus  inner join
                      Virtual.[Parameter.ConnectionStatu] on Virtual.[Parameter.ConnectionStatu].ConnectionStatuId=Virtual.Event.ConnectionStatu left outer join
                      Virtual.[Parameter.FeedStatu] on Virtual.[Parameter.FeedStatu].FeedStatuId=Virtual.Event.FeedStatu inner join
                      Virtual.[EventSetting] on Virtual.[EventSetting].MatchId=Virtual.Event.EventId inner join                  
                      Parameter.MatchState on Parameter.MatchState.StateId=Virtual.[EventSetting].StateId inner join
                      Virtual.[Parameter.TimeStatu] ON Virtual.EventDetail.TimeStatu = Virtual.[Parameter.TimeStatu].TimeStatuId left outer join
                      Users.Users on Users.Users.UserId=Virtual.Event.Manager
					
  Where ((EventDate>@BeginDate) and (EventDate<@EndDate))
  Order By Virtual.Event.EventDate asc
    
END


GO
