USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcEventExstraInfo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcEventExstraInfo] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;



select Match.Fixture.FixtureId,Match.Fixture.NumberOfFrames,Match.Fixture.NumberOfSets
,Match.Fixture.MatchNumber 
,Match.Fixture.SeriesResult
,Match.Fixture.SeriesResultWinner
,Match.Fixture.[Round]
, Match.Fixture.AggregateScore
,Match.Fixture.AggregateScoreWinner
,Match.Fixture.Comment
,Match.Fixture.StreamingMatch
,Parameter.Venue.Venue
,Parameter.Venue.Latitude
,Parameter.Venue.Longitude
from Match.Fixture INNER JOIN
Parameter.Venue ON Parameter.Venue.VenueId=Match.Fixture.VenueId
where Match.Fixture.MatchId=@MatchId


END


GO
