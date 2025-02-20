USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[RiskManagement.RuleOddType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[RiskManagement.RuleOddType](
	[RuleOddTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[RuleId] [bigint] NOT NULL,
	[OddTypeId] [bigint] NOT NULL,
	[StateId] [int] NULL,
	[LossLimit] [money] NULL,
	[LimitPerTicket] [money] NULL,
	[StakeLimit] [money] NULL,
	[AvailabilityId] [int] NULL,
	[MinCombiBranch] [int] NULL,
	[MinCombiInternet] [int] NULL,
	[MinCombiMachine] [int] NULL,
	[Comment] [nvarchar](450) NULL,
	[IsPopular] [bit] NULL,
	[MaxGainTicket] [money] NULL,
 CONSTRAINT [PK_RuleOddType] PRIMARY KEY CLUSTERED 
(
	[RuleOddTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_RiskManagement.RuleOddType]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_RiskManagement.RuleOddType] ON [Live].[RiskManagement.RuleOddType]
(
	[OddTypeId] ASC,
	[RuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
