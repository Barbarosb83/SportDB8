USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[EventDetail]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[EventDetail](
	[EventDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[EventId] [bigint] NOT NULL,
	[IsActive] [bit] NULL,
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
	[DeVirtualry] [int] NULL,
	[DismissalsTeam1] [int] NULL,
	[DismissalsTeam2] [int] NULL,
	[EarlyBetStatusId] [int] NULL,
	[Expedite] [bit] NULL,
	[GameScore] [nchar](15) NULL,
	[Innings] [int] NULL,
	[LegScore] [nchar](15) NULL,
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
	[TimeStatu] [int] NULL,
 CONSTRAINT [PK_EventDetail] PRIMARY KEY CLUSTERED 
(
	[EventDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventDetail]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_EventDetail] ON [Virtual].[EventDetail]
(
	[EventId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
