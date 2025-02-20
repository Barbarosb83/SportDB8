USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcFixtureLive2]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Live].[GamePlatform.ProcFixtureLive2]
	@LangId int,
@SportId int,
@CategoryId int,
@TournamentId int
AS

BEGIN
 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



-- CREATE TABLE #tEventDetailFixtureLive
--(
--	[EventDetailId] [bigint]  NOT NULL,
--	[EventId] [bigint] NOT NULL,
--	 [IsActive] [bit] NULL,
--	 [EventStatu] [int] NULL,
--	 [BetStatus] [int] NULL,
--	[LegScore] [nvarchar](100) NULL,
--	[GameScore] [nvarchar](100) NULL,
--	 [MatchTime] [bigint] NULL,
--	 [MatchTimeExtended] [nchar](15) NULL,
--	 [Score] [nchar](15) NULL,
--	[TimeStatu] [int] NULL
--	,BetradarMatchIds bigint NOT NULL
--	,TournamentName nvarchar(200)
--	,CategoryName nvarchar(200)
--	,SportName nvarchar(150)
--	,SportNameOriginal nvarchar(150)
--	,SportIcon nvarchar(250)
--	,SportIconColor nvarchar(100)
--	,HomeTeam nvarchar(150)
--	,AwayTeam nvarchar(150)
--	,EventDate datetime
--	,StatuColor int
--	,TimeStatuColor nvarchar(50)
--	,HasStreaming bit
--	,SportId int
--	,SequenceNumber int,CategoryId int,TournamentId int,TournamentSeqNumber int,RedCardTeam1 int,RedCardTeam2 int,BetStopReasonId int,BetStopreason nvarchar(200))
-- CONSTRAINT [PK_EventDetaill] PRIMARY KEY CLUSTERED 
--(
--	[EventId] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--) ON [PRIMARY]
 

  
select EventDetail.[EventDetailId],
	EventDetail.[EventId] ,
	 EventDetail.[IsActive],
	 EventDetail.[EventStatu],
	 EventDetail.[BetStatus] ,
	case when Parameter.Sport.SportId<>3 then EventDetail.GameScore else SUBSTRING(RTRIM(EventDetail.LegScore),LEN(RTRIM(EventDetail.LegScore))-2,3) end as LegScore ,
	EventDetail.GameScore ,
	 EventDetail.[MatchTime] ,
	 EventDetail.[MatchTimeExtended] ,
	 EventDetail.[Score] ,
	EventDetail.[TimeStatu]
	,BetradarMatchIds as BetradarMatchId ,
  Language.[Parameter.Tournament].TournamentName, Language.[Parameter.Category].CategoryName, Language.[Parameter.Sport].SportName, Parameter.Sport.SportName AS SportNameOriginal, 
                         Parameter.Sport.Icon AS SportIcon, Parameter.Sport.IconColor AS SportIconColor, Language.ParameterCompetitor.CompetitorName AS HomeTeam
						 , ParameterCompetiTip_1.CompetitorName AS AwayTeam, 
                         Live.Event.EventDate, 
                          Live.[Parameter.TimeStatu].StatuColor,  Language.[Parameter.LiveTimeStatu].TimeStatu AS TimeStatuColor
							
						 ,cast (0 as bit) AS HasStreaming,Parameter.Sport.SportId,ISNULL(Parameter.Category.SequenceNumber,99999) as SequenceNumber
						 ,Language.[Parameter.Category].CategoryId,Parameter.Tournament.TerminalTournamentId as TournamentId
						 ,ISNULL(Parameter.Tournament.SequenceNumber,99999) as TournamentSeqNumber ,ISNULL(EventDetail.RedCardsTeam1,0)+ISNULL(EventDetail.YellowRedCardsTeam1,0) as RedCardTeam1
						 ,ISNULL(EventDetail.RedCardsTeam2,0)+ISNULL(EventDetail.YellowRedCardsTeam2,0) as RedCardTeam2
						 ,EventDetail.BetStopReasonId
						,Language.[Parameter.LiveBetStopReason].Reason as BetStopreason
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
						 Live.[EventSetting] with (nolock)  on Live.[EventSetting].MatchId=Live.Event.EventId 
						 INNER JOIN
						 Language.[Parameter.LiveBetStopReason] On Language.[Parameter.LiveBetStopReason].ParameterReasonId=ISNULL(EventDetail.BetStopReasonId,0) and Language.[Parameter.LiveBetStopReason].LanguageId=@LangId
Where Parameter.Sport.SportId<>21 and
 Live.[EventSetting].StateId=2 and --Match State Open
EventDetail.IsActive=1 and --Match Active   
((EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  ) 
 OR (EventDetail.TimeStatu=1  and Live.[Event].ConnectionStatu=2 
   and EventDetail.BetStatus=2 and Live.Event.EventDate<DATEADD(MINUTE,-1,GETDATE())) 
   OR (EventDetail.TimeStatu=5 and EventDetail.BetradarTimeStamp>DATEADD(SECOND,-30,GETDATE())) 
   )  order by Parameter.Sport.SportId

--     SELECT    DIsTINCT   EventDetail.BetradarMatchIds as BetradarMatchId,  EventDetail.EventId,EventDetail.TournamentName, EventDetail.CategoryName, EventDetail.SportName, EventDetail.SportNameOriginal, 
--                           cast(ISNULL((select Count(*) from #tEventDetailFixtureLive as ED where Ed.SportId=EventDetail.SportId),0) as nvarchar(50)) as  SportIcon
--						   , EventDetail.SportIconColor, EventDetail.HomeTeam, EventDetail.AwayTeam, 
--                         EventDetail.EventDate, EventDetail.IsActive, EventDetail.EventStatu, EventDetail.BetStatus, EventDetail.MatchTime
--						 ,case when EventDetail.SportId=1 and EventDetail.TimeStatu=2 and EventDetail.MatchTime>45 and SUBSTRING(EventDetail.MatchTimeExtended,1, CHARINDEX(':',EventDetail.MatchTimeExtended)-1)<>'0' then  '45+'+ SUBSTRING(EventDetail.MatchTimeExtended,1, CHARINDEX(':',EventDetail.MatchTimeExtended)-1) else 
--						 case when  EventDetail.SportId=1 and EventDetail.TimeStatu=4 and EventDetail.MatchTime>90 and SUBSTRING(EventDetail.MatchTimeExtended,1, CHARINDEX(':',EventDetail.MatchTimeExtended)-1)<>'0' then  '90+'+ SUBSTRING(EventDetail.MatchTimeExtended,1, CHARINDEX(':',EventDetail.MatchTimeExtended)-1)
--						 else  cast(EventDetail.MatchTime as nvarchar(10)) end end as MatchTimeExtended
--						 , EventDetail.Score, 
--                         EventDetail.TimeStatu, EventDetail.StatuColor,  EventDetail.TimeStatuColor,EventDetail.SportId,EventDetail.CategoryId, EventDetail.TournamentId,
--						 ,EventDetail.BetStatus
--						 ,EventDetail.HasStreaming
--						 	 ,RTRIM(EventDetail.LegScore) as  GameScore 
--							 ,EventDetail.SequenceNumber,case when EventDetail.SportId<>3 then EventDetail.GameScore else SUBSTRING(RTRIM(EventDetail.LegScore),LEN(RTRIM(EventDetail.LegScore))-2,3) end as LegScore
--							  ,EventDetail.TournamentSeqNumber,EventDetail.RedCardTeam1,EventDetail.RedCardTeam2,EventDetail.BetStopReasonId,EventDetail.BetStopreason
--FROM        #tEventDetailFixtureLive as EventDetail    order by EventDetail.SportId


end
GO
