USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Outrights.Competitor]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Outrights.Competitor](
	[EventCompetitorId] [bigint] NOT NULL,
	[EventId] [bigint] NOT NULL,
	[CompetitorId] [bigint] NOT NULL,
	[CompetitorBetradarId] [bigint] NOT NULL,
 CONSTRAINT [PK_Competitor_1] PRIMARY KEY CLUSTERED 
(
	[EventCompetitorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
