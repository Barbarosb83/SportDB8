USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[Goal]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[Goal](
	[GoalId] [int] IDENTITY(1,1) NOT NULL,
	[BetradarGoalId] [bigint] NULL,
	[MatchId] [bigint] NULL,
	[ScoringTeamId] [bigint] NULL,
	[Team1Score] [int] NULL,
	[Team2Score] [int] NULL,
	[PlayerId] [int] NULL,
	[Time] [nvarchar](10) NULL,
	[Doubtful] [bit] NULL,
	[PlayerName] [nvarchar](250) NULL,
 CONSTRAINT [PK_Goal] PRIMARY KEY CLUSTERED 
(
	[GoalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Goal]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Goal] ON [Match].[Goal]
(
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Goal_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Goal_1] ON [Match].[Goal]
(
	[BetradarGoalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Match].[Goal]  WITH CHECK ADD  CONSTRAINT [FK_Goal_TeamPlayer] FOREIGN KEY([PlayerId])
REFERENCES [Parameter].[TeamPlayer] ([TeamPlayerId])
GO
ALTER TABLE [Match].[Goal] CHECK CONSTRAINT [FK_Goal_TeamPlayer]
GO
