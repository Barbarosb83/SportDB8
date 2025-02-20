USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[SlipOdd]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[SlipOdd](
	[SlipOddId] [bigint] NOT NULL,
	[SlipId] [bigint] NOT NULL,
	[OddId] [bigint] NULL,
	[OddValue] [float] NULL,
	[Amount] [money] NULL,
	[StateId] [int] NULL,
	[BetTypeId] [int] NULL,
	[OutCome] [nvarchar](50) NULL,
	[MatchId] [bigint] NULL,
	[OddsTypeId] [int] NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[ParameterOddId] [bigint] NULL,
	[EventName] [nvarchar](150) NULL,
	[EventDate] [datetime] NULL,
	[CurrencyId] [int] NULL,
	[Score] [nvarchar](50) NULL,
	[ScoreTimeStatu] [nvarchar](150) NULL,
	[SportId] [int] NULL,
	[Banko] [int] NULL,
	[BetradarMatchId] [bigint] NULL,
	[OddProbValue] [float] NULL,
 CONSTRAINT [PK_SlipOdd_1] PRIMARY KEY CLUSTERED 
(
	[SlipOddId] DESC,
	[SlipId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [<Name of Missing Index, sysname,>]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [<Name of Missing Index, sysname,>] ON [Archive].[SlipOdd]
(
	[MatchId] ASC
)
INCLUDE([SlipId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_SlipOdd_3]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_SlipOdd_3] ON [Archive].[SlipOdd]
(
	[SlipId] DESC,
	[BetTypeId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
