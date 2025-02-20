USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[EventOdd]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[EventOdd](
	[OddId] [bigint] IDENTITY(1,1) NOT NULL,
	[OddsTypeId] [int] NOT NULL,
	[OutCome] [nvarchar](50) NULL,
	[OutComeId] [int] NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[CompetitorId] [int] NULL,
	[OddValue] [float] NULL,
	[MatchId] [bigint] NULL,
	[PlayerId] [int] NULL,
	[BettradarOddId] [bigint] NULL,
	[Suggestion] [float] NULL,
	[ParameterOddId] [int] NULL,
	[IsOddValueLock] [bit] NULL,
	[IsChanged] [int] NULL,
	[IsActive] [bit] NULL,
	[Combination] [bigint] NULL,
	[ForTheRest] [nchar](30) NULL,
	[Comment] [nchar](30) NULL,
	[MostBalanced] [bit] NULL,
	[OddResult] [bit] NULL,
	[VoidFactor] [float] NULL,
	[IsCanceled] [bit] NULL,
	[IsEvaluated] [bit] NULL,
	[OddFactor] [float] NULL,
 CONSTRAINT [PK_Odd] PRIMARY KEY CLUSTERED 
(
	[OddId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventOdd]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOdd] ON [Virtual].[EventOdd]
(
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_EventOdd_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOdd_1] ON [Virtual].[EventOdd]
(
	[OddsTypeId] ASC,
	[OutCome] ASC,
	[SpecialBetValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Virtual].[EventOdd] ADD  CONSTRAINT [DF_EventOdd_OddFactor]  DEFAULT ((1)) FOR [OddFactor]
GO
