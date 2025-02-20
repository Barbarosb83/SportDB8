USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcTournament]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Stadium].[ProcTournament] 
@CategoryId int,
@LangId int,
@StadiumId bigint
AS

BEGIN
SET NOCOUNT ON;


declare @TempTable table(TournamentId int not null,TournamentName nvarchar(150) not null,CategoryId int not null,TournamentSportEventCount int,SequenceNumber int)

if exists (Select Stadium.Tournament.TournamentId from Stadium.Tournament where StadiumId=@StadiumId and TournamentId=-1)
	begin
		insert @TempTable
		SELECT     Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId, COUNT(Tournament_1.MatchId) as TournamentSportEventCount
		,Parameter.Tournament.SequenceNumber
		FROM         Parameter.Tournament with (nolock) INNER JOIN
							  Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId 
							   and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
							  Cache.Fixture AS Tournament_1 ON Parameter.Tournament.TournamentId = Tournament_1.TournamentId
                     
		where Tournament_1.MatchDate<(Select Stadium.Stadium.EndDate from Stadium.Stadium where StadiumId=@StadiumId) and  Tournament_1.MatchDate>GETDATE() and Parameter.Tournament.CategoryId=@CategoryId
		and Tournament_1.TournamentId not in (13951,13827,13891,13889,13858,13852,13845,13839)
				and (SELECT     COUNT(DISTINCT OddTypeId)
                                        FROM          Match.OddTypeSetting with (nolock)
                                                      WHERE      (MatchId = Tournament_1.MatchId) AND (StateId = 2))>0
		GROUP BY Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId,Parameter.Tournament.SequenceNumber
	--order by Parameter.Tournament.SequenceNumber, Language.[Parameter.Tournament].TournamentName
	end
else
	begin
		insert @TempTable
		SELECT     Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId, COUNT(Tournament_1.MatchId) as TournamentSportEventCount
		,Parameter.Tournament.SequenceNumber
		FROM         Parameter.Tournament with (nolock) INNER JOIN
							  Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId 
							   and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
							  Cache.Fixture AS Tournament_1 ON Parameter.Tournament.TournamentId = Tournament_1.TournamentId
                     
		where Tournament_1.MatchDate<(Select Stadium.Stadium.EndDate from Stadium.Stadium where StadiumId=@StadiumId) and  Tournament_1.MatchDate>GETDATE() and Parameter.Tournament.CategoryId=@CategoryId
		and Tournament_1.TournamentId in (Select Stadium.Tournament.TournamentId from Stadium.Tournament where StadiumId=@StadiumId)
		and (SELECT     COUNT(DISTINCT OddTypeId)
                                        FROM          Match.OddTypeSetting with (nolock)
                                                      WHERE      (MatchId = Tournament_1.MatchId) AND (StateId = 2))>0
		GROUP BY Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId,Parameter.Tournament.SequenceNumber

	end

select TournamentId ,TournamentName ,CategoryId ,TournamentSportEventCount from @TempTable
order by  SequenceNumber,  TournamentName


END


GO
