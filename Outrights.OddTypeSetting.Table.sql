USE [Tip_SportDB]
GO
/****** Object:  Table [Outrights].[OddTypeSetting]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Outrights].[OddTypeSetting](
	[OddTypeSettingId] [bigint] IDENTITY(1,1) NOT NULL,
	[OddTypeId] [int] NULL,
	[StateId] [int] NULL,
	[LossLimit] [money] NULL,
	[LimitPerTicket] [money] NULL,
	[StakeLimit] [money] NULL,
	[AvailabilityId] [int] NULL,
	[MinCombiBranch] [int] NULL,
	[MinCombiInternet] [int] NULL,
	[MinCombiMachine] [int] NULL,
	[MatchId] [int] NULL,
	[PreviousStateId] [int] NULL,
	[IsPopular] [bit] NULL,
	[MaxGainLimit] [money] NULL,
 CONSTRAINT [PK_OddTypeSetting_2] PRIMARY KEY CLUSTERED 
(
	[OddTypeSettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_OddTypeSetting_4]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_OddTypeSetting_4] ON [Outrights].[OddTypeSetting]
(
	[OddTypeId] ASC,
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
