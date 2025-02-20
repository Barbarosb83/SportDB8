USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[EventOddResult]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[EventOddResult](
	[OddresultId] [bigint] IDENTITY(1,1) NOT NULL,
	[BetradarOddId] [bigint] NOT NULL,
	[OddsTypeId] [int] NULL,
	[OutCome] [nvarchar](150) NOT NULL,
	[SpecialBetValue] [nvarchar](150) NULL,
	[OddResult] [bit] NOT NULL,
	[VoidFactor] [float] NULL,
	[IsCanceled] [bit] NULL,
	[IsEvaluated] [bit] NULL,
	[OddFactor] [float] NULL,
	[EvaluatedDate] [datetime] NULL,
	[BetradarOddsTypeId] [bigint] NOT NULL,
	[BetradarOddsSubTypeId] [bigint] NULL,
	[StateId] [int] NULL,
	[BetradarMatchId] [bigint] NULL,
	[OddId] [bigint] NULL,
 CONSTRAINT [PK_EventOddResult] PRIMARY KEY CLUSTERED 
(
	[OddresultId] DESC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_EventOddResult]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOddResult] ON [Live].[EventOddResult]
(
	[BetradarOddId] ASC,
	[BetradarMatchId] ASC,
	[OutCome] ASC,
	[SpecialBetValue] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventOddResult_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOddResult_1] ON [Live].[EventOddResult]
(
	[OddId] DESC,
	[IsCanceled] DESC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventOddResult_2]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOddResult_2] ON [Live].[EventOddResult]
(
	[IsEvaluated] ASC,
	[IsCanceled] ASC,
	[OddId] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventOddResult_3]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOddResult_3] ON [Live].[EventOddResult]
(
	[BetradarMatchId] ASC,
	[BetradarOddsSubTypeId] ASC,
	[BetradarOddsTypeId] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_EventOddResult_4]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOddResult_4] ON [Live].[EventOddResult]
(
	[BetradarMatchId] DESC,
	[OddsTypeId] DESC,
	[OddResult] DESC,
	[SpecialBetValue] DESC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventOddResult_5]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOddResult_5] ON [Live].[EventOddResult]
(
	[OddId] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
