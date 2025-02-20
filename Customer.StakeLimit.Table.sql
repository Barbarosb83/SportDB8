USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[StakeLimit]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[StakeLimit](
	[CustomerStakeId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[CreditLimit] [money] NULL,
	[LimitPerTicket] [money] NULL,
	[MaxStakeGame] [money] NULL,
	[MaxStakeFactor] [float] NULL,
	[MaxStakeGamePercent] [float] NULL,
	[LimitPerLiveTicket] [money] NULL,
	[StakeDay] [money] NULL,
	[StakeWeek] [money] NULL,
	[StakeMonth] [money] NULL,
	[MinCombiBranch] [int] NULL,
	[MinCombiInternet] [int] NULL,
	[MinCombiMachine] [int] NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUser] [nvarchar](50) NULL,
	[PendingTime] [int] NULL,
	[DepositDay] [money] NULL,
	[DepositWeek] [money] NULL,
	[DepositMonth] [money] NULL,
	[LossDay] [money] NULL,
	[LossWeek] [money] NULL,
	[LossMonth] [money] NULL,
 CONSTRAINT [PK_StakeLimit] PRIMARY KEY CLUSTERED 
(
	[CustomerStakeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_StakeLimit]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_StakeLimit] ON [Customer].[StakeLimit]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_StakeLimit_1]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_StakeLimit_1] ON [Customer].[StakeLimit]
(
	[CustomerId] ASC,
	[UpdateUser] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
