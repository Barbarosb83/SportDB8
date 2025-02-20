USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcLiveGameDataResultOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [RiskManagement].[ProcLiveGameDataResultOne] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;


declare @sqlcommand nvarchar(max)
declare @sqlcommand2 nvarchar(max)


if exists(select Archive.[Live.Event].EventId from Archive.[Live.Event] with (nolock) where Archive.[Live.Event].EventId=@MatchId)
	begin
	select Archive.[Live.Event].EventId,
                      ParameterCompetiTip_1.CompetitorName AS Team1, 
                      Language.ParameterCompetitor.CompetitorName AS Team2,
                      Language.[Parameter.Sport].SportName, Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName
                     
	FROM         Parameter.Tournament with (nolock) INNER JOIN 
                      Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
                      Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId INNER JOIN 
                      Language.[Parameter.Category] ON Parameter.Tournament.CategoryId = Language.[Parameter.Category].CategoryId AND 
                      Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Category].LanguageId INNER JOIN 
                      Archive.[Live.Event] with (nolock) INNER JOIN 
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON Archive.[Live.Event].HomeTeam = ParameterCompetiTip_1.CompetitorId INNER JOIN 
                      Language.ParameterCompetitor with (nolock) ON Archive.[Live.Event].AwayTeam = Language.ParameterCompetitor.CompetitorId AND 
                      ParameterCompetiTip_1.LanguageId = Language.ParameterCompetitor.LanguageId  ON 
                      Language.[Parameter.Tournament].LanguageId = ParameterCompetiTip_1.LanguageId AND 
                      Language.[Parameter.Tournament].LanguageId = Language.ParameterCompetitor.LanguageId AND 
                      Language.[Parameter.Tournament].TournamentId = Archive.[Live.Event].TournamentId INNER JOIN 
                      Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND  
                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId AND 
                      Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId INNER JOIN 
                      Language.[Parameter.Sport] with (nolock) ON Parameter.Category.SportId = Language.[Parameter.Sport].SportId AND 
                      Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN 
                      Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId  
	WHERE  (Archive.[Live.Event].EventId = @MatchId) and Language.[Parameter.Sport].LanguageId=@LangId
	
	end
else
	begin
			select Live.[Event].EventId,
                      ParameterCompetiTip_1.CompetitorName AS Team1, 
                      Language.ParameterCompetitor.CompetitorName AS Team2,
                      Language.[Parameter.Sport].SportName, Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName
	FROM         Parameter.Tournament with (nolock) INNER JOIN 
                      Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND 
                      Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId INNER JOIN 
                      Language.[Parameter.Category] with (nolock) ON Parameter.Tournament.CategoryId = Language.[Parameter.Category].CategoryId AND 
                      Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Category].LanguageId INNER JOIN 
                      Live.[Event] with (nolock) INNER JOIN 
                      Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON Live.[Event].HomeTeam = ParameterCompetiTip_1.CompetitorId INNER JOIN 
                      Language.ParameterCompetitor with (nolock) ON Live.[Event].AwayTeam = Language.ParameterCompetitor.CompetitorId AND 
                      ParameterCompetiTip_1.LanguageId = Language.ParameterCompetitor.LanguageId  ON 
                      Language.[Parameter.Tournament].LanguageId = ParameterCompetiTip_1.LanguageId AND 
                      Language.[Parameter.Tournament].LanguageId = Language.ParameterCompetitor.LanguageId AND 
                      Language.[Parameter.Tournament].TournamentId = Live.[Event].TournamentId INNER JOIN 
                      Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND  
                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId AND 
                      Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId INNER JOIN 
                      Language.[Parameter.Sport] with (nolock) ON Parameter.Category.SportId = Language.[Parameter.Sport].SportId AND 
                      Language.[Parameter.Tournament].LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN 
                      Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId  
	WHERE  (Live.[Event].EventId = @MatchId) and Language.[Parameter.Sport].LanguageId=@LangId
	
	end



END


GO
