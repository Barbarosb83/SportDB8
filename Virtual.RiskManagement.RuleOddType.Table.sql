USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[RiskManagement.RuleOddType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[RiskManagement.RuleOddType](
	[RuleOddTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[RuleId] [bigint] NULL,
	[OddTypeId] [bigint] NULL,
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
