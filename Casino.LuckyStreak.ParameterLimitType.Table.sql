USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[LuckyStreak.ParameterLimitType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[LuckyStreak.ParameterLimitType](
	[LimitTypeId] [bigint] NOT NULL,
	[Name] [nvarchar](150) NULL,
	[Payout] [nvarchar](150) NULL,
	[GameId] [bigint] NULL,
 CONSTRAINT [PK_LuckyStreak.ParameterLimitType] PRIMARY KEY CLUSTERED 
(
	[LimitTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
