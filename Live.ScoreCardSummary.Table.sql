USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[ScoreCardSummary]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[ScoreCardSummary](
	[ScoreCardId] [bigint] IDENTITY(1,1) NOT NULL,
	[EventId] [bigint] NOT NULL,
	[BetradarId] [bigint] NOT NULL,
	[ScoreCardType] [int] NOT NULL,
	[CardType] [int] NOT NULL,
	[AffectedPlayers] [nvarchar](100) NULL,
	[AffectedTeam] [int] NULL,
	[PlayerId] [bigint] NULL,
	[IsCanceled] [bit] NULL,
	[Time] [int] NULL,
 CONSTRAINT [PK_ScoreCardSummary] PRIMARY KEY CLUSTERED 
(
	[ScoreCardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScoreCardSummary]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_ScoreCardSummary] ON [Live].[ScoreCardSummary]
(
	[EventId] ASC,
	[ScoreCardType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScoreCardSummary_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_ScoreCardSummary_1] ON [Live].[ScoreCardSummary]
(
	[EventId] ASC,
	[ScoreCardType] ASC,
	[AffectedTeam] ASC,
	[IsCanceled] ASC,
	[CardType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScoreCardSummary_2]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ScoreCardSummary_2] ON [Live].[ScoreCardSummary]
(
	[EventId] ASC,
	[BetradarId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScoreCardSummary_3]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ScoreCardSummary_3] ON [Live].[ScoreCardSummary]
(
	[EventId] ASC,
	[BetradarId] ASC,
	[CardType] ASC,
	[ScoreCardType] ASC,
	[AffectedTeam] ASC,
	[Time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScoreCardSummary_4]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_ScoreCardSummary_4] ON [Live].[ScoreCardSummary]
(
	[EventId] ASC,
	[AffectedTeam] ASC,
	[ScoreCardType] ASC,
	[CardType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
