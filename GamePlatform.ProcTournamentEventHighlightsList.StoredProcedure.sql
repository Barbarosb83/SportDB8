USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentEventHighlightsList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [GamePlatform].[ProcTournamentEventHighlightsList] 
@SportId int,
@TournamentDate datetime,
@LangId int

AS

BEGIN
SET NOCOUNT ON;

declare @TempTable table(MatchId bigint)

declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2


insert @TempTable
SELECT     DISTINCT Customer.SlipOdd.MatchId
FROM         Customer.Slip with (nolock) INNER JOIN
                      Customer.SlipOdd with (nolock) ON Customer.Slip.SlipId = Customer.SlipOdd.SlipId
WHERE     (CAST(Customer.Slip.CreateDate AS Date) = CAST(GETDATE() AS date)) AND (CAST(Customer.SlipOdd.EventDate AS date) = CAST(@TournamentDate AS date))

if(@SportId<>0)
begin

SELECT     Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                      Cache.Fixture.SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, 
                      Cache.Fixture.Odd1Visibility2 as Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, Cache.Fixture.Odd1Visibility3 as Odd3Visibility, Cache.Fixture.OddTypeCount, 
                      Cache.Fixture.TournamentId,Cache.Fixture.NeutralGround
					  ,null AS HasStreaming
FROM         Parameter.Competitor  AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp 
WHERE   Cache.Fixture.SportId  =@SportId AND 
                      (CAST(Cache.Fixture.MatchDate AS Date) = CAST(@TournamentDate AS date)) and Cache.Fixture.MatchId in (select MatchId from @TempTable)
                      and  Cache.Fixture.MatchDate>GETDATE()
ORDER BY Cache.Fixture.MatchDate
end
Else
begin

SELECT     Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                      Cache.Fixture.SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, 
                      Cache.Fixture.Odd1Visibility2 as Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, Cache.Fixture.Odd1Visibility3 as Odd3Visibility, Cache.Fixture.OddTypeCount, 
                      Cache.Fixture.TournamentId,Cache.Fixture.NeutralGround
					  ,null AS HasStreaming
FROM         Parameter.Competitor AS Competitor_1 with (nolock) INNER JOIN
                      Parameter.Competitor with (nolock) INNER JOIN
                      Language.ParameterCompetitor with (nolock) ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId and Language.ParameterCompetitor.LanguageId=@LangComp INNER JOIN
                      Cache.Fixture with (nolock) ON Parameter.Competitor.CompetitorId = Cache.Fixture.HomeTeam ON Competitor_1.CompetitorId = Cache.Fixture.AwayTeam INNER JOIN
                      Language.ParameterCompetitor  AS ParameterCompetitor_1 with (nolock) ON Competitor_1.CompetitorId = ParameterCompetitor_1.CompetitorId and ParameterCompetitor_1.LanguageId=@LangComp 
WHERE   (CAST(Cache.Fixture.MatchDate AS Date) = CAST(@TournamentDate AS date)) and Cache.Fixture.MatchId in (select MatchId from @TempTable) and  Cache.Fixture.MatchDate>GETDATE()
ORDER BY Cache.Fixture.MatchDate
end



END




GO
