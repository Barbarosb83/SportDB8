USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[Tournament]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[Tournament](
	[TournamentId] [int] IDENTITY(1,1) NOT NULL,
	[BetradarTournamentId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[TournamentName] [nvarchar](150) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[BetradarUnigueId] [bigint] NULL,
	[Limit] [money] NULL,
	[LimitPerTicket] [money] NULL,
	[AvailabilityId] [int] NULL,
	[SequenceNumber] [int] NULL,
	[BetradarTournamentId2] [int] NULL,
	[IsPopularTerminal] [bit] NULL,
	[TerminalTournamentId] [int] NULL,
	[LSId] [int] NULL,
	[NewBetradarId] [int] NULL,
	[IsPopularWeb] [bit] NULL,
 CONSTRAINT [PK_Tournament] PRIMARY KEY CLUSTERED 
(
	[TournamentId] ASC,
	[BetradarTournamentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_BBPT]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BBPT] ON [Parameter].[Tournament]
(
	[NewBetradarId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Tournament]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Tournament] ON [Parameter].[Tournament]
(
	[TournamentId] ASC,
	[CategoryId] ASC,
	[IsPopularTerminal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Tournament_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Tournament_1] ON [Parameter].[Tournament]
(
	[TerminalTournamentId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Tournamentt]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Tournamentt] ON [Parameter].[Tournament]
(
	[CategoryId] ASC
)
INCLUDE([TournamentId],[SequenceNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Parameter].[Tournament] ADD  CONSTRAINT [DF_Tournament_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [Parameter].[Tournament] ADD  CONSTRAINT [DF_Tournament_BetradarUnigueId]  DEFAULT ((0)) FOR [BetradarUnigueId]
GO
ALTER TABLE [Parameter].[Tournament] ADD  CONSTRAINT [DF_Tournament_Limit]  DEFAULT ((0)) FOR [Limit]
GO
ALTER TABLE [Parameter].[Tournament] ADD  CONSTRAINT [DF_Tournament_LimitPerTicket]  DEFAULT ((0)) FOR [LimitPerTicket]
GO
ALTER TABLE [Parameter].[Tournament] ADD  CONSTRAINT [DF_Tournament_AvailabilityId]  DEFAULT ((1)) FOR [AvailabilityId]
GO
ALTER TABLE [Parameter].[Tournament] ADD  CONSTRAINT [DF_Tournament_SequenceNumber]  DEFAULT ((999)) FOR [SequenceNumber]
GO
ALTER TABLE [Parameter].[Tournament] ADD  CONSTRAINT [DF_Tournament_IsPopularWeb]  DEFAULT ((0)) FOR [IsPopularWeb]
GO
