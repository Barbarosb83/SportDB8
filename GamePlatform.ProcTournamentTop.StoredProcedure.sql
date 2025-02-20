USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentTop]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcTournamentTop] 
@LangId int,
@EndDay int 
AS

BEGIN
SET NOCOUNT ON;


 declare @EnnDay int=@EndDay

--if (@EndDay=300)
--	set @EndDay=@EndDay+60
--	if (@EndDay>24)
--	begin
--	if @CategoryId=5
--		set @EndDay=@EndDay+900

--		if @CategoryId in (13,1,15,14,16,99,106,103)
--		set @EndDay=@EndDay+3000
--		end
 if(@EndDay=24)
		set @EndDay=DATEDIFF(HOUR,GETDATE(),cast(cast(GETDATE() as DATE) as nvarchar(20))+' 23:59:00.000')

declare @TempTable table(TournamentId int not null,TournamentName nvarchar(250) not null,CategoryId int not null,TournamentSportEventCount int,SequenceNumber int,IsoName nvarchar(50),CategorySequenceNumber int,BetradarId bigint,SportId int)


insert @TempTable
SELECT     Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId, COUNT(Tournament_1.MatchId) as TournamentSportEventCount
,ISNULL(Parameter.Tournament.SequenceNumber,999),  SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3) AS IsoName,ISNULL(Parameter.Tournament.SequenceNumber,999)
,Parameter.Tournament.NewBetradarId as BetradarId,Tournament_1.SportId
FROM         Parameter.Tournament with (nolock) INNER JOIN
                      Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId 
                       and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
                      Cache.Fixture AS Tournament_1  with (nolock)  ON Parameter.Tournament.TournamentId = Tournament_1.TournamentId INNER JOIN
					  Parameter.Category ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId
                     
where  Parameter.Category.SportId=1
 
and  Tournament_1.MatchDate>GETDATE()  
and Parameter.Tournament.IsPopularWeb=1
--and Tournament_1.TournamentId  in (1125,13827 ,13891,13889,13858,13852,13845,13839)
GROUP BY Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName
, Parameter.Tournament.CategoryId
,Parameter.Category.SequenceNumber,Parameter.Iso.IsoName2,Parameter.Tournament.SequenceNumber,Parameter.Tournament.NewBetradarId,Tournament_1.SportId
--order by Parameter.Tournament.SequenceNumber, Language.[Parameter.Tournament].TournamentName
 

select TournamentId ,TournamentName ,CategoryId ,TournamentSportEventCount,IsoName,BetradarId,SportId, SequenceNumber from @TempTable
order by CategorySequenceNumber, SequenceNumber


END
GO
