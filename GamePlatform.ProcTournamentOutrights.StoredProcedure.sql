USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentOutrights]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [GamePlatform].[ProcTournamentOutrights] 
@CategoryId int,
@LangId int,
@EndDay int 
AS

BEGIN
SET NOCOUNT ON;

--if (@EndDay=300)
--	set @EndDay=@EndDay+60

--	if @CategoryId=5
--		set @EndDay=@EndDay+900

-- if(@EndDay=24)
--		set @EndDay=DATEDIFF(HOUR,GETDATE(),cast(cast(GETDATE() as DATE) as nvarchar(20))+' 23:59:00.000')

if(@LangId=21)
	set @LangId=2

declare @TempTable table(TournamentId int not null,TournamentName nvarchar(150) not null,CategoryId int not null,TournamentSportEventCount int,SequenceNumber int)


insert @TempTable
SELECT    DISTINCT Tournament_1.TournamentId, Language.[Parameter.TournamentOutrights].TournamentName, Parameter.TournamentOutrights.CategoryId, COUNT(Tournament_1.EventId) as TournamentSportEventCount
,Parameter.TournamentOutrights.SequenceNumber
FROM         Parameter.TournamentOutrights with (nolock) INNER JOIN
                      Language.[Parameter.TournamentOutrights] with (nolock) ON Parameter.TournamentOutrights.TournamentId = Language.[Parameter.TournamentOutrights].TournamentId 
                       and Language.[Parameter.TournamentOutrights].LanguageId=@LangId INNER JOIN
                      Outrights.Event AS Tournament_1  with (nolock)  ON Parameter.TournamentOutrights.TournamentId = Tournament_1.TournamentId INNER JOIN
					  Outrights.Odd ON Outrights.Odd.MatchId=Tournament_1.EventId
                     
where Tournament_1.EventEndDate> GETDATE() -- and  Tournament_1.eve>GETDATE() 
and Parameter.TournamentOutrights.CategoryId=@CategoryId and Tournament_1.IsActive=1
--and Tournament_1.TournamentId  in (1125,13827,13891,13889,13858,13852,13845,13839)
GROUP BY Tournament_1.TournamentId,Language.[Parameter.TournamentOutrights].TournamentName, Parameter.TournamentOutrights.CategoryId,Parameter.TournamentOutrights.SequenceNumber
--order by Parameter.Tournament.SequenceNumber, Language.[Parameter.Tournament].TournamentName



select TournamentId ,TournamentName ,CategoryId ,TournamentSportEventCount from @TempTable
order by  SequenceNumber,  TournamentName


END


GO
