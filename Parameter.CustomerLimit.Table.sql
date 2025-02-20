USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[CustomerLimit]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[CustomerLimit](
	[ParameterLimitId] [int] IDENTITY(1,1) NOT NULL,
	[StakeDailyLimit] [money] NULL,
	[StakeWeeklyLimit] [money] NULL,
	[StakeMonthlyLimit] [money] NULL,
	[DepositDailyLimit] [money] NULL,
	[DepositWeeklyLimit] [money] NULL,
	[DepositMonthlyLimit] [money] NULL,
	[LossDailyLimit] [money] NULL,
	[LossWeeklyLimit] [money] NULL,
	[LossMonthlyLimit] [money] NULL,
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
	[LimitPerVirtualTicket] [money] NULL,
 CONSTRAINT [PK_CustomerLimit] PRIMARY KEY CLUSTERED 
(
	[ParameterLimitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
