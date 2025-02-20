USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[TournamentOutrights]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[TournamentOutrights](
	[TournamentId] [int] IDENTITY(1,1) NOT NULL,
	[BetradarTournamentId] [int] NOT NULL,
	[CategoryId] [int] NULL,
	[TournamentName] [nvarchar](150) NULL,
	[IsActive] [bit] NULL,
	[BetradarUnigueId] [bigint] NULL,
	[Limit] [money] NULL,
	[LimitPerTicket] [money] NULL,
	[AvailabilityId] [int] NULL,
	[SequenceNumber] [int] NULL,
 CONSTRAINT [PK_TournamentOutrights] PRIMARY KEY CLUSTERED 
(
	[TournamentId] DESC,
	[BetradarTournamentId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_BBPTO]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BBPTO] ON [Parameter].[TournamentOutrights]
(
	[IsActive] ASC
)
INCLUDE([TournamentId],[CategoryId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TournamentOutrights]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_TournamentOutrights] ON [Parameter].[TournamentOutrights]
(
	[BetradarTournamentId] ASC
)
INCLUDE([TournamentId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_TournamentOutrights_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_TournamentOutrights_1] ON [Parameter].[TournamentOutrights]
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
