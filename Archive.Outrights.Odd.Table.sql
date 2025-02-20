USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Outrights.Odd]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Outrights.Odd](
	[OddId] [bigint] NOT NULL,
	[OddsTypeId] [bigint] NOT NULL,
	[OutCome] [nvarchar](150) NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[OddValue] [float] NULL,
	[MatchId] [bigint] NULL,
	[BettradarOddId] [bigint] NULL,
	[Suggestion] [float] NULL,
	[ParameterOddId] [bigint] NULL,
	[IsOddValueLock] [bit] NULL,
	[BetradarOddTypeId] [bigint] NULL,
	[ParameterSportId] [bigint] NULL,
	[CompetitorId] [bigint] NULL,
	[SwCode] [int] NULL,
 CONSTRAINT [PK_Odd_3] PRIMARY KEY CLUSTERED 
(
	[OddId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
