USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[RealGaming.AmaticGameSetting]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[RealGaming.AmaticGameSetting](
	[AmaticGameSettingId] [int] IDENTITY(1,1) NOT NULL,
	[OperatorName] [nvarchar](150) NULL,
	[ClienId] [nvarchar](250) NULL,
	[Secret] [nvarchar](150) NULL,
	[AuthUrl] [nvarchar](250) NULL,
	[LobbyUrl] [nvarchar](250) NULL,
	[AccessToken] [nvarchar](250) NULL,
	[RefreshToken] [nvarchar](250) NULL,
	[Passwords] [nvarchar](150) NULL,
	[ExitUrl] [nvarchar](max) NULL,
	[RemoteUrl] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
