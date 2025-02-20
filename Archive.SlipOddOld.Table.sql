USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[SlipOddOld]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[SlipOddOld](
	[SlipOddId] [bigint] NOT NULL,
	[SlipId] [bigint] NULL,
	[OddId] [bigint] NULL,
	[OddValue] [float] NULL,
	[Amount] [money] NULL,
	[StateId] [int] NULL,
	[BetTypeId] [int] NULL,
	[OutCome] [nvarchar](50) NULL,
	[MatchId] [bigint] NULL,
	[OddsTypeId] [int] NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[ParameterOddId] [int] NULL,
	[EventName] [nvarchar](150) NULL,
	[EventDate] [datetime] NULL,
	[CurrencyId] [int] NULL,
	[Score] [nvarchar](50) NULL,
	[ScoreTimeStatu] [nvarchar](150) NULL,
	[SportId] [int] NULL,
	[Banko] [int] NULL,
	[BetradarMatchId] [bigint] NULL,
	[OddProbValue] [float] NULL,
 CONSTRAINT [PK_SlipOddOld_1] PRIMARY KEY CLUSTERED 
(
	[SlipOddId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_SlipOddOld]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_SlipOddOld] ON [Archive].[SlipOddOld]
(
	[SlipId] ASC,
	[BetTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
