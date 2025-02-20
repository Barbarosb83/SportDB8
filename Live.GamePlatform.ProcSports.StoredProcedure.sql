USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcSports]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[GamePlatform.ProcSports]
	@LangId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT     distinct  Language.[Parameter.Sport].SportName+' ('+cast(COUNT(Language.[Parameter.Sport].SportName) as nvarchar(5))+')' as SportName, 
				Parameter.Sport.SportName AS OrginalName, 
                Parameter.Sport.Icon AS SportIcon,
                Parameter.Sport.IconColor AS SportIconColor,
                Parameter.Sport.SportId,Parameter.Sport.SquanceNumber

FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
                         Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                         Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND Language.[Parameter.Tournament].LanguageId=@LangId  INNER JOIN
                         Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId   AND Language.[Parameter.Sport].LanguageId=@LangId   INNER JOIN
                         Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId  AND Language.[Parameter.Category].LanguageId=@LangId   ON Parameter.Competitor.CompetitorId = Live.Event.HomeTeam INNER JOIN
                         Parameter.Competitor AS CompetiTip_1 with (nolock) ON Live.Event.AwayTeam = CompetiTip_1.CompetitorId INNER JOIN
                         Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId  AND ParameterCompetiTip_1.LanguageId=@LangId  INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId INNER JOIN Live.[EventTopOdd] ON Live.[EventTopOdd].EventId=Live.[Event].EventId
Where Parameter.Sport.IsActive=1 and
((Live.[EventSetting].StateId=2 and --Match State Open
Live.[EventDetail].IsActive=1 and --Match Active
Live.[EventDetail].TimeStatu not in (0,1,5,14,27,84,21,22,23,24,25,26,11,86,83)  and 
Live.[Event].ConnectionStatu=2) OR (Live.[EventDetail].TimeStatu=5 and DATEDIFF(MINUTE,  Live.[EventDetail].UpdatedDate,GETDATE())<2)  and 
Live.[Event].ConnectionStatu=2 OR (Live.[EventDetail].TimeStatu=1 AND Live.[EventTopOdd].ThreeWay1 is not null and Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and Live.[EventDetail].IsActive=1 and Live.[EventDetail].BetStatus=2))
GROUP BY Language.[Parameter.Sport].SportName, 
				Parameter.Sport.SportName , 
                Parameter.Sport.Icon,
                Parameter.Sport.IconColor,
                Parameter.Sport.SportId,Parameter.Sport.SquanceNumber
				ORDER BY Parameter.Sport.SquanceNumber


END



GO
