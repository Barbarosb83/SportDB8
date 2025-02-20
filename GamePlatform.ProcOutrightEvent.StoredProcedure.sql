USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcOutrightEvent]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [GamePlatform].[ProcOutrightEvent] 
@MatchId bigint,
@LangId int

AS

BEGIN
SET NOCOUNT ON;


select top 5 Outrights.[Event].EventId as MatchId, Outrights.[Event].EventEndDate as MatchDate,
			[Language].[Parameter.Category].CategoryName +' '+ Outrights.[EventName].EventName AS EventName,Parameter.Sport.SportName,1 as OddTypeCount,
			cast(Outrights.[Event].EventEndDate as Date) as TournamentDate,cast(Outrights.[Event].EventDate as Date) as EventDate,cast(Outrights.[Event].EventStartDate as Date) as EventStartDate,
			(ROW_NUMBER() OVER(ORDER BY Outrights.[Event].EventId DESC)) as RowNum
		from Outrights.[Event] inner join Outrights.[EventName] on Outrights.[Event].EventId = Outrights.[EventName].EventId 
				and Outrights.[EventName].LanguageId=@LangId
		inner join Parameter.TournamentOutrights on Outrights.[Event].TournamentId=Parameter.TournamentOutrights.TournamentId
		inner join Parameter.[Category] on Parameter.[Category].CategoryId=Parameter.TournamentOutrights.CategoryId 
		inner join Parameter.Sport on Parameter.[Category].SportId=Parameter.Sport.SportId
		inner join [Language].[Parameter.Category] on [Language].[Parameter.Category].CategoryId=Parameter.[Category].CategoryId 
			and [Language].[Parameter.Category].LanguageId=1
Where  Outrights.[Event].EventDate>GETDATE() and Outrights.[Event].IsActive=1 and Outrights.[Event].EventId=@MatchId

END

GO
