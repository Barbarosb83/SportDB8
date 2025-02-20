USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcFixture]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Stadium].[ProcFixture] 
@SportId int,
@CategoryId int,
@TournamentId int,
@StadiumId bigint,
@LangId int

AS
BEGIN
SET NOCOUNT ON;

	declare @TimeRandeId int
	declare @EventDate datetime =DATEADD(DAY,1,GETDATE())
declare @StartDate date
declare @EndDate date
declare @TournamentIds nvarchar(max)
DECLARE @Delimeter char(1)
	SET @Delimeter = ','
	declare @sayac int=0
	DECLARE @tblOdd TABLE(oddId bigint)
	DECLARE @ak nvarchar(10)
	DECLARE @StartPos int, @Length int
 
if (@TournamentId>0)
	begin
			SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetiTip_1.CompetitorName AS EventName, 
                    Programme.SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,    (SELECT     COUNT(DISTINCT OddTypeId)
                                        FROM          Match.OddTypeSetting with (nolock)
                                                      WHERE      (MatchId = Programme.MatchId) AND (StateId = 2)) as OddTypeCount, 
                    Programme.TournamentId,Programme.MatchDate as TournamentDate
	
FROM         Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN
                      Parameter.Competitor INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON CompetiTip_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId and ParameterCompetiTip_1.LanguageId=@LangId LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Programme.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId INNER JOIN 
						 Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN 
						 Parameter.Tournament On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId
						 where Programme.SportId=@SportId and Programme.TournamentId=@TournamentId and Programme.MatchDate>DATEADD(MINUTE,5, GETDATE()) and Programme.MatchDate<=@EventDate and Parameter.Sport.IsActive=1
						 and (SELECT     COUNT(DISTINCT OddTypeId)
                                        FROM          Match.OddTypeSetting with (nolock)
                                                      WHERE      (MatchId = Programme.MatchId) AND (StateId = 2))>0
		end
else if (@CategoryId>0  and @SportId>=0)
	begin
					SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetiTip_1.CompetitorName AS EventName, 
                    Programme.SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,    (SELECT     COUNT(DISTINCT OddTypeId)
                                        FROM          Match.OddTypeSetting with (nolock)
                                                      WHERE      (MatchId = Programme.MatchId) AND (StateId = 2)) as OddTypeCount, 
                    Programme.TournamentId,Programme.MatchDate as TournamentDate
	
FROM         Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN
                      Parameter.Competitor INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON CompetiTip_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId and ParameterCompetiTip_1.LanguageId=@LangId LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Programme.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId INNER JOIN 
						 Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN 
						 Parameter.Tournament On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId
						 where Programme.SportId=@SportId and Parameter.Category.CategoryId=@CategoryId and Programme.MatchDate>DATEADD(MINUTE,5, GETDATE()) and Programme.MatchDate<=@EventDate and Parameter.Sport.IsActive=1
						 and (SELECT     COUNT(DISTINCT OddTypeId)
                                        FROM          Match.OddTypeSetting with (nolock)
                                                      WHERE      (MatchId = Programme.MatchId) AND (StateId = 2))>0

	end
else if (@SportId>0 )
	begin
					SELECT     Programme.BetradarMatchId,Programme.MatchId, Programme.MatchDate,Language.[Parameter.Tournament].TournamentName,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetiTip_1.CompetitorName AS EventName, 
                    Programme.SportName,Programme.TournamentId,Programme.SportId,Parameter.Category.CategoryId,Parameter.Sport.SportName as SportNameOrginal
					,    (SELECT     COUNT(DISTINCT OddTypeId)
                                        FROM          Match.OddTypeSetting with (nolock)
                                                      WHERE      (MatchId = Programme.MatchId) AND (StateId = 2)) as OddTypeCount, 
                    Programme.TournamentId,Programme.MatchDate as TournamentDate
	
FROM         Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN
                      Parameter.Competitor INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                      Cache.Programme as Programme with (nolock) ON Parameter.Competitor.CompetitorId = Programme.[HomeTeam ] ON CompetiTip_1.CompetitorId = Programme.[AwayTeam ] INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId and ParameterCompetiTip_1.LanguageId=@LangId LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Programme.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId INNER JOIN 
						 Language.[Parameter.Tournament] ON Language.[Parameter.Tournament].TournamentId=Programme.TournamentId and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
						 Parameter.Tournament On Parameter.Tournament.TournamentId=Programme.TournamentId INNER JOIN
						 Parameter.Category On Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
						 Parameter.Sport on Parameter.Sport.SportId=Programme.SportId INNER JOIN
						 Language.[Parameter.Category] On Language.[Parameter.Category].CategoryId=Parameter.Category.CategoryId and  Language.[Parameter.Category].LanguageId=@LangId
						 where Programme.SportId=@SportId and Programme.MatchDate>DATEADD(MINUTE,5, GETDATE()) and Programme.MatchDate<=@EventDate and Parameter.Sport.IsActive=1
						 and (SELECT     COUNT(DISTINCT OddTypeId)
                                        FROM          Match.OddTypeSetting with (nolock)
                                                      WHERE      (MatchId = Programme.MatchId) AND (StateId = 2))>0

	end
 
 
 

END




GO
