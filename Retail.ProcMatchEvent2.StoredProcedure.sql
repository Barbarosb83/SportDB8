USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcMatchEvent2]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Retail].[ProcMatchEvent2] 
@MatchId bigint,
@LangId int

AS

BEGIN
SET NOCOUNT ON;



if exists (select Match.Match.MatchId from Match.Match with (nolock) where Match.MatchId=@MatchId)
SELECT     Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetiTip_1.CompetitorName AS EventName
FROM         Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON CompetiTip_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId and ParameterCompetiTip_1.LanguageId=@LangId 
Where  Cache.Fixture.MatchId=@MatchId and Cache.Fixture.MatchDate>GETDATE()



else if exists (select Live.[Event].EventId from Live.[Event] with (nolock) where Live.[Event].EventId=@MatchId)
SELECT    Live.Event.BetradarMatchId,Live.Event.EventId  as MatchId,
 Language.ParameterCompetitor.CompetitorName +'-'+ParameterCompetiTip_1.CompetitorName AS EventName
FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND 
                         Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND 
                         Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
                         Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId AND Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                         Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
                         Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId  AND Language.[Parameter.Tournament].LanguageId=@LangId  INNER JOIN
                         Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND 
                         Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND Parameter.Sport.SportId = Language.[Parameter.Sport].SportId  AND Language.[Parameter.Sport].LanguageId=@LangId   INNER JOIN
                         Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND 
                         Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId  AND Language.[Parameter.Category].LanguageId=@LangId   ON Parameter.Competitor.CompetitorId = Live.Event.HomeTeam INNER JOIN
                         Parameter.Competitor AS CompetiTip_1 with (nolock) ON Live.Event.AwayTeam = CompetiTip_1.CompetitorId INNER JOIN
                         Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId  AND ParameterCompetiTip_1.LanguageId=@LangId  INNER JOIN
                         Live.[Parameter.TimeStatu] ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 Live.[EventSetting] on Live.[EventSetting].MatchId=Live.Event.EventId INNER JOIN Live.[EventTopOdd] ON Live.[EventTopOdd].EventId=Live.[Event].EventId
Where Live.[Event].EventId=@MatchId
else
begin
	select  distinct  Outrights.[Event].EventBetradarId as BetradarMatchId, Outrights.[Event].EventId as MatchId, [Language].[Parameter.Category].CategoryName +' '+ Outrights.[EventName].EventName AS EventName 

		from Outrights.[Event] inner join Outrights.[EventName] on Outrights.[Event].EventId = Outrights.[EventName].EventId 
				and Outrights.[EventName].LanguageId=2
		inner join Parameter.TournamentOutrights on Outrights.[Event].TournamentId=Parameter.TournamentOutrights.TournamentId
		inner join Parameter.[Category] on Parameter.[Category].CategoryId=Parameter.TournamentOutrights.CategoryId 
		inner join Parameter.Sport on Parameter.[Category].SportId=Parameter.Sport.SportId 
		inner join [Language].[Parameter.Category] on [Language].[Parameter.Category].CategoryId=Parameter.[Category].CategoryId 
			and [Language].[Parameter.Category].LanguageId=2
Where  Outrights.[Event].EventDate>DATEADD(MINUTE,1, GETDATE()) and Outrights.[Event].IsActive=1 and Parameter.TournamentOutrights.IsActive=1 and Outrights.[Event].EventId=@MatchId
end

END


GO
