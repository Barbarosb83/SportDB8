USE [Tip_SportDB]
GO
/****** Object:  Table [dbo].[tempLiveEvent]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tempLiveEvent](
	[BetradarSportId] [bigint] NULL,
	[BetradarCategoryId] [bigint] NULL,
	[BetradarTournamentId] [bigint] NULL,
	[BetradarHomeTeamId] [bigint] NULL,
	[BetradarAwayTeamId] [bigint] NULL,
	[DateOfMatch] [datetime] NULL,
	[BetradarMatchId] [bigint] NULL
) ON [PRIMARY]
GO
