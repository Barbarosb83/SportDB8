USE [Tip_SportDB]
GO
/****** Object:  Table [Bonus].[RuleDays]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Bonus].[RuleDays](
	[RuleDaysId] [int] IDENTITY(1,1) NOT NULL,
	[RuleId] [int] NULL,
	[ParameterDayId] [int] NULL
) ON [PRIMARY]
GO
