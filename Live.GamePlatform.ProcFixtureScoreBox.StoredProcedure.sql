USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Live].[GamePlatform.ProcFixtureScoreBox]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Live].[GamePlatform.ProcFixtureScoreBox]
	@LangId int,
	@SportId int
AS
BEGIN

set @LangId=6
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	CREATE TABLE #tEventDetailScrobox
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
	,SequenceNumber int,TournamentId int,BetReasonId int,BetReason nvarchar(250), MatchServer int,Code nvarchar(20),IsoCode nvarchar(3) )

if (@SportId=0)
begin
    
	insert #tEventDetailScrobox
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
						 ,cast (0 as bit) AS HasStreaming,Parameter.Sport.SportId,ISNULL(Parameter.Category.SequenceNumber,999) as SequenceNumber,Parameter.Tournament.TerminalTournamentId as TournamentId
						 , Language.[Parameter.LiveBetStopReason].ParameterReasonId,Language.[Parameter.LiveBetStopReason].ReasonT,EventDetail.MatchServer
						 ,Match.Code.Code
						 ,LOWER(Parameter.Iso.IsoName2)
FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                         Live.Event with (nolock) INNER JOIN
						 Match.Code with (nolock) On Match.Code.BetradarMatchId=Live.Event.BetradarMatchId and Match.Code.BetTypeId=1 INNER JOIN
                         Live.EventDetail as EventDetail with (nolock) ON Live.Event.EventId = EventDetail.EventId INNER JOIN
                         Parameter.Tournament with (nolock) ON Live.Event.TournamentId = Parameter.Tournament.TournamentId INNER JOIN
                         Parameter.Category with (nolock) ON Parameter.Tournament.CategoryId = Parameter.Category.CategoryId AND Parameter.Tournament.CategoryId = Parameter.Category.CategoryId INNER JOIN
                         Parameter.Sport with (nolock) ON Parameter.Category.SportId = Parameter.Sport.SportId INNER JOIN
                         Language.[Parameter.Tournament] with (nolock) ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId AND Language.[Parameter.Tournament].LanguageId=@LangId  INNER JOIN
                         Language.[Parameter.Sport] with (nolock) ON Parameter.Sport.SportId = Language.[Parameter.Sport].SportId   AND Language.[Parameter.Sport].LanguageId=@LangId   INNER JOIN
                         Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId  AND Language.[Parameter.Category].LanguageId=@LangId   ON Parameter.Competitor.CompetitorId = Live.Event.HomeTeam INNER JOIN
                         Parameter.Competitor  AS CompetiTip_1 with (nolock) ON Live.Event.AwayTeam = CompetiTip_1.CompetitorId INNER JOIN
						 Parameter.Iso with (nolock) ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
                         Language.ParameterCompetitor  AS ParameterCompetiTip_1 with (nolock) ON CompetiTip_1.CompetitorId = ParameterCompetiTip_1.CompetitorId  AND ParameterCompetiTip_1.LanguageId=@LangId  INNER JOIN
                         Live.[Parameter.TimeStatu] with (nolock) ON EventDetail.TimeStatu = Live.[Parameter.TimeStatu].TimeStatuId INNER JOIN 
						 Language.[Parameter.LiveTimeStatu] with (nolock) On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=@LangId INNER JOIN
						 Live.[EventSetting] on Live.[EventSetting].MatchId=Live.Event.EventId INNER JOIN Live.[EventTopOdd] with (nolock) ON Live.[EventTopOdd].EventId=Live.[Event].EventId LEFT OUTER JOIN
						 Language.[Parameter.LiveBetStopReason] with (nolock) ON Language.[Parameter.LiveBetStopReason].ParameterReasonId=EventDetail.BetStopReasonId and Language.[Parameter.LiveBetStopReason].LanguageId=@LangId 
Where
((Live.[EventSetting].StateId=2 and --Match State Open
EventDetail.IsActive=1 and --Match Active
EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  )  OR (EventDetail.TimeStatu=1 AND Live.[EventTopOdd].ThreeWay1 is not null and Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2)) 



  
   SELECT    DIsTINCT    EventDetail.EventId,EventDetail.TournamentName, EventDetail.CategoryName, EventDetail.SportName, EventDetail.SportNameOriginal AS SportNameOriginal, 
                         EventDetail.SportIcon AS SportIcon, EventDetail.SportIconColor AS SportIconColor, EventDetail.HomeTeam, EventDetail.AwayTeam, 
                         EventDetail.EventDate, EventDetail.IsActive, EventDetail.EventStatu, EventDetail.BetStatus, EventDetail.MatchTime, EventDetail.MatchTimeExtended, EventDetail.Score, 
                         EventDetail.TimeStatu, EventDetail.StatuColor,  EventDetail.TimeStatuColor AS TimeStatuColor,
						 
CAST(0 as int) as ExtraOddCount,
						 EventDetail.BetStatus
						 ,EventDetail.HasStreaming
						 	 ,EventDetail.LegScore as  GameScore ,EventDetail.TournamentId,EventDetail.BetReasonId,EventDetail.BetReason,EventDetail.SequenceNumber,EventDetail.MatchServer
							 ,Code,IsoCode
FROM        #tEventDetailScrobox as EventDetail  


end
else if (@SportId<>1)
begin


	insert #tEventDetailScrobox
select top 15 EventDetail.[EventDetailId],
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
						 ,cast (0 as bit) AS HasStreaming,Parameter.Sport.SportId,ISNULL(Parameter.Category.SequenceNumber,999) as SequenceNumber,Parameter.Tournament.TerminalTournamentId as TournamentId
						 , Language.[Parameter.LiveBetStopReason].ParameterReasonId,Language.[Parameter.LiveBetStopReason].ReasonT,EventDetail.MatchServer
						  ,Match.Code.Code
						 ,LOWER(Parameter.Iso.IsoName2)
FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                         Live.Event with (nolock) INNER JOIN
						 Match.Code with (nolock) On Match.Code.BetradarMatchId=Live.Event.BetradarMatchId and Match.Code.BetTypeId=1 INNER JOIN
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
						 Parameter.Iso with (nolock) ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.LiveTimeStatu] with (nolock) On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=@LangId INNER JOIN
						 Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId INNER JOIN Live.[EventTopOdd] with (nolock) ON Live.[EventTopOdd].EventId=Live.[Event].EventId LEFT OUTER JOIN
						 Language.[Parameter.LiveBetStopReason] with (nolock) ON Language.[Parameter.LiveBetStopReason].ParameterReasonId=EventDetail.BetStopReasonId and Language.[Parameter.LiveBetStopReason].LanguageId=@LangId 
Where
((Live.[EventSetting].StateId=2 and --Match State Open
EventDetail.IsActive=1 and --Match Active
EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  )  OR (EventDetail.TimeStatu=1 AND Live.[EventTopOdd].ThreeWay1 is not null and Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2)) 
and Parameter.Sport.SportId=@SportId



     SELECT    DIsTINCT    EventDetail.EventId,EventDetail.TournamentName, EventDetail.CategoryName, EventDetail.SportName, EventDetail.SportNameOriginal AS SportNameOriginal, 
                         EventDetail.SportIcon AS SportIcon, EventDetail.SportIconColor AS SportIconColor, EventDetail.HomeTeam, EventDetail.AwayTeam, 
                         EventDetail.EventDate, EventDetail.IsActive, EventDetail.EventStatu, EventDetail.BetStatus, EventDetail.MatchTime, EventDetail.MatchTimeExtended, EventDetail.Score, 
                         EventDetail.TimeStatu, EventDetail.StatuColor,  EventDetail.TimeStatuColor AS TimeStatuColor,
						 
cast(0 as int) as ExtraOddCount,
						 EventDetail.BetStatus
						 ,EventDetail.HasStreaming
						 	 ,EventDetail.LegScore as  GameScore,EventDetail.TournamentId,EventDetail.BetReasonId,EventDetail.BetReason,EventDetail.SequenceNumber,EventDetail.MatchServer
							 ,Code,IsoCode
FROM        #tEventDetailScrobox as EventDetail 
where EventDetail.SportId=@SportId
order by EventDetail.SequenceNumber 

end
else  
begin



	insert #tEventDetailScrobox
select top 15 EventDetail.[EventDetailId],
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
							
						 ,cast (0 as bit) AS HasStreaming,Parameter.Sport.SportId,ISNULL(Parameter.Category.SequenceNumber,999) as SequenceNumber,Parameter.Tournament.TerminalTournamentId as TournamentId
						 , Language.[Parameter.LiveBetStopReason].ParameterReasonId,Language.[Parameter.LiveBetStopReason].ReasonT,EventDetail.MatchServer
						  ,Match.Code.Code
						 ,LOWER(Parameter.Iso.IsoName2)
FROM            Language.ParameterCompetitor with (nolock) INNER JOIN
                         Parameter.Competitor with (nolock) ON Language.ParameterCompetitor.CompetitorId = Parameter.Competitor.CompetitorId AND Language.ParameterCompetitor.LanguageId=@LangId INNER JOIN
                         Live.Event with (nolock) INNER JOIN
						 Match.Code with (nolock) On Match.Code.BetradarMatchId=Live.Event.BetradarMatchId and Match.Code.BetTypeId=1 INNER JOIN
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
						 Parameter.Iso with (nolock) ON Parameter.Iso.IsoId=Parameter.Category.IsoId INNER JOIN
						 Language.[Parameter.LiveTimeStatu] with (nolock) On Language.[Parameter.LiveTimeStatu].ParameterTimeStatuId= Live.[Parameter.TimeStatu].TimeStatuId ANd Language.[Parameter.LiveTimeStatu].LanguageId=@LangId INNER JOIN
						 Live.[EventSetting] with (nolock) on Live.[EventSetting].MatchId=Live.Event.EventId INNER JOIN Live.[EventTopOdd] with (nolock) ON Live.[EventTopOdd].EventId=Live.[Event].EventId LEFT OUTER JOIN
						 Language.[Parameter.LiveBetStopReason] with (nolock) ON Language.[Parameter.LiveBetStopReason].ParameterReasonId=EventDetail.BetStopReasonId and Language.[Parameter.LiveBetStopReason].LanguageId=@LangId 
Where
((Live.[EventSetting].StateId=2 and --Match State Open
EventDetail.IsActive=1 and --Match Active
EventDetail.TimeStatu not in (0,1,5,14,15,27,84,21,22,23,24,25,26,11,86,83)  )  OR (EventDetail.TimeStatu=1 AND Live.[EventTopOdd].ThreeWay1 is not null and Live.[Event].ConnectionStatu=2 and Live.[EventSetting].StateId=2 and EventDetail.IsActive=1 and EventDetail.BetStatus=2)) 
and Parameter.Sport.SportId=@SportId
	order by ISNULL(Parameter.Category.SequenceNumber,999)


     SELECT    DIsTINCT    EventDetail.EventId,EventDetail.TournamentName, EventDetail.CategoryName, EventDetail.SportName, EventDetail.SportNameOriginal AS SportNameOriginal, 
                         EventDetail.SportIcon AS SportIcon, EventDetail.SportIconColor AS SportIconColor, EventDetail.HomeTeam, EventDetail.AwayTeam, 
                         EventDetail.EventDate, EventDetail.IsActive, EventDetail.EventStatu, EventDetail.BetStatus, EventDetail.MatchTime, EventDetail.MatchTimeExtended, EventDetail.Score, 
                         EventDetail.TimeStatu, EventDetail.StatuColor,  EventDetail.TimeStatuColor AS TimeStatuColor,
						
CAST(0 as int) as ExtraOddCount,
						 EventDetail.BetStatus
						 ,EventDetail.HasStreaming
						 	 ,EventDetail.LegScore as  GameScore ,EventDetail.TournamentId,EventDetail.BetReasonId,EventDetail.BetReason,EventDetail.SequenceNumber,EventDetail.MatchServer
							 ,Code,IsoCode
FROM        #tEventDetailScrobox as EventDetail 
where EventDetail.SportId=@SportId
order by EventDetail.SequenceNumber 

end
    
END





GO
