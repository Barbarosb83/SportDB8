USE [Tip_SportDB]
GO
/****** Object:  Table [CMS].[LandingPage]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CMS].[LandingPage](
	[LandingPageId] [int] IDENTITY(1,1) NOT NULL,
	[ItemName] [nvarchar](150) NULL,
	[FileName] [nvarchar](150) NULL,
	[IsActive] [bit] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[PositionId] [int] NULL,
	[Link] [nvarchar](150) NULL,
	[LangId] [int] NULL,
	[Title] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL
) ON [PRIMARY]
GO
