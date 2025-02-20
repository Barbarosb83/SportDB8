USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Cache].[FillResults]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Cache].[FillResults]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @temptable  table (MatchId bigint,TournamentId int, CategoryId int, SportId int, HomeTeamId bigint,AwayTeamId bigint,FT nvarchar(max),HT nvarchar(max),MatchDate datetime)
    
    insert @temptable
    SELECT   DISTINCT  Archive.[Live.Event].EventId, Archive.[Live.Event].TournamentId, Parameter.Tournament.CategoryId, Parameter.Category.SportId, Archive.[Live.Event].HomeTeam AS HomeTeamId, 
                      Archive.[Live.Event].AwayTeam AS AwayTeamId
					  ,CAST( ISNULL((Select SUM(ScoreCardType) from Archive.[Live.ScoreCardSummary] as LSS where LSS.EventId=FullTimeScore.EventId and LSS.ScoreCardType=1 and AffectedTeam=1 and IsCanceled=0 ),0) as nvarchar(10))+':'+cast(ISNULL((Select SUM(ScoreCardType) from Archive.[Live.ScoreCardSummary] as LSS where LSS.EventId=FullTimeScore.EventId and LSS.ScoreCardType=1 and AffectedTeam=2 and IsCanceled=0 ),0) as nvarchar(20)) AS FT, 
                      cast(ISNULL((Select SUM(ScoreCardType) from Archive.[Live.ScoreCardSummary] as LSS where LSS.EventId=FullTimeScore.EventId and LSS.ScoreCardType=1 and AffectedTeam=1 and IsCanceled=0 and LSS.[Time]<=45 ),0) as nvarchar(10))+':'+cast(ISNULL((Select SUM(ScoreCardType) from Archive.[Live.ScoreCardSummary] as LSS where LSS.EventId=FullTimeScore.EventId and LSS.ScoreCardType=1 and AffectedTeam=2 and IsCanceled=0  and LSS.[Time]<=45),0) as nvarchar(10)) AS HT, Archive.[Live.Event].EventDate
FROM        Archive.[Live.ScoreCardSummary] AS FullTimeScore with (nolock) INNER JOIN
                      Archive.[Live.Event] with (nolock) ON FullTimeScore.EventId = Archive.[Live.Event].EventId INNER JOIN
                      Archive.[Live.EventDetail] with (nolock) ON Archive.[Live.EventDetail].BetradarMatchIds = Archive.[Live.Event].BetradarMatchId INNER JOIN
                      Parameter.Tournament with (nolock) ON Archive.[Live.Event].TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                      Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId  
                  
WHERE       (Archive.[Live.Event].EventDate>DATEADD(DAY,-2,GETDATE()))
order by Archive.[Live.Event].EventDate  desc
    
--    insert @temptable
--    SELECT     Archive.Match.MatchId, Archive.Match.TournamentId, Parameter.Tournament.CategoryId, Parameter.Category.SportId, HomeTeam.CompetitorId AS HomeTeamId, 
--                      AwayTeam.CompetitorId AS AwayTeamId, FullTimeScore.Score AS FT, 
--                      isnull(HalfTimeScore.Score,'') AS HT, Archive.FixtureDateInfo.MatchDate
--FROM         Archive.ScoreInfo AS FullTimeScore with (nolock) INNER JOIN
--                      Archive.Fixture with (nolock) ON FullTimeScore.MatchId = Archive.Fixture.MatchId INNER JOIN
--                      Archive.Match with (nolock) ON Archive.Fixture.MatchId = Archive.Match.MatchId INNER JOIN
--                      Parameter.Tournament with (nolock) ON Archive.Match.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
--                      Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND 
--                      Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
--                      Archive.FixtureCompetitor AS HomeTeam with (nolock) ON Archive.Fixture.FixtureId = HomeTeam.FixtureId INNER JOIN
--                      Archive.FixtureCompetitor AS AwayTeam with (nolock) ON Archive.Fixture.FixtureId = AwayTeam.FixtureId AND Archive.Fixture.FixtureId = AwayTeam.FixtureId AND 
--                      Archive.Fixture.FixtureId = AwayTeam.FixtureId INNER JOIN
--                      Archive.FixtureDateInfo with (nolock) ON Archive.Fixture.FixtureId = Archive.FixtureDateInfo.FixtureId left outer JOIN
--                      Archive.ScoreInfo AS HalfTimeScore with (nolock) ON Archive.Match.MatchId = HalfTimeScore.MatchId and  HalfTimeScore.MatchTimeTypeId = 1
--WHERE      (FullTimeScore.MatchTimeTypeId = 2) AND (AwayTeam.TypeId = 2) AND (HomeTeam.TypeId = 1) and (Archive.FixtureDateInfo.MatchDate>DATEADD(DAY,-15,GETDATE()))
--order by Archive.FixtureDateInfo.MatchDate  desc
    
    truncate table Cache.Result
    
    insert Cache.Result ([EventDate]
           ,[Team1Id]
           ,[Team2Id]
           ,[FTScore]
           ,[HTScore]
           ,[SportId]
           ,[CategoryId]
           ,[TournamentId]
           ,[MatchId]) 
    select MatchDate , HomeTeamId ,AwayTeamId ,FT ,HT ,
    SportId ,CategoryId,TournamentId , 
     MatchId
    from @temptable
    
END


GO
