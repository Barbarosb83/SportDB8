USE [Tip_SportDB]
GO
/****** Object:  Table [Bonus].[Rule]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Bonus].[Rule](
	[BonusRuleId] [int] IDENTITY(1,1) NOT NULL,
	[BonusTypeId] [int] NULL,
	[BonusName] [nvarchar](50) NULL,
	[GameTypeId] [int] NULL,
	[MaxAmount] [money] NULL,
	[MinAmount] [money] NULL,
	[BonusRate] [float] NULL,
	[BonusStartDate] [date] NULL,
	[BonusEndDate] [date] NULL,
	[BonusExpiredDay] [int] NULL,
	[BonusMinOddValue] [float] NULL,
	[BonusOccurences] [int] NULL,
	[ForfeitOnWithdraw] [bit] NULL,
	[MinCombineCount] [int] NULL,
	[SameOddtypeTwoOdds] [bit] NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_Rule_1] PRIMARY KEY CLUSTERED 
(
	[BonusRuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
