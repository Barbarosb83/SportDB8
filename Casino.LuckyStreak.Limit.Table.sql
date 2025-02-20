USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[LuckyStreak.Limit]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[LuckyStreak.Limit](
	[LimitId] [bigint] IDENTITY(1,1) NOT NULL,
	[LimitGroupId] [bigint] NULL,
	[Type] [nvarchar](50) NULL,
 CONSTRAINT [PK_LuckyStreak.Limit] PRIMARY KEY CLUSTERED 
(
	[LimitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
