USE [Tip_SportDB]
GO
/****** Object:  Table [Cache].[Tournament]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cache].[Tournament](
	[CacheTournamentId] [int] IDENTITY(1,1) NOT NULL,
	[TournamentId] [int] NULL,
	[CategoryId] [int] NULL,
	[TournamentSportEventCount] [int] NULL,
	[EndDay] [int] NULL,
 CONSTRAINT [PK_Tournament_1] PRIMARY KEY CLUSTERED 
(
	[CacheTournamentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Tournament_CategoryEndDay]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Tournament_CategoryEndDay] ON [Cache].[Tournament]
(
	[CategoryId] ASC,
	[EndDay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
