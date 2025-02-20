USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcEventExstraInfo]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcEventExstraInfo] 
@MatchId bigint,
@LangId int
AS

BEGIN
SET NOCOUNT ON;



select Match.Fixture.NumberOfFrames,Match.Fixture.NumberOfSets
,Match.Fixture.MatchNumber 
,Match.Fixture.SeriesResult
,Match.Fixture.SeriesResultWinner
,Match.Fixture.[Round]
, Match.Fixture.AggregateScore
,Match.Fixture.AggregateScoreWinner
,ISNULL(Match.Fixture.Comment,'')+' '+case when Parameter.CupRound.CupRoundName<>'' then 'Cup Round :'+Parameter.CupRound.CupRoundName else '' end as Comment
,Match.Fixture.StreamingMatch
,Parameter.Venue.Venue+' ' + Language.[Parameter.Category].CategoryName +'-' +Language.[Parameter.Tournament].SuperTournamentName as Venue
,Parameter.Venue.Latitude
,Parameter.Venue.Longitude
from Match.Fixture with (nolock) INNER JOIN
Parameter.Venue with (nolock) ON Parameter.Venue.VenueId=Match.Fixture.VenueId INNER JOIN
Parameter.CupRound with (nolock) ON Parameter.CupRound.CupRoundId=Match.Fixture.CupRoundId INNER JOIN 
Match.Match with (nolock) ON Match.Match.MatchId=Match.Fixture.MatchId INNER JOIN
Parameter.Tournament with (nolock) ON Parameter.Tournament.TournamentId=Match.Match.TournamentId INNER JOIN
Language.[Parameter.Category] with (nolock) On Language.[Parameter.Category].CategoryId=Parameter.Tournament.CategoryId INNER JOIN
Language.[Parameter.Tournament] with (nolock) ON Language.[Parameter.Tournament].TournamentId=Match.Match.TournamentId
where Match.Fixture.MatchId=@MatchId and Language.[Parameter.Category].LanguageId=@LangId and Language.[Parameter.Tournament].LanguageId=@LangId

END


GO
