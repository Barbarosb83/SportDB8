USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Live.EventOdd]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Live.EventOdd](
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
	[IsChanged] [int] NULL,
	[IsActive] [bit] NULL,
	[OddResult] [bit] NULL,
	[VoidFactor] [float] NULL,
	[IsCanceled] [bit] NULL,
	[IsEvaluated] [bit] NULL,
	[OddFactor] [float] NULL,
	[BetradarTimeStamp] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[BetradarMatchId] [bigint] NULL,
	[EvaluatedDate] [datetime] NULL,
	[BetradarOddsTypeId] [bigint] NULL,
	[BetradarOddsSubTypeId] [bigint] NULL,
	[StateId] [int] NULL,
	[BetradarPlayerId] [bigint] NULL,
	[GenuisId] [bigint] NULL,
 CONSTRAINT [PK_Odd] PRIMARY KEY CLUSTERED 
(
	[OddId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_EventOdd_7]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOdd_7] ON [Archive].[Live.EventOdd]
(
	[BettradarOddId] ASC,
	[BetradarMatchId] ASC,
	[OutCome] ASC,
	[SpecialBetValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Live.EventOdd]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Live.EventOdd] ON [Archive].[Live.EventOdd]
(
	[MatchId] DESC,
	[OddsTypeId] ASC,
	[OutCome] ASC,
	[SpecialBetValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Live.EventOdd_1]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Live.EventOdd_1] ON [Archive].[Live.EventOdd]
(
	[MatchId] DESC,
	[OddsTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Archive].[Live.EventOdd] ADD  CONSTRAINT [DF_EventOdd_OddFactor]  DEFAULT ((1)) FOR [OddFactor]
GO
