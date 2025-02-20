USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[Parameter.Odds]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[Parameter.Odds](
	[OddsId] [int] IDENTITY(1,1) NOT NULL,
	[OddTypeId] [int] NOT NULL,
	[Outcomes] [nvarchar](20) NULL,
	[SpecialBetValue] [nchar](10) NULL,
	[SettledInOverTime] [bit] NULL,
	[OutcomesDescription] [nvarchar](250) NULL,
	[MatchTimeTypeId] [int] NULL,
 CONSTRAINT [PK_Parameter.Odds] PRIMARY KEY CLUSTERED 
(
	[OddsId] ASC,
	[OddTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Parameter.Odds]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Parameter.Odds] ON [Live].[Parameter.Odds]
(
	[OddTypeId] ASC,
	[Outcomes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
