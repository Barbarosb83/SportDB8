USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentFullLastMinutes]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [GamePlatform].[ProcTournamentFullLastMinutes] 
@LangId int

AS

BEGIN
SET NOCOUNT ON;

declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2

SELECT  top 50   Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                      Language.[Parameter.Sport].SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, 
                      Cache.Fixture.Odd1Visibility2 as Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, Cache.Fixture.Odd1Visibility3 as Odd3Visibility, Cache.Fixture.OddTypeCount, 
                      Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround,
					  Language.[Parameter.Tournament].TournamentName,
					  Language.[Parameter.Category].CategoryName,
					  Language.[Parameter.Category].CategoryName+'-'+Language.[Parameter.Tournament].TournamentName as GroupName,null AS HasStreaming,
					  Parameter.Sport.SportName AS SpornNameOrginal
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN
					  Language.[Parameter.Tournament] with (nolock) on Language.[Parameter.Tournament].TournamentId=Cache.Fixture.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
					  Parameter.Tournament with (nolock) on Parameter.Tournament.TournamentId=Cache.Fixture.TournamentId INNER JOIN
					  Language.[Parameter.Category] with (nolock) on Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId and Language.[Parameter.Category].LanguageId=@LangId  INNER JOIN 
						 Parameter.Category with (nolock) ON Parameter.Category.CategoryId=Language.[Parameter.Category].CategoryId INNER JOIN
						 Parameter.Sport with (nolock) On Parameter.Sport.SportId=Parameter.Category.SportId INNER JOIN 
						 Language.[Parameter.Sport] with (nolock) ON Language.[Parameter.Sport].SportId=Parameter.Sport.SportId and Language.[Parameter.Sport].LanguageId=@LangId
WHERE     DATEDIFF(MINUTE,GETDATE(),Cache.Fixture.MatchDate)<=300 AND DATEDIFF(MINUTE,GETDATE(),Cache.Fixture.MatchDate)>=3
ORDER BY Parameter.Sport.SquanceNumber


END




GO
