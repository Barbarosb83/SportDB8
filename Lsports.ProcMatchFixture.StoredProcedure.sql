USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Lsports].[ProcMatchFixture]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Lsports].[ProcMatchFixture]
@LsTournamentId bigint,
@LsMatchId bigint,
@TimeStamp datetime,
@EventStart datetime,
@EventDate datetime,
@EventEndDate datetime,
@EventName nvarchar(250),
@StatusInfo int,
@NeutralGround bit

AS

declare @VenueId int=0
declare @fixtureId int=0
declare @CuproundId int=0
BEGIN

Declare @TempTournamentId bigint=0
Declare @TempMonitoringMatchId bigint=0
declare @TournamentId int=0
declare @MatchId bigint=0
Declare @BetradarTournamentId bigint=0

if (@StatusInfo=4 or @StatusInfo=5 or @StatusInfo=6 or @StatusInfo=7)
	set @StatusInfo=1
else
	set @StatusInfo=2

if Not Exists (select Match.Match.MatchId from Match.Match with (nolock) where Match.Match.BetradarMatchId=@LsMatchId)
	begin
		if Not Exists (select  Archive.Match.MatchId from Archive.Match with (nolock) where Archive.Match.BetradarMatchId=@LsMatchId)
		begin
			select @TournamentId=Parameter.Tournament.TournamentId,
			 @BetradarTournamentId=Parameter.Tournament.BetradarTournamentId from Parameter.Tournament with (nolock)
			where Parameter.Tournament.LSId=@LsTournamentId
			
			insert Match.Match(TournamentId,BetradarMatchId,MonitoringMatchId,[TimeStamp])
			values(@TournamentId,@LsMatchId,@LsMatchId,@TimeStamp)
			set @MatchId=SCOPE_IDENTITY()
			
			execute Betradar.ProcMatchSettingInsert  @TournamentId,@MatchId
		end
		else
			begin
					select @MatchId=Match.MatchId,@TempTournamentId=Archive.Match.TournamentId,@TempMonitoringMatchId=Archive.Match.MonitoringMatchId
					from Archive.Match with (nolock) where Archive.Match.BetradarMatchId=@LsMatchId
			end
	end
else
	begin
				select @TournamentId=Parameter.Tournament.TournamentId,
				@BetradarTournamentId=Parameter.Tournament.BetradarTournamentId from Parameter.Tournament with (nolock)
		where  Parameter.Tournament.LSId=@LsTournamentId
		
		select @MatchId=Match.MatchId,@TempTournamentId=Match.Match.TournamentId,@TempMonitoringMatchId=Match.Match.MonitoringMatchId
		from Match.Match with (nolock) where Match.BetradarMatchId=@LsMatchId

		 
			update Match.Match set MonitoringMatchId=@LsMatchId,TournamentId=@TournamentId,[TimeStamp]=@TimeStamp
			where BetradarMatchId=@LsMatchId		
			
				
	end

	update Match.Setting  set StateId=@StatusInfo where MatchId=@MatchId

if not exists (select  Match.Fixture.FixtureId from Match.Fixture with (nolock) where Match.Fixture.MatchId=@MatchId)
	begin
		if not exists (select Archive.Fixture.FixtureId from Archive.Fixture with (nolock) where Archive.Fixture.MatchId=@MatchId)
			begin
				
					insert Match.Fixture(MatchId,Latitude,Longitude,EventStart,EventDate,EventEndDate,EventName,EventOff,HasStatistics,StreamingMatch,NeutralGround,LiveMultiCast,LiveScore,NumberOfSets,SeriesResult,SeriesResultWinner,AggregateScore,AggregateScoreWinner,NumberOfFrames,StatusInfoId,CupRoundId,Round,MatchNumber,VenueId)
					values (@MatchId,0,0,@EventStart,@EventDate,@EventEndDate,@EventName,0,0,'',@NeutralGround,0,0,0,'','','','',0,1,0,1,'',137)
				
					set @fixtureId=SCOPE_IDENTITY()
			end
			else
				begin
					
					select @fixtureId=Archive.Fixture.FixtureId from Archive.Fixture with (nolock) where Archive.Fixture.MatchId=@MatchId
				end
	end
else
	begin
		
	
	
		update  Match.Fixture set @fixtureId=FixtureId,NeutralGround=@NeutralGround
		where Match.Fixture.MatchId=@MatchId
		
	
	end

	return @fixtureId

END


GO
