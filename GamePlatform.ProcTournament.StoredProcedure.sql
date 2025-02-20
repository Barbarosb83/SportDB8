USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournament]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [GamePlatform].[ProcTournament] 
@CategoryId int,
@LangId int,
@EndDay int 
AS

BEGIN
SET NOCOUNT ON;


 declare @EnnDay int=@EndDay
  
	--if (@EndDay>24)
	--begin
	--if @CategoryId in (13,1,15,14,16,99,106,103)
	-- 	set @EndDay=@EndDay+900

	--	if @CategoryId in (13,1,15,14,16,99,106,103)
	--	set @EndDay=@EndDay+3000
	--	end
 if(@EndDay=24)
		set @EndDay=DATEDIFF(HOUR,GETDATE(),cast(cast(GETDATE() as DATE) as nvarchar(20))+' 23:59:00.000')
else
	if(@EndDay>24)
	 	set @EndDay=20000

declare @TempTable table(TournamentId int not null,TournamentName nvarchar(250) not null,CategoryId int not null,TournamentSportEventCount int,SequenceNumber int)


insert @TempTable
SELECT     Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId, COUNT(Tournament_1.MatchId) as TournamentSportEventCount
,Parameter.Tournament.SequenceNumber
FROM         Parameter.Tournament with (nolock) INNER JOIN
                      Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId 
                       and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
                      Cache.Fixture AS Tournament_1  with (nolock)  ON Parameter.Tournament.TournamentId = Tournament_1.TournamentId
                     
where (Tournament_1.MatchDate<= 
  DATEADD(HOUR,@EndDay,GETDATE()) ) and  Tournament_1.MatchDate>GETDATE()  and Parameter.Tournament.CategoryId=@CategoryId
--and Tournament_1.TournamentId  in (1125,13827,13891,13889,13858,13852,13845,13839)
GROUP BY Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId,Parameter.Tournament.SequenceNumber
--order by Parameter.Tournament.SequenceNumber, Language.[Parameter.Tournament].TournamentName
 

select TournamentId ,TournamentName ,CategoryId ,TournamentSportEventCount from @TempTable
order by  SequenceNumber,  TournamentName


END


GO
