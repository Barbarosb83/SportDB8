USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[OddsResult]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[OddsResult](
	[OddsResultId] [bigint] IDENTITY(1,1) NOT NULL,
	[MatchId] [bigint] NOT NULL,
	[OddsTypeId] [int] NOT NULL,
	[Outcome] [nvarchar](50) NOT NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[VoidFactor] [float] NULL,
	[OutcomeId] [int] NULL,
	[PlayerId] [int] NULL,
	[CompetitorId] [int] NULL,
	[Status] [bit] NULL,
	[Reason] [nvarchar](50) NULL,
	[BetradarOddTypeId] [bigint] NULL,
	[IsEvoluate] [bit] NULL,
 CONSTRAINT [PK_OddsResult] PRIMARY KEY CLUSTERED 
(
	[OddsResultId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Match].[OddsResult] ADD  CONSTRAINT [DF_OddsResult_IsEvoluate]  DEFAULT ((0)) FOR [IsEvoluate]
GO
