USE [Tip_SportDB]
GO
/****** Object:  Table [Retail].[DownloadLink]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Retail].[DownloadLink](
	[DownloadLinkId] [int] IDENTITY(1,1) NOT NULL,
	[DownloadTitle] [nvarchar](150) NOT NULL,
	[DownloadLink] [nvarchar](250) NOT NULL,
	[LangId] [int] NOT NULL,
 CONSTRAINT [PK_DownloadLink] PRIMARY KEY CLUSTERED 
(
	[DownloadLinkId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
