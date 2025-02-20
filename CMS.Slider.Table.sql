USE [Tip_SportDB]
GO
/****** Object:  Table [CMS].[Slider]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CMS].[Slider](
	[SliderId] [int] IDENTITY(1,1) NOT NULL,
	[SliderItemName] [nvarchar](150) NOT NULL,
	[FileName] [nvarchar](150) NOT NULL,
	[IsActive] [bit] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[SeqNo] [int] NULL,
	[Link] [nvarchar](150) NULL,
	[LangId] [int] NULL,
	[MobileLink] [nvarchar](150) NULL,
	[Title] [nvarchar](50) NULL,
	[Description] [nvarchar](250) NULL,
 CONSTRAINT [PK_Slider] PRIMARY KEY CLUSTERED 
(
	[SliderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
