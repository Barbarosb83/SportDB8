USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Live.Event]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Live.Event](
	[EventId] [bigint] NOT NULL,
	[BetradarMatchId] [bigint] NOT NULL,
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
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[EventId] DESC,
	[BetradarMatchId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Live.Event]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Live.Event] ON [Archive].[Live.Event]
(
	[BetradarMatchId] DESC,
	[IsActive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Archive].[Live.Event] ADD  CONSTRAINT [DF_Event_FeedStatu]  DEFAULT ((1)) FOR [FeedStatu]
GO
ALTER TABLE [Archive].[Live.Event] ADD  CONSTRAINT [DF_Event_ConnectionStatu]  DEFAULT ((1)) FOR [ConnectionStatu]
GO
