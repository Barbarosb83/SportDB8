USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[Standings]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[Standings](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](250) NULL,
	[SportId] [int] NULL,
	[CategoryId] [int] NULL,
	[TournamentId] [int] NULL,
	[TeamId] [bigint] NULL,
	[Season] [nvarchar](50) NULL,
	[TeamName] [nvarchar](150) NULL,
	[Rank] [int] NULL,
	[CurrentOutcome] [nvarchar](150) NULL,
	[Played] [int] NULL,
	[Win] [int] NULL,
	[Draw] [int] NULL,
	[Loss] [int] NULL,
	[GoalFor] [int] NULL,
	[GoalAgainst] [int] NULL,
	[GoalDiff] [int] NULL,
	[Points] [int] NULL,
 CONSTRAINT [PK_Standings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Standings]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Standings] ON [Match].[Standings]
(
	[TournamentId] ASC,
	[TeamId] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
