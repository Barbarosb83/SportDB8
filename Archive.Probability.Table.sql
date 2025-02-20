USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Probability]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Probability](
	[ProbabilityId] [int] NOT NULL,
	[OddsTypeId] [int] NOT NULL,
	[OutCome] [nvarchar](50) NULL,
	[OutComeId] [int] NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[CompetitorId] [bigint] NULL,
	[ProbabilityValue] [float] NULL,
	[MatchId] [bigint] NULL,
	[TeamPlayerId] [bigint] NULL,
 CONSTRAINT [PK_Probability_1] PRIMARY KEY CLUSTERED 
(
	[ProbabilityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
