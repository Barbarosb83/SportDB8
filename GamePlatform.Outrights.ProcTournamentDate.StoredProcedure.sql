USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[Outrights.ProcTournamentDate]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[Outrights.ProcTournamentDate] 
@SportId int

AS

BEGIN
SET NOCOUNT ON;

if(@SportId=0)
begin

Select  cast(Outrights.[Event].EventEndDate as Date) as TournamentDate from Outrights.[Event]
inner join Parameter.TournamentOutrights on Outrights.[Event].TournamentId=Parameter.TournamentOutrights.TournamentId
		inner join Parameter.[Category] on Parameter.[Category].CategoryId=Parameter.TournamentOutrights.CategoryId 
		inner join Parameter.Sport on Parameter.[Category].SportId=Parameter.Sport.SportId
group by cast(Outrights.[Event].EventEndDate as Date)
order by TournamentDate

end
else
begin

Select  cast(Outrights.[Event].EventEndDate as Date) as TournamentDate from Outrights.[Event]
inner join Parameter.TournamentOutrights on Outrights.[Event].TournamentId=Parameter.TournamentOutrights.TournamentId
		inner join Parameter.[Category] on Parameter.[Category].CategoryId=Parameter.TournamentOutrights.CategoryId 
		inner join Parameter.Sport on Parameter.[Category].SportId=Parameter.Sport.SportId
		where Parameter.Sport.SportId=@SportId
group by cast(Outrights.[Event].EventEndDate as Date)
order by TournamentDate

end

END


GO
