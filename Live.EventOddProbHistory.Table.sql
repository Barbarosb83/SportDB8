USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[EventOddProbHistory]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[EventOddProbHistory](
	[OddId] [bigint] NOT NULL,
	[OddsTypeId] [int] NOT NULL,
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
	[SlipId] [bigint] NULL
) ON [PRIMARY]
GO
