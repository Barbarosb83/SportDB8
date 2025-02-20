USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentDateHighlights]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcTournamentDateHighlights] 
@SportId int,
@StartDate datetime,
@EndDate datetime

AS

BEGIN
SET NOCOUNT ON;


declare @TempTable table(MatchId bigint)

insert @TempTable
SELECT DISTINCT Customer.SlipOdd.MatchId
FROM         Customer.Slip with (nolock) INNER JOIN
                      Customer.SlipOdd with (nolock) ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId INNER JOIN
                      Cache.Fixture with (nolock) ON Customer.SlipOdd.MatchId = Cache.Fixture.MatchId
WHERE     (CAST(Customer.Slip.CreateDate AS Date) = CAST(GETDATE() AS date)) 
AND (CAST(Cache.Fixture.MatchDate AS date) >= CAST(@StartDate AS date)) 
and (CAST(Cache.Fixture.MatchDate AS date) <= CAST(@EndDate AS date)) and Customer.SlipOdd.BetTypeId=0



if(@SportId<>0)
begin
SELECT DISTINCT TOP 3 CAST(MatchDate AS Date) AS TournamentDate,0 as TournamentId
FROM         Cache.Fixture with (nolock)
WHERE     (SportId = @SportId) AND (CAST(MatchDate AS Date) >= CAST(@StartDate AS date)) AND  MatchDate  > GETDATE() AND 
                      (CAST(MatchDate AS Date) <= CAST(@EndDate AS date)) and MatchId in (SELECT  MatchId from @TempTable)
end
else
begin
SELECT DISTINCT TOP 3 CAST(MatchDate AS Date) AS TournamentDate,0 as TournamentId
FROM         Cache.Fixture with (nolock)
WHERE     (CAST(MatchDate AS Date) >= CAST(@StartDate AS date))  AND  MatchDate  > GETDATE() AND 
                      (CAST(MatchDate AS Date) <= CAST(@EndDate AS date)) and MatchId in (SELECT  MatchId from @TempTable)end

END


GO
