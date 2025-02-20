USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[BetFair]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[BetFair](
	[BetFairId] [bigint] IDENTITY(1,1) NOT NULL,
	[MatchId] [bigint] NULL,
	[EventId] [bigint] NULL,
	[SportId] [int] NULL,
	[Runner1] [int] NULL,
	[Runner2] [int] NULL,
 CONSTRAINT [PK_BetFair] PRIMARY KEY CLUSTERED 
(
	[BetFairId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
