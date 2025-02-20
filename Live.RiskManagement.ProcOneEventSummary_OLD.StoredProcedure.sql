USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[RiskManagement.ProcOneEventSummary_OLD]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[RiskManagement.ProcOneEventSummary_OLD]
	@EventId bigint,
	@LangId int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
    SELECT     Live.EventDetail.EventId, Live.EventDetail.BetStatus, 
			Live.[Parameter.BetStatu].BetStatu,
			Live.[Parameter.BetStatu].StatuColor,
			Parameter.MatchState.State as EventStatu,
			Parameter.MatchState.StateId as EventStatuId,
			Parameter.MatchState.StatuColor as EventStatuColor,
			Language.ParameterCompetitor.CompetitorName as HomeTeam, 
			ParameterCompetiTip_1.CompetitorName AS AwayTeam,
			isnull(Live.Event.LastScore,'-') as LastScore,
			Live.Event.EventDate,
			 (select COUNT(Customer.SlipOdd.MatchId) from Customer.SlipOdd with (nolock) where Customer.SlipOdd.MatchId=Live.EventDetail.EventId) as Bets,
			dbo.FuncCashFlow(Live.EventDetail.EventId,0,2,1) as Stakes,
			dbo.FuncCashFlow(Live.EventDetail.EventId,0,5,1) as Losses,
			(select COUNT(Live.EventOdd.OddId) from Live.EventOdd with (nolock) where Live.EventOdd.MatchId=Live.EventDetail.EventId and Live.EventOdd.IsActive=1 and (Select Count(Live.EventOddResult.OddresultId) from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=Live.EventOdd.OddId)=0) as OpenOdds,
			(select COUNT(Live.EventOdd.OddId) from Live.EventOdd with (nolock) where Live.EventOdd.MatchId=Live.EventDetail.EventId and Live.EventOdd.IsActive=0 and (Select Count(Live.EventOddResult.OddresultId) from Live.EventOddResult with (nolock) where Live.EventOddResult.OddId=Live.EventOdd.OddId)=0) as CloseOdds,
			(Select Count(Live.EventOddResult.OddresultId) from Live.EventOddResult with (nolock) where Live.EventOddResult.BetradarMatchId=Live.Event.BetradarMatchId and Live.EventOddResult.IsCanceled=1) as CancelOdds,
			(Select Count(Live.EventOddResult.OddresultId) from Live.EventOddResult with (nolock) where Live.EventOddResult.BetradarMatchId=Live.Event.BetradarMatchId and (Live.EventOddResult.IsCanceled=0 or Live.EventOddResult.IsCanceled is null) ) as CompleteOdds,
			isnull(Users.Name,'')+' '+isnull(Users.Surname,'')  as Manager,
			isnull(Live.Event.Manager,0) as ManagerId,
		Live.[Parameter.ConnectionStatu].ConnectionStatu,
		Live.[Parameter.ConnectionStatu].StatuColor as ConnectionStatuColor,
		Live.[Parameter.FeedStatu].FeedStatu,
		Live.[Parameter.FeedStatu].StatuColor as FeedStatuColor,
		Live.EventDetail.Score,
		Live.EventDetail.YellowCardsTeam1,
		Live.EventDetail.YellowCardsTeam2,
		Live.EventDetail.RedCardsTeam1,
		Live.EventDetail.RedCardsTeam2,
		Live.EventDetail.YellowRedCardsTeam1,
		Live.EventDetail.YellowRedCardsTeam2,
		Live.EventDetail.CornersTeam1,
		Live.EventDetail.CornersTeam2,
		Live.EventDetail.MatchTime,
		Live.EventDetail.TimeStatu as TimeStatuId,
		isnull(Live.[Parameter.TimeStatu].TimeStatu,'') as TimeStatu,
		Live.Event.BetradarMatchId
			
FROM         Live.Event with (nolock) INNER JOIN
                      Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
                      Language.ParameterCompetitor with (nolock) INNER JOIN
																Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND 
																						Language.ParameterCompetitor.LanguageId=@LangId ON Live.Event.HomeTeam = Parameter.Competitor.CompetitorId 
				      INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) INNER JOIN
                      Parameter.Competitor AS CompetiTip_1 with (nolock) ON ParameterCompetiTip_1.CompetitorId = CompetiTip_1.CompetitorId AND 
                      ParameterCompetiTip_1.LanguageId=@LangId ON Live.Event.AwayTeam = CompetiTip_1.CompetitorId inner join
                      Live.[Parameter.BetStatu] with (nolock) on Live.[Parameter.BetStatu].BetStatuId=Live.EventDetail.BetStatus  inner join
                      Live.[Parameter.ConnectionStatu] with (nolock) on Live.[Parameter.ConnectionStatu].ConnectionStatuId=Live.Event.ConnectionStatu inner join
                      Live.[Parameter.FeedStatu] with (nolock) on Live.[Parameter.FeedStatu].FeedStatuId=Live.Event.FeedStatu inner join
                      Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId inner join                  
                      Parameter.MatchState with (nolock) on Parameter.MatchState.StateId=Live.[EventSetting].StateId left outer join
                      Live.[Parameter.TimeStatu] with (nolock) on Live.[Parameter.TimeStatu].TimeStatuId = Live.EventDetail.TimeStatu  left outer join
                      Users.Users with (nolock) on Users.Users.UserId=Live.Event.Manager
					
  Where Live.Event.EventId=@EventId
    
END


GO
