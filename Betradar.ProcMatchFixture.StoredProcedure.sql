USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[ProcMatchFixture]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Betradar].[ProcMatchFixture]
@MatchId bigint,
@Latitude float,
@Longitude float,
@EventStart datetime,
@EventDate datetime,
@EventEndDate datetime,
@EventName nvarchar(250),
@EventOff bit,
@HasStatistics bit,
@StreamingMatch nvarchar(50),
@NeutralGround bit,
@LiveMultiCast bit,
@LiveScore bit,
@NumberOfSets bigint,
@SeriesResult nvarchar(10),
@SeriesResultWinner nvarchar(10),
@AggregateScore nvarchar(10),
@AggregateScoreWinner nvarchar(10),
@NumberOfFrames int,
@StatusInfo int,
@BetradarCupRoundId bigint,
@Round bigint,
@MatchNumber nvarchar(20),
@BetradarVenueId bigint,
@Venue nvarchar(max)
AS

declare @VenueId int=0
declare @fixtureId int=0
declare @CuproundId int=0
BEGIN

if(@BetradarVenueId is null)
	set @BetradarVenueId=0





if not exists (select  Match.Fixture.FixtureId from Match.Fixture with (nolock) where Match.Fixture.MatchId=@MatchId)
	begin
		if not exists (select Archive.Fixture.FixtureId from Archive.Fixture with (nolock) where Archive.Fixture.MatchId=@MatchId)
			begin
				--if not exists (select Parameter.Venue.BetradarVenueId from Parameter.Venue with (nolock) where BetradarVenueId=@BetradarVenueId)
				--	begin
				--		insert Parameter.Venue(BetradarVenueId,Venue,Latitude,Longitude)
				--		values (@BetradarVenueId,@Venue,@Latitude,@Longitude)
				--		set @VenueId=SCOPE_IDENTITY()
				--	end
				--else
				--	begin
				--		update Parameter.Venue set Venue=@Venue,Latitude=@Latitude,Longitude=@Longitude where BetradarVenueId=@BetradarVenueId
						
				--		select @VenueId=ISNULL(Parameter.Venue.VenueId,0) from Parameter.Venue with (nolock) where BetradarVenueId=@BetradarVenueId
				--	end
				
				if(@VenueId is null)
					set @VenueId=137
				
				--if(@BetradarCupRoundId is not null)
				--	begin
				--		select @CuproundId=Parameter.CupRound.CupRoundId from Parameter.CupRound with (nolock) where Parameter.CupRound.BetRadarCupRoundId=@BetradarCupRoundId
				--	end
				--else
					set @CuproundId=0
					
					insert Match.Fixture(MatchId,Latitude,Longitude,EventStart,EventDate,EventEndDate,EventName,EventOff,HasStatistics,StreamingMatch,NeutralGround,LiveMultiCast,LiveScore,NumberOfSets,SeriesResult,SeriesResultWinner,AggregateScore,AggregateScoreWinner,NumberOfFrames,StatusInfoId,CupRoundId,Round,MatchNumber,VenueId)
					values (@MatchId,@Latitude,@Longitude,@EventStart,@EventDate,@EventEndDate,@EventName,@EventOff,@HasStatistics,@StreamingMatch,@NeutralGround,@LiveMultiCast,@LiveScore,@NumberOfSets,@SeriesResult,@SeriesResultWinner,@AggregateScore,@AggregateScoreWinner,@NumberOfFrames,@StatusInfo,@CupRoundId,@Round,@MatchNumber,@VenueId)
				
					set @fixtureId=SCOPE_IDENTITY()
			end
			else
				begin
				update Parameter.Venue set Venue=@Venue,Latitude=@Latitude,Longitude=@Longitude where BetradarVenueId=@BetradarVenueId
						
						insert Match.Fixture(MatchId,Latitude,Longitude,EventStart,EventDate,EventEndDate,EventName,EventOff,HasStatistics,StreamingMatch,NeutralGround,LiveMultiCast,LiveScore,NumberOfSets,SeriesResult,SeriesResultWinner,AggregateScore,AggregateScoreWinner,NumberOfFrames,StatusInfoId,CupRoundId,Round,MatchNumber,VenueId)
					select MatchId,Latitude,Longitude,EventStart,EventDate,EventEndDate,EventName,EventOff,HasStatistics,StreamingMatch,NeutralGround,LiveMultiCast,LiveScore,NumberOfSets,SeriesResult,SeriesResultWinner,AggregateScore,AggregateScoreWinner,NumberOfFrames,StatusInfoId,CupRoundId,Round,MatchNumber,VenueId 
					from Archive.Fixture with (nolock) where Archive.Fixture.MatchId=@MatchId
				
					set @fixtureId=SCOPE_IDENTITY()
				end
	end
else
	begin
		--if not exists (select Parameter.Venue.BetradarVenueId from Parameter.Venue with (nolock) where BetradarVenueId=@BetradarVenueId) 
		--			begin
		--				insert Parameter.Venue(BetradarVenueId,Venue,Latitude,Longitude)
		--				values (@BetradarVenueId,@Venue,@Latitude,@Longitude)
		--				set @VenueId=SCOPE_IDENTITY()
		--			end
		--		else
		--			begin
		--				update Parameter.Venue set Venue=@Venue,Latitude=@Latitude,Longitude=@Longitude where BetradarVenueId=@BetradarVenueId
						
		--				select @VenueId=ISNULL(Parameter.Venue.VenueId,0) from Parameter.Venue with (nolock) where BetradarVenueId=@BetradarVenueId
		--			end
				
				--if(@VenueId is null)
				--	set @VenueId=137
	
				--if(@BetradarCupRoundId is not null)
				--	begin
				--		select @CuproundId=Parameter.CupRound.CupRoundId from Parameter.CupRound with (nolock) where Parameter.CupRound.BetRadarCupRoundId=@BetradarCupRoundId
				--	end
				--else
					set @CuproundId=0
			--select @fixtureId= FixtureId from Match.Fixture with (nolock) where MatchId=@MatchId
		update  Match.Fixture set @fixtureId= FixtureId,HasStatistics=@HasStatistics,StreamingMatch=@StreamingMatch,NeutralGround=@NeutralGround,LiveMultiCast=@LiveMultiCast,LiveScore=@LiveScore,NumberOfSets=@NumberOfSets,SeriesResult=@SeriesResult,SeriesResultWinner=@SeriesResultWinner,AggregateScore=@AggregateScore,AggregateScoreWinner=@AggregateScoreWinner,NumberOfFrames=@NumberOfFrames,CupRoundId=@CupRoundId,Round=@Round,MatchNumber=@MatchNumber,VenueId=@VenueId
		where Match.Fixture.MatchId=@MatchId
 
			--insert dbo.betslip values(@MatchId,'FixtureID'+cast(@fixtureId as nvarchar(50)),GETDATE())
	
	end

	return @fixtureId

END


GO
