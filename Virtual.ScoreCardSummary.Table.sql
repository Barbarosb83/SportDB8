USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[ScoreCardSummary]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[ScoreCardSummary](
	[ScoreCardId] [bigint] IDENTITY(1,1) NOT NULL,
	[EventId] [bigint] NOT NULL,
	[BetradarId] [bigint] NOT NULL,
	[ScoreCardType] [int] NOT NULL,
	[CardType] [int] NOT NULL,
	[AffectedPlayers] [nvarchar](100) NULL,
	[AffectedTeam] [int] NULL,
	[PlayerId] [bigint] NULL,
	[IsCanceled] [bit] NULL,
	[Time] [int] NULL,
 CONSTRAINT [PK_ScoreCardSummary] PRIMARY KEY CLUSTERED 
(
	[ScoreCardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
