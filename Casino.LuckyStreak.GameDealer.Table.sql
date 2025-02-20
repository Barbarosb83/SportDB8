USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[LuckyStreak.GameDealer]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[LuckyStreak.GameDealer](
	[GameDealerId] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NULL,
	[AvatarUrl] [nvarchar](max) NULL,
	[ThumbnailAvatarURL] [nvarchar](max) NULL,
 CONSTRAINT [PK_LuckyStreak.GameDealer] PRIMARY KEY CLUSTERED 
(
	[GameDealerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
