USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcMatchEvent]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [GamePlatform].[ProcMatchEvent] 
@MatchId bigint,
@LangId int

AS

BEGIN
SET NOCOUNT ON;

 declare @LangComp int=@LangId


if(@LangComp not in (2,3,6))
	set @LangComp=2

SELECT     Cache.Fixture.BetradarMatchId,Cache.Fixture.MatchId, Cache.Fixture.MatchDate,
  Language.ParameterCompetitor.CompetitorName+'-'+ParameterCompetitor_1.CompetitorName AS EventName, 
                      Cache.Fixture.SportName, Cache.Fixture.OddId1, Cache.Fixture.OddValue1, Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2, 
                      Cache.Fixture.Odd1Visibility2 as Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3, Cache.Fixture.Odd1Visibility3 as Odd3Visibility, Cache.Fixture.OddTypeCount, 
                      Cache.Fixture.TournamentId,Cache.Fixture.MatchDate as TournamentDate,Cache.Fixture.NeutralGround,
					  Match.Code.Code
					  ,PCH.BetradarSuperId as HomeTeamId
					  ,PCA.BetradarSuperId as AwayTeamId
FROM         
                    Cache.Fixture with (nolock) INNER JOIN 
                       Language.ParameterCompetitor with (nolock)  ON   Language.ParameterCompetitor.CompetitorId=Cache.Fixture.HomeTeam 
					   and Language.ParameterCompetitor.LanguageId=@LangComp     INNER JOIN
					   Parameter.Competitor PCH with (nolock) ON PCH.CompetitorId=Cache.Fixture.HomeTeam INNER JOIN
                      Language.ParameterCompetitor AS ParameterCompetitor_1 with (nolock) ON  ParameterCompetitor_1.CompetitorId=Cache.Fixture.AwayTeam and ParameterCompetitor_1.LanguageId=@LangComp INNER JOIN
					  Parameter.Competitor PCA with (nolock) ON PCA.CompetitorId=Cache.Fixture.AwayTeam INNER JOIN
					  Match.Code with (nolock) ON Match.Code.MatchId=Cache.Fixture.MatchId and Match.Code.BetTypeId=0
Where  Cache.Fixture.MatchId=@MatchId  and Cache.Fixture.MatchDate>GETDATE()
--order by Cache.Fixture.MatchDate

END


GO
