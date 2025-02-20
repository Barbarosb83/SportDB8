USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[FixtureCompetitor]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[FixtureCompetitor](
	[FixtureCompetitorId] [int] NOT NULL,
	[FixtureId] [int] NOT NULL,
	[CompetitorId] [bigint] NOT NULL,
	[TypeId] [int] NULL,
 CONSTRAINT [PK_FixtureCompetitor_1] PRIMARY KEY CLUSTERED 
(
	[FixtureCompetitorId] DESC,
	[FixtureId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_FixtureCompetitor_3]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_FixtureCompetitor_3] ON [Archive].[FixtureCompetitor]
(
	[FixtureId] DESC,
	[CompetitorId] ASC,
	[TypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
