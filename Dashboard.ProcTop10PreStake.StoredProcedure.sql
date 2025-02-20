USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Dashboard].[ProcTop10PreStake]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Dashboard].[ProcTop10PreStake] 
@Username nvarchar(50),
@LangId int
AS

BEGIN
SET NOCOUNT ON;



declare @TempMatch table (MatchId bigint,Amount money)



insert @TempMatch
select top 50 MatchId,SUM(Customer.Slip.Amount) from Customer.SlipOdd with (nolock) INNER JOIN Customer.Slip with (nolock) On Customer.Slip.SlipId=Customer.SlipOdd.SlipId where BetTypeId=0 and Customer.Slip.SlipStateId=1 GROUP BY MatchId OrDER BY SUM(Customer.Slip.Amount) desc 
 

select top 10 Match.MatchId, Parameter.Competitor.CompetitorName +' - '+CompetiTip_1.CompetitorName AS MatchName,TMP.Amount --,Match.Setting.StakeLimit*0.6
FROM Parameter.Competitor INNER JOIN 
                       Match.FixtureCompetitor AS FixtureCompetiTip_1 with (nolock) ON Parameter.Competitor.CompetitorId = FixtureCompetiTip_1.CompetitorId INNER JOIN 
                       Match.Match with (nolock) INNER JOIN 
                       Match.Fixture with (nolock) ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN 
                       Match.FixtureDateInfo with (nolock) ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId AND Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId ON  
                       FixtureCompetiTip_1.FixtureId = Match.Fixture.FixtureId INNER JOIN
                       Parameter.Competitor AS CompetiTip_1 with (nolock) INNER JOIN 
                       Match.FixtureCompetitor with (nolock) ON CompetiTip_1.CompetitorId = Match.FixtureCompetitor.CompetitorId ON  
                       Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId INNER JOIN 
                       --Match.Setting with (nolock) On Match.Setting.MatchId=Match.Match.MatchId INNER JOIN
                       
					   Parameter.Tournament with (nolock) ON Match.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN 
                       Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                       Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId  
    
						 INNER JOIN @TempMatch as TMP ON TMP.MatchId=Match.MatchId
WHERE (FixtureCompetiTip_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) 
--and  Match.Setting.StakeLimit*0.6<Tmp.Amount
 ORDER BY TMP.Amount desc

END


GO
