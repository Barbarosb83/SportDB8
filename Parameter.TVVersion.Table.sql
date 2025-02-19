USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[TVVersion]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[TVVersion](
	[TVversionId] [int] NULL,
	[Version] [nvarchar](50) NULL,
	[DownloadLink] [nvarchar](max) NULL,
	[Applink] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
