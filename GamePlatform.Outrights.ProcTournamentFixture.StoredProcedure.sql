USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[Outrights.ProcTournamentFixture]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[Outrights.ProcTournamentFixture] 
@TournamentId int,
@PageNo int,
@SportId int,
@CategoryId int,
@LangId int

AS


BEGIN
SET NOCOUNT ON;

declare @PageSize bigint=2000

if (@SportId=0)
begin
;with queryresult as (
select distinct Outrights.[Event].EventId as MatchId, Outrights.[Event].EventEndDate as MatchDate,
			[Language].[Parameter.Category].CategoryName +' '+ Outrights.[EventName].EventName AS EventName,Parameter.Sport.SportName,1 as OddTypeCount,
			cast(Outrights.[Event].EventEndDate as Date) as TournamentDate,Outrights.[Event].EventDate as EventDate,cast(Outrights.[Event].EventStartDate as Date) as EventStartDate,
			(ROW_NUMBER() OVER(ORDER BY Outrights.[Event].EventId DESC)) as RowNum
		from Outrights.[Event] inner join Outrights.[EventName] on Outrights.[Event].EventId = Outrights.[EventName].EventId 
				and Outrights.[EventName].LanguageId=@LangId
		inner join Parameter.TournamentOutrights on Outrights.[Event].TournamentId=Parameter.TournamentOutrights.TournamentId
		inner join Parameter.[Category] on Parameter.[Category].CategoryId=Parameter.TournamentOutrights.CategoryId 
		inner join Parameter.Sport on Parameter.[Category].SportId=Parameter.Sport.SportId 
		inner join [Language].[Parameter.Category] on [Language].[Parameter.Category].CategoryId=Parameter.[Category].CategoryId 
			and [Language].[Parameter.Category].LanguageId=@LangId
Where Parameter.[Category].CategoryId=@CategoryId and Outrights.[Event].EventEndDate>DATEADD(MINUTE,1, GETDATE()) and Outrights.[Event].IsActive=1 and Parameter.TournamentOutrights.IsActive=1 --and Parameter.Sport.SportId=@SportId
)
SELECT     MatchId,  MatchDate,EventName, SportName, OddTypeCount, TournamentDate,EventDate,EventStartDate, SportName, RowNum, (select MAX(RowNum) from queryresult) as TotalRecord
from queryresult 
--where RowNum between (@PageNo*@PageSize) and ((@PageNo+1)*@PageSize)
order by EventDate,TournamentDate,EventName
		end
		else
		begin
;with queryresult as (
select distinct  Outrights.[Event].EventId as MatchId, Outrights.[Event].EventEndDate as MatchDate,
			Outrights.EventName.EventName AS EventName,Parameter.Sport.SportName,1 as OddTypeCount,
			cast(Outrights.[Event].EventEndDate as Date) as TournamentDate,Outrights.[Event].EventDate as EventDate,cast(Outrights.[Event].EventStartDate as Date) as EventStartDate,
			(ROW_NUMBER() OVER(ORDER BY Outrights.[Event].EventId DESC)) as RowNum
		from Outrights.[Event] 
		inner join Outrights.EventName on Outrights.EventName.EventId=Outrights.[Event].EventId and Outrights.EventName.LanguageId=@LangId	
		inner join Parameter.TournamentOutrights on Outrights.[Event].TournamentId=Parameter.TournamentOutrights.TournamentId
		inner join Language.[Parameter.TournamentOutrights] ON Language.[Parameter.TournamentOutrights].TournamentId=Parameter.TournamentOutrights.TournamentId
		inner join Parameter.[Category] on Parameter.[Category].CategoryId=Parameter.TournamentOutrights.CategoryId
		inner join Parameter.Sport on Parameter.[Category].SportId=Parameter.Sport.SportId
		inner join [Language].[Parameter.Category] on [Language].[Parameter.Category].CategoryId=Parameter.[Category].CategoryId 
			and [Language].[Parameter.Category].LanguageId=@LangId  and Language.[Parameter.TournamentOutrights].LanguageId=@LangId
Where Parameter.[Category].CategoryId=@CategoryId and Outrights.[Event].EventEndDate>DATEADD(MINUTE,1, GETDATE()) and Parameter.Sport.SportId=@SportId and Outrights.[Event].IsActive=1
)

SELECT     MatchId,  MatchDate,EventName, SportName, OddTypeCount, TournamentDate,EventDate,EventStartDate, SportName, RowNum, (select MAX(RowNum) from queryresult) as TotalRecord
from queryresult 
--where RowNum between (@PageNo*@PageSize) and ((@PageNo+1)*@PageSize)
order by EventDate,TournamentDate,EventName
		end


END


GO
