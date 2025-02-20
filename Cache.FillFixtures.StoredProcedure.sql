USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Cache].[FillFixtures]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Cache].[FillFixtures]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	Create table  #temptable (
	
	[BetradarMatchId] [bigint],
	[MatchId] [bigint] NOT NULL,
	[MatchDate] [datetime] NOT NULL,
	[HomeTeam] [int] NOT NULL,
	[AwayTeam] [int] NOT NULL,
	[SportName] [nvarchar](50) NOT NULL,
	[OddId1] [bigint] NULL,
	[OddValue1] [float] NULL,
	[Odd1Visibility] [nchar](6) NULL,
	[OddId2] [bigint] NULL,
	[OddValue2] [float] NULL,
	[Odd1Visibility2] [nchar](6) NULL,
	[OddId3] [bigint] NULL,
	[OddValue3] [float] NULL,
	[Odd1Visibility3] [nchar](6) NULL,
	[OddTypeCount] [int] NULL,
	[TournamentId] [int] NOT NULL,[IsPopular] [bit] NULL,[SportId] [int] NOT NULL,[NeutralGround] [bit] NULL  )
 
    
    SET NOCOUNT ON;

declare @MaxDayPeriod int=500

--select @MaxDayPeriod=General.Setting.MaxDayPeriod from General.Setting with (nolock) where General.Setting.SettingId=1

insert into #temptable
SELECT   Match.Match.BetradarMatchId, Match.Match.MatchId, Match.FixtureDateInfo.MatchDate, 
                      FixtureCompetiTip_1.CompetitorId as HomeTeam,Match.FixtureCompetitor.CompetitorId as AwayTeam, Parameter.Sport.SportName, 
                      Odd_3.OddId AS OddId1, Odd_3.OddValue AS OddValue1, CASE WHEN Odd_3.StateId <> 2 THEN 'hidden' ELSE '' END AS Odd1Visibility, 
                      Odd_1.OddId AS OddId2, Odd_1.OddValue AS OddValue2, CASE WHEN (Odd_1.StateId <> 2 OR 
                       Parameter.Sport.SportId in (2,19,33,36,11,35,17,31,26,9,3,5,20,14,16,18,12,23,25,34,15,32,40,35)) THEN 'hidden' ELSE '' END AS Odd2Visibility, Odd_2.OddId AS OddId3, Odd_2.OddValue AS OddValue3, 
                      CASE WHEN Odd_2.StateId <> 2 THEN 'hidden' ELSE '' END AS Odd3Visibility, 
							(select COUNT(DISTINCT Match.Odd.OddsTypeId) from Match.Odd with (nolock) INNER JOIN Parameter.OddTypeGroupOddType On Match.Odd.OddsTypeId=Parameter.OddTypeGroupOddType.OddTypeId and Parameter.OddTypeGroupOddType.OddTypeGroupId=12 where MatchId= Match.Match.MatchId) AS OddTypeCount, Parameter.Tournament.TournamentId AS TournamentId,Match.Setting.IsPopular,Parameter.Sport.SportId,Match.Fixture.NeutralGround
FROM         Parameter.Tournament with (nolock) INNER JOIN
                      Match.FixtureCompetitor AS FixtureCompetiTip_1 with (nolock) INNER JOIN
                      Match.Match with (nolock) INNER JOIN
                      Match.Fixture with (nolock) ON Match.Match.MatchId = Match.Fixture.MatchId INNER JOIN
                      Match.FixtureDateInfo with (nolock) ON Match.Fixture.FixtureId = Match.FixtureDateInfo.FixtureId ON 
                      FixtureCompetiTip_1.FixtureId = Match.Fixture.FixtureId INNER JOIN
                      Match.FixtureCompetitor with (nolock) ON Match.Fixture.FixtureId = Match.FixtureCompetitor.FixtureId AND 
                      FixtureCompetiTip_1.FixtureId = Match.FixtureCompetitor.FixtureId ON Parameter.Tournament.TournamentId = Match.Match.TournamentId INNER JOIN
                      Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                      Parameter.Sport with (nolock) on Parameter.Sport.SportId=Parameter.Category.SportId INNER JOIN
                      Match.Setting with (nolock) ON Match.Match.MatchId = Match.Setting.MatchId INNER JOIN
                      Match.Odd AS Odd_3 with (nolock) ON Match.Match.MatchId = Odd_3.MatchId  INNER JOIN
                      Match.Odd AS Odd_1 with (nolock) ON Match.Match.MatchId = Odd_1.MatchId  AND Odd_3.MatchId = Odd_1.MatchId INNER JOIN
                      Match.Odd AS Odd_2 with (nolock) ON Match.Match.MatchId = Odd_2.MatchId  AND Odd_1.MatchId = Odd_2.MatchId AND Odd_3.MatchId = Odd_2.MatchId INNER JOIN
                      GamePlatform.[Parameter.GamePlatformTopOdd] with (nolock) ON Odd_3.ParameterOddId = GamePlatform.[Parameter.GamePlatformTopOdd].ParameterOddId INNER JOIN
                      GamePlatform.[Parameter.GamePlatformTopOdd]  AS [Parameter.GamePlatformTopOdd_1] with (nolock) ON 
                      Odd_1.ParameterOddId = [Parameter.GamePlatformTopOdd_1].ParameterOddId AND 
                      GamePlatform.[Parameter.GamePlatformTopOdd].SportId = [Parameter.GamePlatformTopOdd_1].SportId INNER JOIN
                      GamePlatform.[Parameter.GamePlatformTopOdd] AS [Parameter.GamePlatformTopOdd_2] with (nolock) ON 
                      Odd_2.ParameterOddId = [Parameter.GamePlatformTopOdd_2].ParameterOddId AND 
                      [Parameter.GamePlatformTopOdd_1].SportId = [Parameter.GamePlatformTopOdd_2].SportId AND 
                      GamePlatform.[Parameter.GamePlatformTopOdd].SportId = [Parameter.GamePlatformTopOdd_2].SportId 
WHERE   Parameter.Tournament.IsActive=1 and Parameter.Category.IsActive=1 and  (FixtureCompetiTip_1.TypeId = 1) AND (Match.FixtureCompetitor.TypeId = 2) AND (Match.Setting.StateId = 2) AND 
                      (((CAST(Match.FixtureDateInfo.MatchDate AS Date) <= CAST(DATEADD(DAY,@MaxDayPeriod,GETDATE()) AS date))
                      AND 
                      ((Match.FixtureDateInfo.MatchDate) >=  GETDATE() )) or  Parameter.Tournament.TournamentId in (31204,28963,3793) ) AND                       
                      (GamePlatform.[Parameter.GamePlatformTopOdd].OutCome = '1') AND ([Parameter.GamePlatformTopOdd_1].OutCome = 'X') AND 
                      ([Parameter.GamePlatformTopOdd_2].OutCome = '2') and GamePlatform.[Parameter.GamePlatformTopOdd].SportId= Parameter.Sport.SportId and  Parameter.Sport.IsActive=1
 and Match.Match.MatchId not in (select Live.Event.EventId FROM            Live.Event with (nolock) INNER JOIN
                         Live.EventDetail as EventDetail with (nolock) ON Live.Event.EventId = EventDetail.EventId INNER JOIN
                          Live.[EventSetting] with (nolock)  on Live.[EventSetting].MatchId=Live.Event.EventId 
						  INNER JOIN Live.[EventTopOdd] with (nolock) ON Live.[EventTopOdd].EventId=Live.[Event].EventId 
Where  
((Live.[EventSetting].StateId=2 and --Match State Open
EventDetail.IsActive=1 and --Match Active
EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  )  OR (EventDetail.TimeStatu=1 AND Live.[EventTopOdd].ThreeWay1 is not null and Live.[Event].ConnectionStatu=2 
and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2))  )
    
    
    truncate table Cache.Fixture
    
    INSERT INTO [Cache].[Fixture]
           ([BetradarMatchId],
		   [MatchId]
           ,[MatchDate]
           ,[HomeTeam]
           ,[AwayTeam]
           ,[SportName]
           ,[OddId1]
           ,[OddValue1]
           ,[Odd1Visibility]
           ,[OddId2]
           ,[OddValue2]
           ,[Odd1Visibility2]
           ,[OddId3]
           ,[OddValue3]
           ,[Odd1Visibility3]
           ,[OddTypeCount]
           ,[TournamentId],[IsPopular],[SportId],[NeutralGround])
    select [BetradarMatchId],[MatchId]
      ,[MatchDate]
      ,[HomeTeam]
      ,[AwayTeam]
      ,[SportName]
      ,[OddId1]
      ,[OddValue1]
      ,[Odd1Visibility]
      ,[OddId2]
      ,[OddValue2]
      ,[Odd1Visibility2]
      ,[OddId3]
      ,[OddValue3]
      ,[Odd1Visibility3]
      ,[OddTypeCount]
      ,[TournamentId],[IsPopular],[SportId],[NeutralGround]
    from #temptable 
	where Odd1Visibility<>'hidden'
	 --order by [MatchDate]
   
END


GO
