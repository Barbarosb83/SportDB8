USE [Tip_SportDB]
GO
/****** Object:  Table [Stadium].[Rule]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stadium].[Rule](
	[StadiumRuleId] [bigint] IDENTITY(1,1) NOT NULL,
	[BranchId] [bigint] NULL,
	[OpenHours] [int] NULL,
	[EntranceFee] [money] NULL,
	[CurrencyId] [int] NULL,
	[MaxPlayer] [int] NULL,
	[MinPlayer] [int] NULL,
	[MinOddValue] [float] NULL,
	[MaxOddValue] [float] NULL,
	[ServiceFee] [float] NULL,
	[CardChangeCount] [int] NULL,
	[CardView] [bit] NULL,
	[IsRepeat] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[RuleStartDate] [datetime] NULL,
	[RuleEndDate] [datetime] NULL,
	[RuleIsActive] [bit] NULL
) ON [PRIMARY]
GO
