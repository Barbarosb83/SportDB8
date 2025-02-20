USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Goal]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Goal](
	[GoalId] [int] NOT NULL,
	[BetradarGoalId] [bigint] NULL,
	[MatchId] [bigint] NULL,
	[ScoringTeamId] [bigint] NULL,
	[Team1Score] [int] NULL,
	[Team2Score] [int] NULL,
	[PlayerId] [int] NULL,
	[Time] [nvarchar](10) NULL,
	[Doubtful] [bit] NULL,
	[PlayerName] [nvarchar](250) NULL,
 CONSTRAINT [PK_Goal_1] PRIMARY KEY CLUSTERED 
(
	[GoalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
