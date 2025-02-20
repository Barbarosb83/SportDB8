USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[Odd2]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[Odd2](
	[OddId] [bigint] NOT NULL,
	[OddsTypeId] [int] NOT NULL,
	[OutCome] [nvarchar](50) NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[OddValue] [float] NULL,
	[MatchId] [bigint] NOT NULL,
	[BettradarOddId] [bigint] NULL,
	[Suggestion] [float] NULL,
	[ParameterOddId] [int] NOT NULL,
	[IsOddValueLock] [bit] NULL,
	[BetradarOddTypeId] [bigint] NULL,
	[ParameterSportId] [int] NULL,
	[OutComeId] [int] NULL,
	[BetRadarPlayerId] [nvarchar](50) NULL,
	[BetradarTeamId] [nvarchar](50) NULL,
	[StateId] [int] NULL,
	[BetradarMatchId] [bigint] NOT NULL,
 CONSTRAINT [PK_Odd_2] PRIMARY KEY CLUSTERED 
(
	[OddId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
