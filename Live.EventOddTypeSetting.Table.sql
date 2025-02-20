USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[EventOddTypeSetting]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[EventOddTypeSetting](
	[OddTypeSettingId] [bigint] IDENTITY(1,1) NOT NULL,
	[OddTypeId] [int] NOT NULL,
	[StateId] [int] NULL,
	[LossLimit] [money] NULL,
	[LimitPerTicket] [money] NULL,
	[StakeLimit] [money] NULL,
	[AvailabilityId] [int] NULL,
	[MinCombiBranch] [int] NULL,
	[MinCombiInternet] [int] NULL,
	[MinCombiMachine] [int] NULL,
	[MatchId] [int] NOT NULL,
	[PreviousStateId] [int] NULL,
	[IsPopular] [bit] NULL,
	[MaxGainLimit] [money] NULL,
	[BetradarMatchId] [bigint] NULL,
 CONSTRAINT [PK_OddTypeSetting] PRIMARY KEY CLUSTERED 
(
	[OddTypeSettingId] ASC,
	[OddTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventOddTypeSetting]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_EventOddTypeSetting] ON [Live].[EventOddTypeSetting]
(
	[MatchId] ASC,
	[OddTypeId] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventOddTypeSetting_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_EventOddTypeSetting_1] ON [Live].[EventOddTypeSetting]
(
	[BetradarMatchId] ASC,
	[OddTypeId] ASC
)WITH (PAD_INDEX = ON, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
