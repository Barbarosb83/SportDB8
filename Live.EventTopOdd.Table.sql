USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[EventTopOdd]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[EventTopOdd](
	[EventTopOddId] [bigint] IDENTITY(1,1) NOT NULL,
	[EventId] [bigint] NOT NULL,
	[ThreeWay1] [float] NULL,
	[ThreeWayX] [float] NULL,
	[ThreeWay2] [float] NULL,
	[RestThreeWay1] [float] NULL,
	[RestThreeWayX] [float] NULL,
	[RestThreeWay2] [float] NULL,
	[Total] [nvarchar](50) NULL,
	[TotalOver] [float] NULL,
	[TotalUnder] [float] NULL,
	[NextGoal1] [float] NULL,
	[NextGoalX] [float] NULL,
	[NextGoal2] [float] NULL,
	[ThreeWay1State] [int] NULL,
	[ThreeWayXState] [int] NULL,
	[ThreeWay2State] [int] NULL,
	[RestThreeWay1State] [int] NULL,
	[RestThreeWayXState] [int] NULL,
	[RestThreeWay2State] [int] NULL,
	[TotalOverState] [int] NULL,
	[TotalUnderState] [int] NULL,
	[NextGoal1State] [int] NULL,
	[NextGoalXState] [int] NULL,
	[NextGoal2State] [int] NULL,
	[ThreeWay1Change] [int] NULL,
	[ThreeWayXChange] [int] NULL,
	[ThreeWay2Change] [int] NULL,
	[RestThreeWay1Change] [int] NULL,
	[RestThreeWayXChange] [int] NULL,
	[RestThreeWay2Change] [int] NULL,
	[TotalOverChange] [int] NULL,
	[TotalUnderChange] [int] NULL,
	[NextGoal1Change] [int] NULL,
	[NextGoalXChange] [int] NULL,
	[NextGoal2Change] [int] NULL,
	[ThreeWay1Id] [int] NULL,
	[ThreeWayXId] [int] NULL,
	[ThreeWay2Id] [int] NULL,
	[RestThreeWay1Id] [int] NULL,
	[RestThreeWayXId] [int] NULL,
	[RestThreeWay2Id] [int] NULL,
	[TotalOverId] [int] NULL,
	[TotalUnderId] [int] NULL,
	[NextGoal1Id] [int] NULL,
	[NextGoalXId] [int] NULL,
	[NextGoal2Id] [int] NULL,
	[BetradarMatchId] [bigint] NOT NULL,
 CONSTRAINT [PK_EventTopOdd] PRIMARY KEY CLUSTERED 
(
	[EventTopOddId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Live].[EventTopOdd] SET (LOCK_ESCALATION = AUTO)
GO
/****** Object:  Index [IX_EventTopOdd]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_EventTopOdd] ON [Live].[EventTopOdd]
(
	[BetradarMatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventTopOdd_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_EventTopOdd_1] ON [Live].[EventTopOdd]
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventTopOdd_2]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED COLUMNSTORE INDEX [IX_EventTopOdd_2] ON [Live].[EventTopOdd]
(
	[EventId],
	[ThreeWay1]
)WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0, DATA_COMPRESSION = COLUMNSTORE) ON [PRIMARY]
GO
ALTER TABLE [Live].[EventTopOdd] ADD  CONSTRAINT [DF_EventTopOdd_ThreeWay1State]  DEFAULT ((0)) FOR [ThreeWay1State]
GO
ALTER TABLE [Live].[EventTopOdd] ADD  CONSTRAINT [DF_EventTopOdd_ThreeWayXState]  DEFAULT ((0)) FOR [ThreeWayXState]
GO
ALTER TABLE [Live].[EventTopOdd] ADD  CONSTRAINT [DF_EventTopOdd_ThreeWay2State]  DEFAULT ((0)) FOR [ThreeWay2State]
GO
ALTER TABLE [Live].[EventTopOdd] ADD  CONSTRAINT [DF_EventTopOdd_RestThreeWay1State]  DEFAULT ((0)) FOR [RestThreeWay1State]
GO
ALTER TABLE [Live].[EventTopOdd] ADD  CONSTRAINT [DF_EventTopOdd_RestThreeWayXState]  DEFAULT ((0)) FOR [RestThreeWayXState]
GO
ALTER TABLE [Live].[EventTopOdd] ADD  CONSTRAINT [DF_EventTopOdd_RestThreeWay2State]  DEFAULT ((0)) FOR [RestThreeWay2State]
GO
