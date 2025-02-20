USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcLiveScoreInsert]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [RiskManagement].[ProcLiveScoreInsert] 

 AS
 BEGIN
INSERT INTO [Live].[Score]
           ([BetradarMatchId]
           ,[Score]
           ,[ScoreTime])
select distinct EventDetail.BetradarMatchIds,
		'0:0', 
	0 
FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId=2 INNER JOIN
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail as EventDetail with (nolock) ON Live.Event.EventId = EventDetail.EventId INNER JOIN
                         Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                         Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND Language.[Parameter.Tournament].LanguageId=2  INNER JOIN
                         Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId   AND Language.[Parameter.Sport].LanguageId=2   INNER JOIN
                         Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId  AND Language.[Parameter.Category].LanguageId=2   ON Parameter.Competitor.CompetitorId = Live.Event.HomeTeam INNER JOIN
                         Parameter.Competitor  AS CompetiTip_1 with (nolock) ON Live.Event.AwayTeam = CompetiTip_1.CompetitorId INNER JOIN
                         Language.ParameterCompetitor  AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId  AND ParameterCompetiTip_1.LanguageId=2  INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 Language.[Parameter.LiveTimeStatu] with (nolock) On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=2 INNER JOIN
						 Live.[EventSetting] with (nolock)  on Live.[EventSetting].MatchId=Live.Event.EventId INNER JOIN Live.[EventTopOdd] with (nolock) ON Live.[EventTopOdd].EventId=Live.[Event].EventId 
Where
((Live.[EventSetting].StateId=2 and --Match State Open
EventDetail.IsActive=1 and --Match Active
EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  )  OR (EventDetail.TimeStatu=1 AND Live.[EventTopOdd].ThreeWay1 is not null and Live.[Event].ConnectionStatu=2 
and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2))  
--and  Parameter.Sport.SportId=999 and 
and Parameter.Sport.SportId=1 and BetradarMatchIds not in (Select BetradarMatchId from Live.score)


INSERT INTO [Live].[Score]
           ([BetradarMatchId]
           ,[Score]
           ,[ScoreTime])
	SELECT     Programme.BetradarMatchId,'0:0',0
FROM         Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock)  INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=2 INNER JOIN
                      Cache.Programme2 as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON CompetiTip_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
					  Cache.Fixture as CFF with (nolock) ON CFF.MatchId=Programme.MatchId Inner JOIN
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId and ParameterCompetiTip_1.LanguageId=2   INNER JOIN 
						 Language.[Parameter.Tournament] with (nolock)  ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=2 INNER JOIN 
						 Parameter.Tournament with (nolock)  On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category with (nolock)  On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport with (nolock)  on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Language.[Parameter.Category] with (nolock)  On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=2 INNER JOIN
						 Language.[Parameter.Sport]  with (nolock) ON  Language.[Parameter.Sport].SportId= Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=2
						 where Programme.SportId=1 and Programme.MatchDate> GETDATE() and  Programme.BetradarMatchId not in (Select BetradarMatchId from Live.score) 
						 and Programme.BetradarMatchId in (Select BetradarMatchId from Live.Event)
						 
					 
end
GO
