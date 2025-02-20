USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[EventOddProb]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[EventOddProb](
	[OddId] [bigint] IDENTITY(1,1) NOT NULL,
	[OddsTypeId] [int] NULL,
	[OutCome] [nvarchar](100) NULL,
	[SpecialBetValue] [nvarchar](100) NULL,
	[ProbilityValue] [nvarchar](50) NULL,
	[MatchId] [bigint] NOT NULL,
	[BettradarOddId] [bigint] NOT NULL,
	[ParameterOddId] [int] NULL,
	[MarketStatus] [int] NULL,
	[CashoutStatus] [int] NULL,
	[BetradarTimeStamp] [datetime] NULL,
	[UpdatedDate] [datetime] NULL,
	[BetradarMatchId] [bigint] NOT NULL,
	[EvaluatedDate] [datetime] NULL,
	[BetradarOddsTypeId] [bigint] NOT NULL,
	[BetradarOddsSubTypeId] [bigint] NULL,
	[OutcomeActive] [bit] NULL,
 CONSTRAINT [PK_OddProb] PRIMARY KEY CLUSTERED 
(
	[OddId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventOddProb_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOddProb_1] ON [Live].[EventOddProb]
(
	[BetradarMatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_EventOddProb_2]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOddProb_2] ON [Live].[EventOddProb]
(
	[BetradarMatchId] ASC,
	[BetradarOddsTypeId] ASC,
	[BetradarOddsSubTypeId] ASC,
	[SpecialBetValue] ASC,
	[CashoutStatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_EventOddProb_3]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOddProb_3] ON [Live].[EventOddProb]
(
	[BetradarMatchId] ASC,
	[BetradarOddsTypeId] ASC,
	[BetradarOddsSubTypeId] ASC,
	[OutCome] ASC,
	[SpecialBetValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
