USE [Tip_SportDB]
GO
/****** Object:  Table [RiskManagement].[Rule]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RiskManagement].[Rule](
	[RuleId] [bigint] IDENTITY(1,1) NOT NULL,
	[SportId] [bigint] NOT NULL,
	[CategoryId] [bigint] NOT NULL,
	[TournamentId] [bigint] NOT NULL,
	[CompetitorId] [bigint] NOT NULL,
	[StateId] [int] NULL,
	[LossLimit] [money] NULL,
	[LimitPerTicket] [money] NULL,
	[StakeLimit] [money] NULL,
	[AvailabilityId] [int] NULL,
	[MinCombiBranch] [int] NULL,
	[MinCombiInternet] [int] NULL,
	[MinCombiMachine] [int] NULL,
	[StarDate] [datetime] NULL,
	[StopDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[Comment] [nvarchar](450) NULL,
	[IsPopular] [bit] NULL,
	[MaxGainTicket] [money] NULL,
 CONSTRAINT [PK_Rule] PRIMARY KEY CLUSTERED 
(
	[RuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Rule]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Rule] ON [RiskManagement].[Rule]
(
	[TournamentId] ASC,
	[StopDate] ASC,
	[CompetitorId] ASC,
	[IsActive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Rule_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Rule_1] ON [RiskManagement].[Rule]
(
	[CategoryId] ASC,
	[TournamentId] ASC,
	[StopDate] ASC,
	[IsActive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Rule_2]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Rule_2] ON [RiskManagement].[Rule]
(
	[SportId] ASC,
	[CategoryId] ASC,
	[TournamentId] ASC,
	[CompetitorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-20210921-124446]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20210921-124446] ON [RiskManagement].[Rule]
(
	[SportId] ASC,
	[CategoryId] ASC,
	[StopDate] ASC,
	[IsActive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [NonClusteredIndex-20210921-124523]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20210921-124523] ON [RiskManagement].[Rule]
(
	[SportId] ASC,
	[StopDate] ASC,
	[IsActive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
