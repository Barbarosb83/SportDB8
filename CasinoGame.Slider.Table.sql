USE [Tip_SportDB]
GO
/****** Object:  Table [CasinoGame].[Slider]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CasinoGame].[Slider](
	[SliderId] [int] IDENTITY(1,1) NOT NULL,
	[SliderName] [nvarchar](150) NULL,
	[Img] [nvarchar](250) NULL,
	[RowNumber] [int] NULL,
	[IsEnabled] [bit] NULL,
 CONSTRAINT [PK_Slider_1] PRIMARY KEY CLUSTERED 
(
	[SliderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
