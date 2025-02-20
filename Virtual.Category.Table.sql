USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[Category]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[Category](
	[CategoryId] [bigint] NOT NULL,
	[SportId] [bigint] NOT NULL,
	[Category] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_Category_2] PRIMARY KEY CLUSTERED 
(
	[CategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
