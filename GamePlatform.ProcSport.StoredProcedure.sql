USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcSport]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [GamePlatform].[ProcSport] 
@LangId int,
@EndDay int
AS
BEGIN
SET NOCOUNT ON;
if @EndDay=300
	set @EndDay=360


	declare @TempSport table (SportId int,SportName Nvarchar(100),SportEventCount int,OrginalName nvarchar(100))

	
 if(@EndDay=24)
		set @EndDay=DATEDIFF(HOUR,DATEADD(HOUR,2,GETDATE()),cast(cast(DATEADD(HOUR,2,GETDATE()) as DATE) as nvarchar(20))+' 23:59:00.000')


insert @TempSport
SELECT     Sport_1.SportId, Language.[Parameter.Sport].SportName, COUNT(Sport_1.MatchId) as SportEventCount, 
Parameter.Sport.SportName AS OrginalName
FROM         Parameter.Sport with (nolock) INNER JOIN
            Language.[Parameter.Sport] with (nolock) ON
             Parameter.Sport.SportId = Language.[Parameter.Sport].SportId 
             and Language.[Parameter.Sport].LanguageId=@LangId INNER JOIN
            Cache.Fixture AS Sport_1 with (nolock) ON Parameter.Sport.SportId = Sport_1.SportId
Where Sport_1.MatchDate<=DATEADD(HOUR,@EndDay,GETDATE()) and Sport_1.MatchDate>GETDATE()
GROUP BY  Parameter.Sport.SquanceNumber,Sport_1.SportId, Language.[Parameter.Sport].SportName,Parameter.Sport.SportName
order by  Parameter.Sport.SquanceNumber

--insert @TempSport
--select Parameter.Sport.SportId
--,   COUNT(Outrights.[Event].EventId) as SportEventCount, 
--Parameter.Sport.SportName AS OrginalName
--from Outrights.[Event] INNER JOIN 
--Parameter.TournamentOutrights  On Parameter.TournamentOutrights.TournamentId=Outrights.[Event].TournamentId 
----and Outrights.[Event].IsActive=1 
--INNER JOIN 
--Parameter.Category On Parameter.Category.CategoryId=Parameter.TournamentOutrights.CategoryId INNER JOIN
--Parameter.Sport ON Parameter.Sport.SportId=Parameter.Category.SportId  INNER JOIN
-- Language.[Parameter.Sport] with (nolock) ON
--             Parameter.Sport.SportId = Language.[Parameter.Sport].SportId 
--             and Language.[Parameter.Sport].LanguageId=2 
--			 and Parameter.Sport.SportId not in (select SportId from @TempSport )
--where  Outrights.[Event].EventEndDate>GETDATE()
--GROUP BY  Parameter.Sport.SquanceNumber,Parameter.Sport.SportId
----, Language.[Parameter.Sport].SportName
--,Parameter.Sport.SportName
--order by  Parameter.Sport.SquanceNumber

 insert @TempSport
select  Parameter.Sport.SportId, Language.[Parameter.Sport].SportName, COUNT( DISTINCT Parameter.TournamentOutrights.TournamentId) as SportEventCount, 
Parameter.Sport.SportName AS OrginalName from Parameter.TournamentOutrights INNER JOIN 
Parameter.Category ON Parameter.TournamentOutrights.CategoryId=Parameter.Category.CategoryId INNER JOIN Parameter.Sport On
Parameter.Sport.SportId=Parameter.Category.SportId and Parameter.Sport.IsActive=1  and Parameter.Sport.SportId not in (select SportId from @TempSport ) INNER JOIN
 Language.[Parameter.Sport] with (nolock) ON
             Parameter.Sport.SportId = Language.[Parameter.Sport].SportId 
             and Language.[Parameter.Sport].LanguageId=@LangId
where Parameter.TournamentOutrights.TournamentId in (

SELECT    DISTINCT   TournamentId
FROM            Outrights.Event INNER JOIN Outrights.Odd ON Outrights.Odd.MatchId=Outrights.Event.EventId where IsActive=1 and EventEndDate>GETDATE())
GROUP BY Parameter.Sport.SportId, Language.[Parameter.Sport].SportName,Parameter.Sport.SportName 

select * from @TempSport

END


GO
