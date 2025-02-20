USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Card]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Card](
	[CardId] [int] NOT NULL,
	[BetradarCardId] [bigint] NOT NULL,
	[Time] [nvarchar](10) NULL,
	[CardTypeId] [int] NULL,
	[PlayerId] [int] NULL,
	[MatchId] [bigint] NOT NULL,
	[Doubtful] [bit] NULL,
	[TeamId] [int] NULL,
	[PlayerName] [nvarchar](250) NULL,
 CONSTRAINT [PK_Card_1] PRIMARY KEY CLUSTERED 
(
	[CardId] ASC,
	[BetradarCardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
