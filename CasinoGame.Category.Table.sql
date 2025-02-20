USE [Tip_SportDB]
GO
/****** Object:  Table [CasinoGame].[Category]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CasinoGame].[Category](
	[CategoryId] [int] NOT NULL,
	[CatergoryName] [nvarchar](150) NULL,
	[IsPopular] [bit] NULL,
 CONSTRAINT [PK_Category_3] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
