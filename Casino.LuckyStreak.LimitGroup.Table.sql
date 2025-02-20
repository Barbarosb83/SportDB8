USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[LuckyStreak.LimitGroup]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[LuckyStreak.LimitGroup](
	[LimitGroupId] [bigint] IDENTITY(1,1) NOT NULL,
	[GameId] [bigint] NOT NULL,
	[LimitTypeId] [int] NULL,
	[Name] [nvarchar](150) NULL,
	[GroupId] [nvarchar](24) NULL,
 CONSTRAINT [PK_LuckyStreak.LimitGroup] PRIMARY KEY CLUSTERED 
(
	[LimitGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
