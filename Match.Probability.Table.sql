USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[Probability]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[Probability](
	[ProbabilityId] [int] IDENTITY(1,1) NOT NULL,
	[OddsTypeId] [int] NULL,
	[OutCome] [nvarchar](50) NULL,
	[OutComeId] [int] NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[CompetitorId] [bigint] NULL,
	[ProbabilityValue] [float] NULL,
	[MatchId] [bigint] NULL,
	[TeamPlayerId] [bigint] NULL,
 CONSTRAINT [PK_Probability] PRIMARY KEY CLUSTERED 
(
	[ProbabilityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Probability_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Probability_1] ON [Match].[Probability]
(
	[MatchId] ASC,
	[OddsTypeId] ASC,
	[OutCome] ASC,
	[SpecialBetValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
