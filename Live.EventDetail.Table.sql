USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[EventDetail]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[EventDetail](
	[EventDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[EventId] [bigint] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[EventStatu] [int] NULL,
	[AutoTraded] [bit] NULL,
	[Balls] [int] NULL,
	[Bases] [nvarchar](50) NULL,
	[BatterTeam1] [int] NULL,
	[BatterTeam2] [int] NULL,
	[BetStatus] [int] NULL,
	[BetStopReasonId] [int] NULL,
	[Booked] [bit] NULL,
	[ClearedScore] [nchar](15) NULL,
	[ClockStopped] [bit] NULL,
	[CornersTeam1] [int] NULL,
	[CornersTeam2] [int] NULL,
	[CurrentEnd] [int] NULL,
	[Delivery] [int] NULL,
	[DismissalsTeam1] [int] NULL,
	[DismissalsTeam2] [int] NULL,
	[EarlyBetStatusId] [int] NULL,
	[Expedite] [bit] NULL,
	[GameScore] [nchar](100) NULL,
	[Innings] [int] NULL,
	[LegScore] [nchar](100) NULL,
	[MatchTime] [bigint] NULL,
	[MatchTimeExtended] [nchar](15) NULL,
	[Msgnr] [bigint] NULL,
	[Outs] [int] NULL,
	[MatchOver] [int] NULL,
	[PenaltyRunsTeam1] [int] NULL,
	[PenaltyRunsTeam2] [int] NULL,
	[Position] [int] NULL,
	[Possession] [int] NULL,
	[RedCardsTeam1] [int] NULL,
	[RedCardsTeam2] [int] NULL,
	[RemainingBowlsTeam1] [int] NULL,
	[RemainingBowlsTeam2] [int] NULL,
	[RemainingReds] [int] NULL,
	[RemainingTime] [nchar](15) NULL,
	[RemainingTimeInPeriod] [nchar](15) NULL,
	[Score] [nchar](15) NULL,
	[MatchServer] [int] NULL,
	[SourceId] [nvarchar](50) NULL,
	[Strikes] [int] NULL,
	[SuspendTeam1] [int] NULL,
	[SuspendTeam2] [int] NULL,
	[Throw] [int] NULL,
	[TieBreak] [bit] NULL,
	[MatchTry] [int] NULL,
	[MatchVisit] [int] NULL,
	[Yards] [int] NULL,
	[YellowCardsTeam1] [int] NULL,
	[YellowCardsTeam2] [int] NULL,
	[YellowRedCardsTeam1] [int] NULL,
	[YellowRedCardsTeam2] [int] NULL,
	[TimeStatu] [int] NOT NULL,
	[BetradarTimeStamp] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[BetradarMatchIds] [bigint] NOT NULL,
 CONSTRAINT [PK_EventDetail] PRIMARY KEY CLUSTERED 
(
	[EventDetailId] ASC,
	[BetradarMatchIds] ASC,
	[EventId] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [<Name of Missing Index, sysname,>]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [Live].[EventDetail]
(
	[BetradarTimeStamp] ASC
)
INCLUDE([IsActive],[EventStatu],[Bases],[BetStatus],[BetStopReasonId],[LegScore],[MatchTime],[MatchTimeExtended],[RedCardsTeam1],[RedCardsTeam2],[Score],[MatchServer],[YellowRedCardsTeam1],[YellowRedCardsTeam2],[TimeStatu]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_BBL]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BBL] ON [Live].[EventDetail]
(
	[IsActive] ASC
)
INCLUDE([EventId],[BetStatus],[TimeStatu],[UpdatedDate],[BetradarMatchIds]) WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventDetail_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_EventDetail_1] ON [Live].[EventDetail]
(
	[BetradarMatchIds] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventDetail_2]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_EventDetail_2] ON [Live].[EventDetail]
(
	[IsActive] ASC,
	[TimeStatu] ASC,
	[EventId] ASC,
	[BetStatus] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventDetail_3]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_EventDetail_3] ON [Live].[EventDetail]
(
	[EventId] ASC,
	[TimeStatu] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventDetail_4]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_EventDetail_4] ON [Live].[EventDetail]
(
	[IsActive] ASC,
	[TimeStatu] ASC,
	[BetradarMatchIds] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventDetail_5]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventDetail_5] ON [Live].[EventDetail]
(
	[EventId] ASC,
	[BetStatus] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IXBB3]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IXBB3] ON [Live].[EventDetail]
(
	[IsActive] ASC
)
INCLUDE([EventDetailId],[EventId],[EventStatu],[BetStatus],[BetStopReasonId],[GameScore],[LegScore],[MatchTime],[MatchTimeExtended],[RedCardsTeam1],[RedCardsTeam2],[Score],[YellowRedCardsTeam1],[YellowRedCardsTeam2],[TimeStatu],[BetradarMatchIds]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
