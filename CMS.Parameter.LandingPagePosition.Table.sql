USE [Tip_SportDB]
GO
/****** Object:  Table [CMS].[Parameter.LandingPagePosition]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CMS].[Parameter.LandingPagePosition](
	[PositionId] [int] IDENTITY(1,1) NOT NULL,
	[Position] [nvarchar](50) NULL,
	[Description] [nvarchar](150) NULL
) ON [PRIMARY]
GO
