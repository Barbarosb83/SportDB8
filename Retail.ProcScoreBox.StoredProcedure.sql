USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Retail].[ProcScoreBox]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE PROCEDURE [Retail].[ProcScoreBox]
	@LangId int,
	@SportId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 CREATE TABLE #tEventDetail
(
	[EventDetailId] [bigint]  NOT NULL,
	[EventId] [bigint] NOT NULL,
	 [IsActive] [bit] NULL,
	 [EventStatu] [int] NULL,
	 [BetStatus] [int] NULL,
	[LegScore] [nvarchar](100) NULL,
	 [MatchTime] [bigint] NULL,
	 [MatchTimeExtended] [nchar](15) NULL,
	 [Score] [nchar](15) NULL,
	[TimeStatu] [int] NULL
	,BetradarMatchIds bigint
	,TournamentName nvarchar(200)
	,CategoryName nvarchar(200)
	,SportName nvarchar(150)
	,SportNameOriginal nvarchar(150)
	,SportIcon nvarchar(250)
	,SportIconColor nvarchar(100)
	,HomeTeam nvarchar(150)
	,AwayTeam nvarchar(150)
	,EventDate datetime
	,StatuColor int
	,TimeStatuColor nvarchar(50)
	,HasStreaming bit
	,SportId int
	,SequenceNumber int)


insert #tEventDetail
select EventDetail.[EventDetailId],
	EventDetail.[EventId] ,
	 EventDetail.[IsActive],
	 EventDetail.[EventStatu],
	 EventDetail.[BetStatus] ,
	EventDetail.[LegScore] ,
	 EventDetail.[MatchTime] ,
	 EventDetail.[MatchTimeExtended] ,
	 EventDetail.[Score] ,
	EventDetail.[TimeStatu]
	,BetradarMatchIds ,
  Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName, Language.[Parameter.Sport].SportName, Parameter.Sport.SportName AS SportNameOriginal, 
                         Parameter.Sport.Icon AS SportIcon, Parameter.Sport.IconColor AS SportIconColor, Language.ParameterCompetitor.CompetitorName AS HomeTeam
						 , ParameterCompetiTip_1.CompetitorName AS AwayTeam, 
                         Live.Event.EventDate, 
                          Live.[Parameter.TimeStatu].StatuColor,  Language.[Parameter.LiveTimeStatu].TimeStatu AS TimeStatuColor
							
						 ,cast (0 as bit) AS HasStreaming,Parameter.Sport.SportId,ISNULL(Parameter.Category.SequenceNumber,999)
FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                         Live.Event with (nolock) INNER JOIN
                         Live.EventDetail as EventDetail with (nolock) ON Live.Event.EventId = EventDetail.EventId INNER JOIN
                         Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                         Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND Language.[Parameter.Tournament].LanguageId=@LangId  INNER JOIN
                         Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId   AND Language.[Parameter.Sport].LanguageId=@LangId   INNER JOIN
                         Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId  AND Language.[Parameter.Category].LanguageId=@LangId   ON Parameter.Competitor.CompetitorId = Live.Event.HomeTeam INNER JOIN
                         Parameter.Competitor  AS CompetiTip_1 with (nolock) ON Live.Event.AwayTeam = CompetiTip_1.CompetitorId INNER JOIN
                         Language.ParameterCompetitor  AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId  AND ParameterCompetiTip_1.LanguageId=@LangId  INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 Language.[Parameter.LiveTimeStatu] with (nolock) On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=@LangId INNER JOIN
						 Live.[EventSetting] on Live.[EventSetting].MatchId=Live.Event.EventId INNER JOIN Live.[EventTopOdd] with (nolock) ON Live.[EventTopOdd].EventId=Live.[Event].EventId 
						 where Parameter.Sport.SportId=1  and  cast(Live.Event.EventDate as date)>=cast(GETDATE() as date) and cast(Live.Event.EventDate as date)<cast(DATEADD(DAY,1,GETDATE()) as date)
--and  Parameter.Sport.SportId=999
--INNER JOIN Live.Event with (nolock) ON Live.Event.EventId=Live.EventDetail.EventId 
--INNER JOIN Live.EventSetting with (nolock) On Live.EventSetting.MatchId=Live.Event.EventId and Live.EventDetail.EventId=Live.EventSetting.MatchId
--Where
--(
--(Live.[EventSetting].StateId=2 and   EventDetail.IsActive=1 and  EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  ) OR 
--(EventDetail.TimeStatu=5 and DATEDIFF(MINUTE, EventDetail,GETDATE())<2)  and 
--Live.[Event].ConnectionStatu=2 OR (EventDetail.TimeStatu=1 AND  Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2))




	declare @temptable table (ScoreCardId bigint,EventId bigint,ScoreCardType int,AffectedTeam int,Time int,HomeTeamScore int,AwayTeamScore int)

	insert @temptable
	SELECT     top 30   ScoreCardId, Live.ScoreCardSummary.EventId,  ScoreCardType,   AffectedTeam, Time
,ISNULL((Select SUM(ScoreCardType) from Live.ScoreCardSummary as LSS where LSS.EventId=Live.ScoreCardSummary.EventId and LSS.ScoreCardType=1 and AffectedTeam=1 and IsCanceled=0 and LSS.ScoreCardId<=Live.ScoreCardSummary.ScoreCardId ),0) as HomeTeamScore
,ISNULL((Select SUM(ScoreCardType) from Live.ScoreCardSummary as LSS where LSS.EventId=Live.ScoreCardSummary.EventId and LSS.ScoreCardType=1 and AffectedTeam=2 and IsCanceled=0 and LSS.ScoreCardId<=Live.ScoreCardSummary.ScoreCardId),0) as AwayTeamScore
FROM            Live.ScoreCardSummary INNER JOIN #tEventDetail as EventDetail ON Live.ScoreCardSummary.EventId=EventDetail.EventId
WHERE      
  not exists (Select ScoreCardId from Live.ScoreCardSummary as LS with (nolock) where LS.EventId=Ls.EventId and LS.ScoreCardType=2 and LS.CardType=1 and ScoreCardId=Live.ScoreCardSummary.ScoreCardId)
 and Live.ScoreCardSummary.IsCanceled=0 and BetradarId<>0 
 --and ScoreCardType<>2 and CardType<>1
order by Live.ScoreCardSummary.EventId,Time




 SELECT   DISTINCT TOP 30    EventDetail.EventId,EventDetail.TournamentName, EventDetail.CategoryName, EventDetail.SportName,EventDetail.SportNameOriginal, 
                         EventDetail.SportIcon, EventDetail.SportIconColor, EventDetail.HomeTeam, EventDetail.AwayTeam, 
                         EventDetail.EventDate, EventDetail.IsActive, EventDetail.EventStatu, EventDetail.BetStatus, EventDetail.MatchTime, EventDetail.MatchTimeExtended, RTRIM(EventDetail.Score) as Score, 
                         EventDetail.TimeStatu, EventDetail.StatuColor,  EventDetail.TimeStatuColor,
						
0 as ExtraOddCount,
						 EventDetail.BetStatus,ScoreCardId,ScoreCardType,AffectedTeam,Time,HomeTeamScore,AwayTeamScore 
						
FROM           #tEventDetail as EventDetail INNER JOIN @temptable as TMP ON TMP.EventId=EventDetail.EventId
                    
Where
--EventDetail.SportId=@SportId and 
TMP.Time>0 --and EventDetail.EventId<>144487
-- and cast(Live.Event.EventDate as date)>cast(DATEADD(DAY,-1,GETDATE()) as date)
--((Live.[EventSetting].StateId=2 and --Match State Open
--EventDetail.IsActive=1 and --Match Active
--EventDetail.TimeStatu not in (0,1,5,15,14,27,84,21,22,23,24,25,26,11,86,83)  ) OR (EventDetail.TimeStatu=5 and DATEDIFF(MINUTE, EventDetail.UpdatedDate,GETDATE())<2)  and 
--Live.[Event].ConnectionStatu=2 OR (EventDetail.TimeStatu=1 and Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2))
 
Order by ScoreCardId desc

    

	--select EventId,SUM(ISNULL(HomeTeamYellow,0)) as HomeTeamYellow,SUM(ISNULL(HomeTeamRed,0)) as HomeTeamRed,SUM(ISNULL(AwayTeamYellow,0)) as AwayTeamYellow,SUM(ISNULL(AwayTeamRed,0)) as AwayTeamRed 
	--from @temptable GROUP BY EventId

END




GO
