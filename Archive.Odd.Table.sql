USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Odd]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Odd](
	[OddId] [bigint] NOT NULL,
	[OddsTypeId] [int] NOT NULL,
	[OutCome] [nvarchar](50) NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[OddValue] [float] NULL,
	[MatchId] [bigint] NULL,
	[BettradarOddId] [bigint] NULL,
	[Suggestion] [float] NULL,
	[ParameterOddId] [int] NULL,
	[IsOddValueLock] [bit] NULL,
	[BetradarOddTypeId] [bigint] NULL,
	[ParameterSportId] [int] NULL,
	[OutComeId] [int] NULL,
	[BetRadarPlayerId] [nvarchar](50) NULL,
	[BetradarTeamId] [nvarchar](50) NULL,
	[StateId] [int] NULL,
	[BetradarMatchId] [bigint] NULL,
 CONSTRAINT [PK_Odd_2] PRIMARY KEY CLUSTERED 
(
	[OddId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Odd]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Odd] ON [Archive].[Odd]
(
	[OddsTypeId] ASC,
	[MatchId] ASC,
	[OutCome] ASC,
	[SpecialBetValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Odd_1]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Odd_1] ON [Archive].[Odd]
(
	[MatchId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Odd_8]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Odd_8] ON [Archive].[Odd]
(
	[OddId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
