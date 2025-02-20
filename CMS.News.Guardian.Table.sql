USE [Tip_SportDB]
GO
/****** Object:  Table [CMS].[News.Guardian]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CMS].[News.Guardian](
	[newsId] [bigint] IDENTITY(1,1) NOT NULL,
	[id] [nvarchar](150) NULL,
	[webPublicationDate] [datetime] NULL,
	[webTitle] [nvarchar](max) NULL,
	[webUrl] [nvarchar](max) NULL,
	[headline] [nvarchar](max) NULL,
	[trailText] [nvarchar](max) NULL,
	[body] [nvarchar](max) NULL,
	[thumbnail] [nvarchar](max) NULL,
	[languageId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
