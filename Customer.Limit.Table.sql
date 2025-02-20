USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[Limit]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[Limit](
	[CustomerLimitId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[StakeDailyLimit] [money] NULL,
	[StakeDailyLimitConsumed] [money] NULL,
	[StakeWeeklyLimit] [money] NULL,
	[StakeWeeklyLimitConsumed] [money] NULL,
	[StakeMonthlyLimit] [money] NULL,
	[StakeMonthlyLimitConsumed] [money] NULL,
	[DepositDailyLimit] [money] NULL,
	[DepositDailyLimitConsumed] [money] NULL,
	[DepositWeeklyLimit] [money] NULL,
	[DepositWeeklyLimitConsumed] [money] NULL,
	[DepositMonthlyLimit] [money] NULL,
	[DepositMonthlyLimitConsumed] [money] NULL,
	[LossDailyLimit] [money] NULL,
	[LossDailyLimitConsumed] [money] NULL,
	[LossWeeklyLimit] [money] NULL,
	[LossWeeklyLimitConsumed] [money] NULL,
	[LossMonthlyLimit] [money] NULL,
	[LossMonthlyLimitConsumed] [money] NULL,
	[StakeDailyDate] [datetime] NULL,
	[StakeWeeklyDate] [datetime] NULL,
	[StakeMonthlyDate] [datetime] NULL,
	[DepositDailyDate] [datetime] NULL,
	[DepositWeeklyDate] [datetime] NULL,
	[DepositMounthlyDate] [datetime] NULL,
	[LossDailyDate] [datetime] NULL,
	[LossWeeklyDate] [datetime] NULL,
	[LossMounthlyDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_Limit] PRIMARY KEY CLUSTERED 
(
	[CustomerLimitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Limit]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Limit] ON [Customer].[Limit]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
