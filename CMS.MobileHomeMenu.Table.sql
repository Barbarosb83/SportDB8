USE [Tip_SportDB]
GO
/****** Object:  Table [CMS].[MobileHomeMenu]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CMS].[MobileHomeMenu](
	[MobileHomeMenuId] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](150) NOT NULL,
	[Icon] [nvarchar](50) NULL,
	[LanguageId] [int] NOT NULL,
	[NavigateURL] [nvarchar](150) NULL,
	[Position] [int] NULL,
	[IsTop] [bit] NULL,
	[SportId] [int] NULL,
	[TournamentId] [nvarchar](max) NULL,
	[TimeRangeId] [int] NULL,
	[IsEnabled] [bit] NULL,
 CONSTRAINT [PK_MobileHomeMenu] PRIMARY KEY CLUSTERED 
(
	[MobileHomeMenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [CMS].[MobileHomeMenu] ADD  CONSTRAINT [DF_MobileHomeMenu_IsEnabled_1]  DEFAULT ((1)) FOR [IsEnabled]
GO
