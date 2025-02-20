USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcMatchInfoNames_Manuel]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcMatchInfoNames_Manuel]

@BetradarMatchId bigint

AS
BEGIN


declare @BetradarSportId bigint
declare @BetradarCategoryId bigint
declare @BetradarTournamentId  bigint
declare @BetradarHomeTeamId bigint
declare @BetradarAwayTeamId bigint
declare @DateOfMatch datetime
declare @HomeTeam nvarchar(200)
declare @AwayTeam nvarchar(200)
declare @TournamentName nvarchar(200)
declare @CategoryName nvarchar(200)



select @BetradarSportId=Parameter.Sport.BetRadarSportId,@BetradarCategoryId=Parameter.Category.BetradarCategoryId,@BetradarTournamentId=Parameter.Tournament.NewBetradarId,@BetradarHomeTeamId=Parameter.Competitor.BetradarSuperId
,@BetradarAwayTeamId=cp2.BetradarSuperId,@DateOfMatch=Archive.FixtureDateInfo.MatchDate
,@HomeTeam=Parameter.Competitor.CompetitorName,@AwayTeam=cp2.CompetitorName,@TournamentName=Parameter.Tournament.TournamentName,@CategoryName=Parameter.Category.CategoryName
from Archive.Match INNER JOIN Archive.Fixture ON Archive.Match.MatchId=Archive.Fixture.MatchId INNER JOIN Archive.FixtureCompetitor as Comp1  ON
Archive.Fixture.FixtureId=Comp1.FixtureId and Comp1.TypeId=1 INNER JOIN Archive.FixtureCompetitor as Comp2 ON Archive.Fixture.FixtureId=Comp2.FixtureId and Comp2.TypeId=2 INNER JOIN 
Parameter.Tournament On Parameter.Tournament.TournamentId=Archive.Match.TournamentId INNER JOIN Parameter.Category ON Parameter.Category.CategoryId=Parameter.Tournament.CategoryId INNER JOIN
Parameter.Sport ON Parameter.Sport.SportId=Parameter.Category.SportId INNER JOIN Parameter.Competitor ON Comp1.CompetitorId=Parameter.Competitor.CompetitorId INNER JOIN Parameter.Competitor as CP2 ON cp2.CompetitorId=Comp2.CompetitorId
INNER JOIN Archive.FixtureDateInfo ON Archive.FixtureDateInfo.FixtureId=Archive.Fixture.FixtureId
where Archive.Match.BetradarMatchId=@BetradarMatchId




exec [Betradar].[Live.ProcMatchInfoNames]  @BetradarSportId,@BetradarCategoryId,@BetradarTournamentId,@BetradarHomeTeamId,@BetradarAwayTeamId,@DateOfMatch,@BetradarMatchId,@HomeTeam,@AwayTeam,@TournamentName,@CategoryName

END


GO
