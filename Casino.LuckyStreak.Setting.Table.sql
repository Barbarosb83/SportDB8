USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[LuckyStreak.Setting]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[LuckyStreak.Setting](
	[LuckyStreakSettingId] [int] IDENTITY(1,1) NOT NULL,
	[OperatorName] [nvarchar](max) NULL,
	[ClientId] [nvarchar](max) NULL,
	[Secret] [nvarchar](max) NULL,
	[AuthUrl] [nvarchar](max) NULL,
	[LobbyUrl] [nvarchar](max) NULL,
	[AccessToken] [nvarchar](max) NULL,
	[RefreshToken] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
