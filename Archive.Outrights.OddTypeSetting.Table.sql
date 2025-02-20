USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Outrights.OddTypeSetting]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Outrights.OddTypeSetting](
	[OddTypeSettingId] [bigint] NOT NULL,
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
