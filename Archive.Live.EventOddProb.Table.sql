USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Live.EventOddProb]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Live.EventOddProb](
	[OddId] [bigint] NOT NULL,
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
