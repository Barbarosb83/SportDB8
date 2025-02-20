USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Live.ProcPreLiveInsert]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Betradar].[Live.ProcPreLiveInsert]
@BetradarMatchId bigint 

AS
 
BEGIN


if not exists(Select EventId from Live.Event where BetradarMatchId=@BetradarMatchId)
begin

declare @SportId int
declare @CategoryId bigint
declare @TournamentId bigint
declare @HomeTeam bigint
declare @AwayTeam bigint
declare @MAtchDate datetime
if exists (select TournamentId fRom Archive.Match where BetradarMatchId=@BetradarMatchId)
begin
select @TournamentId=NewBetradarId  from Parameter.Tournament where TournamentId=(select TournamentId fRom Archive.Match where BetradarMatchId=@BetradarMatchId)
select @CategoryId=BetradarCategoryId from Parameter.Category where CategoryId=(select CategoryId from Parameter.Tournament where TournamentId=(select TournamentId fRom Archive.Match where BetradarMatchId=@BetradarMatchId))
select @MAtchDate=MatchDate from Archive.FixtureDateInfo where FixtureId=(select FixtureId from Archive.Fixture where MatchId=(select MatchId fRom Archive.Match where BetradarMatchId=@BetradarMatchId))
select @HomeTeam=BetradarSuperId  from Parameter.Competitor where CompetitorId=(select CompetitorId from Archive.FixtureCompetitor where FixtureId=(select FixtureId from Archive.Fixture where MatchId=(select MatchId fRom Archive.Match where BetradarMatchId=@BetradarMatchId)) and TypeId=1)
select @AwayTeam= BetradarSuperId   from Parameter.Competitor where CompetitorId=(select CompetitorId from Archive.FixtureCompetitor where FixtureId=(select FixtureId from Archive.Fixture where MatchId=(select MatchId fRom Archive.Match where BetradarMatchId=@BetradarMatchId)) and TypeId=2)
select @SportId=BetRadarSportId from Parameter.Sport where SportId = (select SportId from Parameter.Category where CategoryId=(select CategoryId from Parameter.Tournament where TournamentId=(select TournamentId fRom Archive.Match where BetradarMatchId=@BetradarMatchId)))
 end
else
begin
select @TournamentId=NewBetradarId  from Parameter.Tournament where TournamentId=(select TournamentId fRom Match.Match where BetradarMatchId=@BetradarMatchId)
select @CategoryId=BetradarCategoryId from Parameter.Category where CategoryId=(select CategoryId from Parameter.Tournament where TournamentId=(select TournamentId fRom Match.Match where BetradarMatchId=@BetradarMatchId))
select @MAtchDate=MatchDate from Match.FixtureDateInfo where FixtureId=(select FixtureId from Match.Fixture where MatchId=(select MatchId fRom Match.Match where BetradarMatchId=@BetradarMatchId))
select @HomeTeam=BetradarSuperId  from Parameter.Competitor where CompetitorId=(select CompetitorId from Match.FixtureCompetitor where FixtureId=(select FixtureId from Match.Fixture where MatchId=(select MatchId fRom Match.Match where BetradarMatchId=@BetradarMatchId)) and TypeId=1)
select @AwayTeam= BetradarSuperId   from Parameter.Competitor where CompetitorId=(select CompetitorId from Match.FixtureCompetitor where FixtureId=(select FixtureId from Match.Fixture where MatchId=(select MatchId fRom Match.Match where BetradarMatchId=@BetradarMatchId)) and TypeId=2)
select @SportId=BetRadarSportId from Parameter.Sport where SportId = (select SportId from Parameter.Category where CategoryId=(select CategoryId from Parameter.Tournament where TournamentId=(select TournamentId fRom Match.Match where BetradarMatchId=@BetradarMatchId)))
end
if(@SportId is not null)
exec [Betradar].[Live.ProcMatchInfo] @SportId,@CategoryId,@TournamentId,@HomeTeam,@AwayTeam,@MAtchDate,@BetradarMatchId
end

END


GO
