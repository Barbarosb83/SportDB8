USE [Tip_SportDB]
GO
/****** Object:  Table [Cache].[Fixture]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cache].[Fixture](
	[CacheMatchId] [bigint] IDENTITY(1,1) NOT NULL,
	[BetradarMatchId] [bigint] NOT NULL,
	[MatchId] [bigint] NOT NULL,
	[MatchDate] [datetime] NOT NULL,
	[HomeTeam] [int] NOT NULL,
	[AwayTeam] [int] NOT NULL,
	[SportName] [nvarchar](50) NOT NULL,
	[OddId1] [bigint] NULL,
	[OddValue1] [float] NULL,
	[Odd1Visibility] [nchar](6) NULL,
	[OddId2] [bigint] NULL,
	[OddValue2] [float] NULL,
	[Odd1Visibility2] [nchar](6) NULL,
	[OddId3] [bigint] NULL,
	[OddValue3] [float] NULL,
	[Odd1Visibility3] [nchar](6) NULL,
	[OddTypeCount] [int] NULL,
	[TournamentId] [int] NOT NULL,
	[IsPopular] [bit] NULL,
	[SportId] [int] NULL,
	[NeutralGround] [bit] NULL,
 CONSTRAINT [PK_Fixture_1] PRIMARY KEY CLUSTERED 
(
	[CacheMatchId] ASC,
	[BetradarMatchId] ASC,
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_BBCF]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_BBCF] ON [Cache].[Fixture]
(
	[MatchId] ASC
)
INCLUDE([OddValue1],[OddValue2],[OddValue3]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Fixture]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Fixture] ON [Cache].[Fixture]
(
	[MatchDate] ASC,
	[TournamentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Fixture_2]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Fixture_2] ON [Cache].[Fixture]
(
	[SportId] ASC,
	[MatchDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Fixture_3]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Fixture_3] ON [Cache].[Fixture]
(
	[MatchId] ASC,
	[MatchDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Fixture_4]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Fixture_4] ON [Cache].[Fixture]
(
	[MatchDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Fixture_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED COLUMNSTORE INDEX [IX_Fixture_1] ON [Cache].[Fixture]
(
	[MatchId],
	[MatchDate],
	[SportId]
)WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0, DATA_COMPRESSION = COLUMNSTORE) ON [PRIMARY]
GO
