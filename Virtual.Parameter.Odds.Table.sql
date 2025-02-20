USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[Parameter.Odds]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[Parameter.Odds](
	[OddsId] [int] IDENTITY(1,1) NOT NULL,
	[OddTypeId] [int] NOT NULL,
	[Outcomes] [nvarchar](20) NULL,
	[SpecialBetValue] [nchar](10) NULL,
	[SettledInOverTime] [bit] NULL,
	[OutcomesDescription] [nvarchar](250) NULL,
	[MatchTimeTypeId] [int] NULL,
 CONSTRAINT [PK_Parameter.Odds] PRIMARY KEY CLUSTERED 
(
	[OddsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
