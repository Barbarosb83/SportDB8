USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[Score]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[Score](
	[ScoreId] [bigint] IDENTITY(1,1) NOT NULL,
	[MatchId] [bigint] NULL,
	[HalfTimeScore] [nvarchar](50) NULL,
	[FullTimeScore] [nvarchar](50) NULL,
	[MatchDate] [datetime] NULL,
	[HomeTeamId] [bigint] NULL,
	[AwayTeamId] [bigint] NULL,
	[SportId] [int] NULL,
	[TournamentId] [bigint] NULL,
 CONSTRAINT [PK_Score_1] PRIMARY KEY CLUSTERED 
(
	[ScoreId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
