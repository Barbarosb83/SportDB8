USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[LuckyStreak.LimitValue]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[LuckyStreak.LimitValue](
	[LimitValueId] [bigint] IDENTITY(1,1) NOT NULL,
	[LimitId] [bigint] NULL,
	[CurrencyId] [int] NULL,
	[MinValue] [money] NULL,
	[MaxValue] [money] NULL,
 CONSTRAINT [PK_LuckyStreak.LimitValue] PRIMARY KEY CLUSTERED 
(
	[LimitValueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
