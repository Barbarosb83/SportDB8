USE [Tip_SportDB]
GO
/****** Object:  Table [CMS].[Title]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CMS].[Title](
	[TitleId] [int] NOT NULL,
	[HomePage] [nvarchar](250) NULL,
	[Sportsbook] [nvarchar](250) NULL,
	[Live] [nvarchar](250) NULL,
	[Virtual] [nvarchar](250) NULL,
	[Casino] [nvarchar](250) NULL,
	[Mobile] [nvarchar](250) NULL,
	[LanguageId] [int] NULL,
 CONSTRAINT [PK_Title] PRIMARY KEY CLUSTERED 
(
	[TitleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
