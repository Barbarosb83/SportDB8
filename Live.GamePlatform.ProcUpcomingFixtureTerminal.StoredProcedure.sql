USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcUpcomingFixtureTerminal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 
CREATE PROCEDURE [Live].[GamePlatform.ProcUpcomingFixtureTerminal]
	@LangId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	 SELECT DISTINCT  Match.Match.MatchId AS EventId, Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName, Language.[Parameter.Sport].SportName, 
                         Parameter.Sport.SportName AS SportNameOriginal, Parameter.Sport.Icon AS SportIcon, Parameter.Sport.IconColor AS SportIconColor, Language.ParameterCompetitor.CompetitorName AS HomeTeam, 
                         ParameterCompetiTip_1.CompetitorName AS AwayTeam, Live.Event.EventDate, Live.EventDetail.IsActive, Live.EventDetail.EventStatu, Live.EventDetail.BetStatus, Live.EventDetail.MatchTime, 
                         Live.EventDetail.MatchTimeExtended, Live.EventDetail.Score, Live.EventDetail.TimeStatu, Live.[Parameter.TimeStatu].StatuColor, Language.[Parameter.LiveTimeStatu].TimeStatu AS TimeStatuColor, 
                           Cache.Fixture.OddId1, Cache.Fixture.OddValue1, 
                         Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, Cache.Fixture.Odd1Visibility2 AS Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, 
                         Cache.Fixture.Odd1Visibility3 AS Odd3Visibility, 
                         0 AS ExtraOddCount, Live.EventDetail.BetStatus AS Expr1, Live.EventLiveStreaming.Web AS HasStreaming,
						  (SELECT     COUNT(DISTINCT OddTypeId)
                                                         FROM          Match.OddTypeSetting with (nolock)
                                                         WHERE      (MatchId = Match.Match.MatchId) AND (StateId = 2)) AS OddTypeCount,Match.Match.BetradarMatchId
FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId = @LangId INNER JOIN
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
						 Cache.Fixture with (nolock) ON Cache.Fixture.BetradarMatchId=Live.[Event].BetradarMatchId INNER JOIN
                         Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                         Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND Language.[Parameter.Tournament].LanguageId = @LangId INNER JOIN
                         Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND Language.[Parameter.Sport].LanguageId = @LangId INNER JOIN
                         Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND Language.[Parameter.Category].LanguageId = @LangId ON 
                         Parameter.Competitor.CompetitorId = Live.Event.HomeTeam INNER JOIN
                         Parameter.Competitor AS CompetiTip_1 with (nolock) ON Live.Event.AwayTeam = CompetiTip_1.CompetitorId INNER JOIN
                         Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId AND ParameterCompetiTip_1.LanguageId = @LangId INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN
                         Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId = Live.[Parameter.TimeStatu].TimeStatuId AND 
                         Language.[Parameter.LiveTimeStatu].LanguageId = @LangId INNER JOIN
                         Live.EventSetting with (nolock) ON Live.EventSetting.MatchId = Live.Event.EventId INNER JOIN
                         Match.Match with (nolock) ON Live.Event.BetradarMatchId = Match.Match.BetradarMatchId LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Live.Event.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId
WHERE        (Live.EventSetting.StateId = 2) AND (Live.EventDetail.IsActive = 1)
 AND (Live.EventDetail.TimeStatu = 1) AND Live.Event.EventDate >DATEADD(MINUTE,10,GETDATE()) 
 AND (CAST(Live.Event.EventDate AS date) <= CAST(DATEADD(DAY,14,GETDATE()) AS date)) 
 and Live.EventDetail.BetStatus<>2
--AND (CAST(Live.EventDetail.UpdatedDate AS date) = CAST(GETDATE() AS date)) and 
--ORDER BY Live.Event.EventDate

END




GO
