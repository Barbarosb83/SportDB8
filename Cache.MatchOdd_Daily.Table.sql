USE [Tip_SportDB]
GO
/****** Object:  Table [Cache].[MatchOdd_Daily]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cache].[MatchOdd_Daily](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[MatchId] [bigint] NOT NULL,
	[OddId] [bigint] NOT NULL,
	[OutCome] [nvarchar](50) NOT NULL,
	[SpecialBetValue] [nvarchar](150) NULL,
	[OddValue] [float] NULL,
	[OddsTypeId] [int] NOT NULL,
	[StateId] [int] NULL,
 CONSTRAINT [PK_MatchOdd_Daily] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_MatchOdd_Daily]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_MatchOdd_Daily] ON [Cache].[MatchOdd_Daily]
(
	[StateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_MatchOdd_Daily_1]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_MatchOdd_Daily_1] ON [Cache].[MatchOdd_Daily]
(
	[MatchId] ASC,
	[OddsTypeId] ASC,
	[OutCome] ASC,
	[SpecialBetValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_MatchOdd_Daily_2]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_MatchOdd_Daily_2] ON [Cache].[MatchOdd_Daily]
(
	[OddsTypeId] ASC,
	[MatchId] ASC,
	[OutCome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
