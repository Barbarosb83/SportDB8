USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[EventTopOdd]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[EventTopOdd](
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
 CONSTRAINT [PK_EventTopOdd] PRIMARY KEY CLUSTERED 
(
	[EventTopOddId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Virtual].[EventTopOdd] ADD  CONSTRAINT [DF_EventTopOdd_ThreeWay1State]  DEFAULT ((0)) FOR [ThreeWay1State]
GO
ALTER TABLE [Virtual].[EventTopOdd] ADD  CONSTRAINT [DF_EventTopOdd_ThreeWayXState]  DEFAULT ((0)) FOR [ThreeWayXState]
GO
ALTER TABLE [Virtual].[EventTopOdd] ADD  CONSTRAINT [DF_EventTopOdd_ThreeWay2State]  DEFAULT ((0)) FOR [ThreeWay2State]
GO
ALTER TABLE [Virtual].[EventTopOdd] ADD  CONSTRAINT [DF_EventTopOdd_RestThreeWay1State]  DEFAULT ((0)) FOR [RestThreeWay1State]
GO
ALTER TABLE [Virtual].[EventTopOdd] ADD  CONSTRAINT [DF_EventTopOdd_RestThreeWayXState]  DEFAULT ((0)) FOR [RestThreeWayXState]
GO
ALTER TABLE [Virtual].[EventTopOdd] ADD  CONSTRAINT [DF_EventTopOdd_RestThreeWay2State]  DEFAULT ((0)) FOR [RestThreeWay2State]
GO
