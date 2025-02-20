USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Live.EventOddResult]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Live.EventOddResult](
	[OddresultId] [bigint] NOT NULL,
	[BetradarOddId] [bigint] NULL,
	[OddsTypeId] [int] NULL,
	[OutCome] [nvarchar](150) NULL,
	[SpecialBetValue] [nvarchar](150) NULL,
	[OddResult] [bit] NULL,
	[VoidFactor] [float] NULL,
	[IsCanceled] [bit] NULL,
	[IsEvaluated] [bit] NULL,
	[OddFactor] [float] NULL,
	[EvaluatedDate] [datetime] NULL,
	[BetradarOddsTypeId] [bigint] NULL,
	[BetradarOddsSubTypeId] [bigint] NULL,
	[StateId] [int] NULL,
	[BetradarMatchId] [bigint] NULL,
	[OddId] [bigint] NULL,
 CONSTRAINT [PK_Live.EventOddResult] PRIMARY KEY CLUSTERED 
(
	[OddresultId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Live.EventOddResult]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Live.EventOddResult] ON [Archive].[Live.EventOddResult]
(
	[OddresultId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Live.EventOddResult_1]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Live.EventOddResult_1] ON [Archive].[Live.EventOddResult]
(
	[BetradarMatchId] DESC,
	[OddsTypeId] DESC,
	[OddResult] DESC,
	[SpecialBetValue] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
