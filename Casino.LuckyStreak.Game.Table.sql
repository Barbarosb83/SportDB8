USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[LuckyStreak.Game]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[LuckyStreak.Game](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[GameId] [bigint] NULL,
	[GameName] [nvarchar](150) NULL,
	[GameTypeId] [int] NULL,
	[IsOpen] [bit] NULL,
	[LaunchUrl] [nvarchar](max) NULL,
	[OpenHour] [nvarchar](10) NULL,
	[CloseHour] [nvarchar](10) NULL,
	[GameDealerId] [bigint] NULL,
	[ParameterGameTypeId] [int] NULL,
 CONSTRAINT [PK_LuckyStreak.Game] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
