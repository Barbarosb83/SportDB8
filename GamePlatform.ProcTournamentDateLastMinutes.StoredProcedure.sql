USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentDateLastMinutes]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcTournamentDateLastMinutes] 
@SportId int,
@StartDate datetime,
@EndDate datetime

AS

BEGIN
SET NOCOUNT ON;


if(@SportId<>0)
begin
SELECT DISTINCT TOP (5) CAST(MatchDate AS Date) as TournamentDate,0 as TournamentId 
FROM         Cache.Fixture with (nolock)
WHERE     (SportId = @SportId) AND (CAST(MatchDate AS Date) = CAST(GETDATE() AS date)) AND DATEDIFF(MINUTE,GETDATE(),MatchDate)>=0 AND DATEDIFF(MINUTE,GETDATE(),MatchDate)<=15
AND  MatchDate> GETDATE()
end
else
begin
SELECT DISTINCT TOP (5) CAST(MatchDate AS Date) as TournamentDate,0 as TournamentId 
FROM         Cache.Fixture with (nolock)
WHERE     (CAST(MatchDate AS Date) = CAST(GETDATE() AS date)) AND DATEDIFF(MINUTE,GETDATE(),MatchDate)>=0 AND DATEDIFF(MINUTE,GETDATE(),MatchDate)<=15
AND  MatchDate> GETDATE()
end

END


GO
