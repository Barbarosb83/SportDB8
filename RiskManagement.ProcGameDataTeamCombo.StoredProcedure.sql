USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataTeamCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameDataTeamCombo] 
@MatchId int,
@LangId int,
@UserName nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;




select [Language].[ParameterCompetitor].CompetitorId,[Language].[ParameterCompetitor].CompetitorName
from [Language].[ParameterCompetitor]
where  [Language].[ParameterCompetitor].LanguageId=@LangId and [Language].[ParameterCompetitor].CompetitorId in(

select Distinct Match.FixtureCompetitor.CompetitorId from Match.FixtureCompetitor
where Match.FixtureCompetitor.FixtureId in(
select Match.Fixture.FixtureId from Match.Fixture
where Match.Fixture.MatchId in(
select Match.Match.MatchId from Match.Match
where Match.TournamentId=(select top 1 Match.Match.TournamentId from Match.Match
where Match.MatchId=@MatchId) and Match.FixtureCompetitor.CompetitorId not in (15068,15118,15119,15069,15417,15994,16637,16681,17599,17598,16680,16636,15993,15416)
)
)
)
order by [Language].[ParameterCompetitor].CompetitorName

END


GO
