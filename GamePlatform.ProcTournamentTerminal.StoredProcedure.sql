USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentTerminal]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 

CREATE PROCEDURE [GamePlatform].[ProcTournamentTerminal] 
@SportId int,
@CategoryId int,
@LangId int
AS

BEGIN
SET NOCOUNT ON;

if(@CategoryId=0)
begin
SELECT    ISNULL(Parameter.Tournament.TerminalTournamentId,21) as TournamentId, 
			case when CHARINDEX(',', Language.[Parameter.Tournament].TournamentName)>0 then REPLACE( SUBSTRING(Language.[Parameter.Tournament].TournamentName , 1, CHARINDEX(',', Language.[Parameter.Tournament].TournamentName) ),',','') else Language.[Parameter.Tournament].TournamentName end as TournamentName,
			Parameter.Tournament.CategoryId, 
			 Language.[Parameter.Category].CategoryName,
			COUNT(Parameter.Tournament.TerminalTournamentId) as TournamentSportEventCount, ISNULL(Parameter.Category.Ispopular,0) as Ispopular
			,ISNULL(Parameter.Tournament.SequenceNumber,999) as SequenceNumber,
			 cast(1 as bit) as IsPopularTerminal,SUBSTRING(LOWER(Parameter.Iso.IsoName), 0, 3) AS IsoName,Parameter.Tournament.NewBetradarId as BetradarId
FROM         Parameter.Tournament with (nolock) INNER JOIN
                      Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId 
                       and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
                      Cache.Fixture AS Tournament_1 with (nolock) ON Parameter.Tournament.TournamentId = Tournament_1.TournamentId inner join
              Parameter.Category with (nolock)  on Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
                      Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN
					   Parameter.Iso On Parameter.Iso.IsoId=Parameter.Category.IsoId
                     
where (((Tournament_1.MatchDate<=DATEADD(MONTH,1,GETDATE()) or Parameter.Tournament.CategoryId in (13,1,15,14,16,99,103) or Parameter.Tournament.TournamentId=2682) and Tournament_1.SportId=@SportId)) and Tournament_1.MatchDate>GETDATE()
GROUP BY Parameter.Tournament.TerminalTournamentId, case when CHARINDEX(',', Language.[Parameter.Tournament].TournamentName)>0 then REPLACE( SUBSTRING(Language.[Parameter.Tournament].TournamentName , 1, CHARINDEX(',', Language.[Parameter.Tournament].TournamentName) ),',','') else Language.[Parameter.Tournament].TournamentName end, Parameter.Tournament.CategoryId,Language.[Parameter.Category].CategoryName,Parameter.Tournament.SequenceNumber,Parameter.Category.Ispopular,Parameter.Category.SequenceNumber,Parameter.Tournament.[IsPopularTerminal],Parameter.Iso.IsoName,Parameter.Tournament.NewBetradarId
order by   Parameter.Category.SequenceNumber asc,ISNULL((Parameter.Tournament.IsPopularTerminal),0) desc ,Language.[Parameter.Category].CategoryName,case when CHARINDEX(',', Language.[Parameter.Tournament].TournamentName)>0 then REPLACE( SUBSTRING(Language.[Parameter.Tournament].TournamentName , 1, CHARINDEX(',', Language.[Parameter.Tournament].TournamentName) ),',','') else Language.[Parameter.Tournament].TournamentName end

end
if (@CategoryId>0)
begin
 
	SELECT     Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId, COUNT(Tournament_1.MatchId) as TournamentSportEventCount
,ISNULL(Parameter.Tournament.SequenceNumber,999) as SequenceNumber, ISNULL(Parameter.Category.Ispopular,0) as Ispopular,
			ISNULL(Parameter.Tournament.[IsPopularTerminal],0) as IsPopularTerminal,SUBSTRING(LOWER(Parameter.Iso.IsoName), 0, 3) AS IsoName,Parameter.Tournament.NewBetradarId as BetradarId
FROM         Parameter.Tournament with (nolock) INNER JOIN
                      Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId 
                       and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
					    Parameter.Category with (nolock)  on Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
                      Cache.Fixture AS Tournament_1 with (nolock) ON Parameter.Tournament.TournamentId = Tournament_1.TournamentId INNER JOIN
					   Parameter.Iso On Parameter.Iso.IsoId=Parameter.Category.IsoId 
             
                     
where Tournament_1.MatchDate<=  case when @CategoryId in (13,1,15,14,16,99) then DATEADD(MONTH,2,GETDATE()) else DATEADD(MONTH,1,GETDATE()) end and  Tournament_1.MatchDate>GETDATE() and Parameter.Tournament.CategoryId=@CategoryId
GROUP BY Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId,Parameter.Tournament.SequenceNumber,Parameter.Tournament.[IsPopularTerminal],Parameter.Category.Ispopular,Parameter.Iso.IsoName
,Parameter.Tournament.NewBetradarId
end
if (@CategoryId=-10) --Tüm Populer Tournuvalar
begin
	SELECT     Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId, COUNT(Tournament_1.MatchId) as TournamentSportEventCount
,ISNULL(Parameter.Tournament.SequenceNumber,999) as SequenceNumber, ISNULL(Parameter.Category.Ispopular,0) as Ispopular,
			ISNULL(Parameter.Tournament.[IsPopularTerminal],0) as IsPopularTerminal,SUBSTRING(LOWER(Parameter.Iso.IsoName), 0, 3) AS IsoName,Parameter.Tournament.NewBetradarId as BetradarId
FROM         Parameter.Tournament with (nolock) INNER JOIN
                      Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId 
                       and Language.[Parameter.Tournament].LanguageId=@LangId INNER JOIN
					    Parameter.Category with (nolock)  on Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
                      Cache.Fixture  AS Tournament_1 with (nolock) ON Parameter.Tournament.TournamentId = Tournament_1.TournamentId INNER JOIN
					   Parameter.Iso On Parameter.Iso.IsoId=Parameter.Category.IsoId 
             
                     
where Tournament_1.MatchDate<=DATEADD(MONTH,1,GETDATE()) and  Tournament_1.MatchDate>GETDATE() and Parameter.Tournament.IsPopularTerminal=1
GROUP BY Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName, Parameter.Tournament.CategoryId,Parameter.Tournament.SequenceNumber,Parameter.Tournament.[IsPopularTerminal],Parameter.Category.Ispopular,Parameter.Iso.IsoName
,Parameter.Tournament.NewBetradarId
end


END


GO
