USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[Event]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[Event](
	[EventId] [bigint] IDENTITY(1,1) NOT NULL,
	[BetradarMatchId] [bigint] NULL,
	[MonitoringMatchId] [bigint] NULL,
	[TournamentId] [int] NULL,
	[EventDate] [datetime] NULL,
	[HomeTeam] [int] NULL,
	[AwayTeam] [int] NULL,
	[LastScore] [char](10) NULL,
	[FeedStatu] [bit] NULL,
	[EventStatu] [int] NULL,
	[Manager] [int] NULL,
	[ConnectionStatu] [int] NULL,
	[IsActive] [bit] NULL,
	[TournamentName] [nvarchar](250) NULL,
	[MatchDay] [varchar](15) NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Event]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Event] ON [Virtual].[Event]
(
	[BetradarMatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Event_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Event_1] ON [Virtual].[Event]
(
	[TournamentName] ASC,
	[MatchDay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Virtual].[Event] ADD  CONSTRAINT [DF_Event_FeedStatu]  DEFAULT ((1)) FOR [FeedStatu]
GO
ALTER TABLE [Virtual].[Event] ADD  CONSTRAINT [DF_Event_ConnectionStatu]  DEFAULT ((1)) FOR [ConnectionStatu]
GO
