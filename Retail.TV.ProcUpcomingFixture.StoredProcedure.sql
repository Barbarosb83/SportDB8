USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[TV.ProcUpcomingFixture]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[TV.ProcUpcomingFixture]
	@LangId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @tempMatch table (MatchId bigint)

	insert @tempMatch
	SELECT  top 300  Match.Match.MatchId 
FROM          Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
						 Cache.Fixture with (nolock) ON Cache.Fixture.BetradarMatchId=Live.[Event].BetradarMatchId INNER JOIN
                         Live.EventSetting with (nolock) ON Live.EventSetting.MatchId = Live.Event.EventId INNER JOIN
                         Match.Match with (nolock) ON Live.Event.BetradarMatchId = Match.Match.BetradarMatchId LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Live.Event.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId
WHERE        (Live.EventSetting.StateId = 2) AND (Live.EventDetail.IsActive = 1) AND (Live.EventDetail.TimeStatu = 1) AND (CAST(Live.Event.EventDate AS date) = CAST(GETDATE() AS date)) 
and Cache.Fixture.MatchDate>DATEADD(MINUTE,20,GETDATE()) order by EventDate
--AND                          (CAST(Live.EventDetail.UpdatedDate AS date) = CAST(GETDATE() AS date))


	declare @temptable table (MatchId bigint,KGY float,KGN float,NextGoal1 float,NextGoalX float,NextGoal2 float,OverUnder nvarchar(20),Overs float,Unders float,FirstHalfComment nvarchar(250),FirstHalf1 float,FirstHalfX float,FirstHalf2 float,FirstHalfBothYes float,FirstHalfBothNo float,FirstHalfTotal nvarchar(20),FirstHalfOver float,FirstHalfUnder float)

	
	declare @temptable2 table (MatchId bigint,KGY float,KGN float,NextGoal1 float,NextGoalX float,NextGoal2 float,OverUnder nvarchar(20),Overs float,Unders float,FirstHalfComment nvarchar(250),FirstHalf1 float,FirstHalfX float,FirstHalf2 float,FirstHalfBothYes float,FirstHalfBothNo float,FirstHalfTotal nvarchar(20),FirstHalfOver float,FirstHalfUnder float)

	
		insert @temptable (MatchId,OverUnder)
				select Match.Odd.MatchId,MAX(SpecialBetValue) from Match.Odd with (nolock)  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where   BetradarOddTypeId=383 and OutCome='Over' GROUP BY Match.Odd.MatchId

		insert @temptable (MatchId,Overs)
			select  Match.Odd.MatchId,OddValue from Match.Odd with (nolock) INNER JOIN @temptable as TP ON Match.Odd.MatchId=TP.MatchId and Match.Odd.SpecialBetValue=TP.OverUnder 
			where   BetradarOddTypeId=383 and OutCome='Over' 

	insert @temptable (MatchId,Unders)
select  Match.Odd.MatchId,OddValue from Match.Odd with (nolock) INNER JOIN @temptable as TP ON Match.Odd.MatchId=TP.MatchId and Match.Odd.SpecialBetValue=TP.OverUnder 
where   BetradarOddTypeId=383 and OutCome='Under'


		insert @temptable (MatchId,FirstHalfTotal)
		select Match.Odd.MatchId,MAX(SpecialBetValue) from Match.Odd with (nolock)  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where   BetradarOddTypeId=284 and OutCome='Over' and OddValue<2.7  GROUP BY Match.Odd.MatchId


		insert @temptable (MatchId,FirstHalfOver)
			select  Match.Odd.MatchId,OddValue from Match.Odd with (nolock) INNER JOIN @temptable as TP ON Match.Odd.MatchId=TP.MatchId and Match.Odd.SpecialBetValue=TP.FirstHalfTotal 
			where   BetradarOddTypeId=284 and OutCome='Over' 

				insert @temptable (MatchId,FirstHalfUnder)
			select  Match.Odd.MatchId,OddValue from Match.Odd with (nolock) INNER JOIN @temptable as TP ON Match.Odd.MatchId=TP.MatchId and Match.Odd.SpecialBetValue=TP.FirstHalfTotal 
			where   BetradarOddTypeId=284 and OutCome='Under' 


	insert @temptable (MatchId,KGY)
		select Match.Odd.MatchId,Match.Odd.OddValue from Match.Odd with (nolock) INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=43 and OutCome='Yes' 


		insert @temptable (MatchId,KGN)
		select Match.Odd.MatchId,Match.Odd.OddValue from Match.Odd with (nolock)  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=43 and OutCome='No' 

		insert @temptable (MatchId,NextGoal1)
		select Match.Odd.MatchId,Match.Odd.OddValue from Match.Odd with (nolock) INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=41 and OutCome='1' 

		insert @temptable (MatchId,NextGoalX)
		select Match.Odd.MatchId,Match.Odd.OddValue from Match.Odd with (nolock) INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=41 and OutCome='None' 

		insert @temptable (MatchId,NextGoal2)
		select Match.Odd.MatchId,Match.Odd.OddValue from Match.Odd  with (nolock) INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=41 and OutCome='2'
		
		insert @temptable (MatchId,FirstHalfComment,FirstHalf1)
		select Match.Odd.MatchId,'1.Halbzeit [HZ]',Match.Odd.OddValue from Match.Odd with (nolock)  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=42 and OutCome='1'

		insert @temptable (MatchId,FirstHalfX)
		select Match.Odd.MatchId,Match.Odd.OddValue from Match.Odd with (nolock)  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=42 and OutCome='X'

		insert @temptable (MatchId,FirstHalf2)
		select Match.Odd.MatchId,Match.Odd.OddValue from Match.Odd with (nolock)  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=42 and OutCome='2'

				insert @temptable (MatchId,FirstHalfComment,FirstHalf1)
		select Match.Odd.MatchId,'1.Satz [HZ]',Match.Odd.OddValue from Match.Odd with (nolock)  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=204 and OutCome='1'

		--insert @temptable (MatchId,FirstHalfX)
		--select Match.Odd.MatchId,Match.Odd.OddValue from Match.Odd  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=42 and OutCome='X'

		insert @temptable (MatchId,FirstHalf2)
		select Match.Odd.MatchId,Match.Odd.OddValue from Match.Odd with (nolock)  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=204 and OutCome='2'

		insert @temptable (MatchId,FirstHalfBothYes)
		select Match.Odd.MatchId,Match.Odd.OddValue from Match.Odd with (nolock)  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=328 and OutCome='Yes'

		insert @temptable (MatchId,FirstHalfBothNo)
		select Match.Odd.MatchId,Match.Odd.OddValue from Match.Odd with (nolock)  INNER JOIN @tempMatch as TM ON Match.Odd.MatchId=TM.MatchId where BetradarOddTypeId=328 and OutCome='No'

	 

		insert @temptable2
		select MatchId ,SUM(KGY) ,SUM(KGN) ,SUM(NextGoal1) ,SUM(NextGoalX) ,SUM(NextGoal2) ,MAX(OverUnder) ,SUM(Overs) ,SUM(Unders),MAX(FirstHalfComment) ,SUM(FirstHalf1),SUM(FirstHalfX) ,SUM(FirstHalf2)
		,SUM(FirstHalfBothYes)
		,SUM(FirstHalfBothNo)
		,MAX(FirstHalfTotal)   
		,SUM(FirstHalfOver)
		,SUM(FirstHalfUnder)
		     from @temptable  GROUP BY MatchId

	 
	 SELECT DISTINCT  Match.Code.Code as Code,Match.Match.MatchId AS EventId, Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName, Language.[Parameter.Sport].SportName, 
                         Parameter.Sport.SportName AS SportNameOriginal, Parameter.Sport.Icon AS SportIcon, Parameter.Sport.IconColor AS SportIconColor, Language.ParameterCompetitor.CompetitorName AS HomeTeam, 
                         ParameterCompetiTip_1.CompetitorName AS AwayTeam, Live.Event.EventDate, Live.EventDetail.IsActive, Live.EventDetail.EventStatu, Live.EventDetail.BetStatus, Live.EventDetail.MatchTime, 
                         Live.EventDetail.MatchTimeExtended, Live.EventDetail.Score, Live.EventDetail.TimeStatu, Live.[Parameter.TimeStatu].StatuColor, Language.[Parameter.LiveTimeStatu].TimeStatu AS TimeStatuColor, 
                           Cache.Fixture.OddId1, Cache.Fixture.OddValue1 as ThreeWay1, 
                         Cache.Fixture.Odd1Visibility, Cache.Fixture.OddId2, Cache.Fixture.OddValue2 as ThreeWayX, Cache.Fixture.Odd1Visibility2 AS Odd2Visibility, Cache.Fixture.OddId3, Cache.Fixture.OddValue3 as ThreeWay2, 
                         Cache.Fixture.Odd1Visibility3 AS Odd3Visibility, 
                           Live.EventDetail.BetStatus AS Expr1, Live.EventLiveStreaming.Web AS HasStreaming,
						 Match.Match.BetradarMatchId,TP.KGY as BothTeamYes,TP.KGN as BothTeamNo,TP.NextGoal1 as NextGoal1,TP.NextGoalX as NextGoalX,TP.NextGoal2 as NextGoal2,TP.OverUnder as Total,TP.Overs as TotalOver,TP.Unders as  TotalUnder,Parameter.Sport.SquanceNumber,
						  Parameter.Iso.IsoName,TP.FirstHalfComment,TP.FirstHalf1,TP.FirstHalfX,TP.FirstHalf2,TP.FirstHalfBothYes,TP.FirstHalfBothNo,TP.FirstHalfTotal,TP.FirstHalfOver,TP.FirstHalfUnder,SUBSTRING(cast(Live.Event.EventDate as nvarchar(50)),13,5) as EventTime
FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId = @LangId INNER JOIN
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail with (nolock) ON Live.Event.EventId = Live.EventDetail.EventId INNER JOIN
						 Cache.Fixture with (nolock) ON Cache.Fixture.BetradarMatchId=Live.[Event].BetradarMatchId INNER JOIN
                         Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId and Parameter.Sport.SportId in (1,2,4,5) INNER JOIN
                         Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND Language.[Parameter.Tournament].LanguageId = @LangId INNER JOIN
                         Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId AND Language.[Parameter.Sport].LanguageId = @LangId INNER JOIN
                         Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId AND Language.[Parameter.Category].LanguageId = @LangId ON 
                         Parameter.Competitor.CompetitorId = Live.Event.HomeTeam INNER JOIN
                         Parameter.Competitor AS CompetiTip_1 with (nolock) ON Live.Event.AwayTeam = CompetiTip_1.CompetitorId INNER JOIN
                         Language.ParameterCompetitor AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId AND ParameterCompetiTip_1.LanguageId = @LangId INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON Live.EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN
                         Language.[Parameter.LiveTimeStatu] with (nolock) ON Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId = Live.[Parameter.TimeStatu].TimeStatuId AND 
                         Language.[Parameter.LiveTimeStatu].LanguageId = @LangId INNER JOIN
                         Live.EventSetting with (nolock) ON Live.EventSetting.MatchId = Live.Event.EventId INNER JOIN
                         Match.Match with (nolock) ON Live.Event.BetradarMatchId = Match.Match.BetradarMatchId LEFT OUTER JOIN
                         Live.EventLiveStreaming with (nolock) ON Live.Event.BetradarMatchId = Live.EventLiveStreaming.BetradarMatchId LEFT OUTER JOIN @temptable2 as TP ON
						 TP.MatchId= Match.Match.MatchId INNER JOIN Match.Code with (nolock) ON Match.Code.MatchId=Live.Event.EventId and Match.Code.BetTypeId=1 INNER JOIN
						 Parameter.Iso with (nolock) On Parameter.Iso.IsoId=Parameter.Category.IsoId
WHERE        (Live.EventSetting.StateId = 2) AND (Live.EventDetail.IsActive = 1) AND (Live.EventDetail.TimeStatu = 1) AND (CAST(Live.Event.EventDate AS date) >= CAST(GETDATE() AS date)) and (CAST(Live.Event.EventDate AS date) <= CAST(DATEADD(DAY,1,GETDATE()) AS date))
and Cache.Fixture.MatchDate>DATEADD(MINUTE,20,GETDATE()) 
--AND                          (CAST(Live.EventDetail.UpdatedDate AS date) = CAST(GETDATE() AS date))
ORDER BY Live.Event.EventDate

END




GO
