USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentResultAll]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcTournamentResultAll] 
@SportId int,
@LangId int,
@EndDay int 
AS

BEGIN
SET NOCOUNT ON;

SELECT     Tournament_1.TournamentId, 
			Language.[Parameter.Tournament].TournamentName,
			Parameter.Tournament.CategoryId, 
			 Language.[Parameter.Category].CategoryName,
			COUNT(Tournament_1.MatchId) as TournamentSportEventCount, ISNULL(Parameter.Category.Ispopular,0) as Ispopular,ISNULL(Parameter.Category.SequenceNumber,999) as SequenceNumber
FROM         Parameter.Tournament with (nolock) INNER JOIN
                      Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId 
                       and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
                      Cache.Result AS Tournament_1 with (nolock) ON Parameter.Tournament.TournamentId = Tournament_1.TournamentId inner join
              Parameter.Category with (nolock)  on Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
                      Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId and Language.[Parameter.Category].LanguageId=@LangId
                     
where Tournament_1.EventDate<=DATEADD(DAY,@EndDay,GETDATE()) and Parameter.Category.SportId=@SportId
GROUP BY Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId,Language.[Parameter.Category].CategoryName,Parameter.Tournament.SequenceNumber,Parameter.Category.Ispopular,Parameter.Category.SequenceNumber
order by Parameter.Tournament.SequenceNumber,Language.[Parameter.Category].CategoryName, Language.[Parameter.Tournament].TournamentName

END




GO
