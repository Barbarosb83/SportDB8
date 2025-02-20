USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[LuckyStreak.Customer]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[LuckyStreak.Customer](
	[LuckyStreakCustomerId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[GameId] [bigint] NULL,
	[AuthCode] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
