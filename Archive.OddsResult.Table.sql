USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[OddsResult]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[OddsResult](
	[OddsResultId] [bigint] NOT NULL,
	[MatchId] [bigint] NULL,
	[OddsTypeId] [int] NOT NULL,
	[Outcome] [nvarchar](50) NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[VoidFactor] [float] NULL,
	[OutcomeId] [int] NULL,
	[PlayerId] [int] NULL,
	[CompetitorId] [int] NULL,
	[Status] [bit] NULL,
	[Reason] [nvarchar](50) NULL,
	[BetradarOddTypeId] [bigint] NULL,
	[IsEvoluate] [bit] NULL,
 CONSTRAINT [PK_OddsResult_1] PRIMARY KEY CLUSTERED 
(
	[OddsResultId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_OddsResult_2]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_OddsResult_2] ON [Archive].[OddsResult]
(
	[MatchId] DESC,
	[OddsTypeId] ASC,
	[Outcome] ASC,
	[SpecialBetValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
