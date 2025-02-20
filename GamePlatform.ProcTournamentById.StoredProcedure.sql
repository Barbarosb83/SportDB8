USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentById]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcTournamentById] 
@CategoryId int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

SELECT     Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId, COUNT(Tournament_1.MatchId) as TournamentSportEventCount
FROM         Parameter.Tournament with (nolock) INNER JOIN
                      Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId 
                       and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
                      Cache.Fixture AS Tournament_1 with (nolock) ON Parameter.Tournament.TournamentId = Tournament_1.TournamentId
                     
where Parameter.Tournament.TournamentId=@CategoryId and Tournament_1.MatchDate>GETDATE()
GROUP BY Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId,Parameter.Tournament.SequenceNumber
order by Parameter.Tournament.SequenceNumber, Language.[Parameter.Tournament].TournamentName

END


GO
