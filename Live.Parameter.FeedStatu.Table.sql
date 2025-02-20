USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[Parameter.FeedStatu]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[Parameter.FeedStatu](
	[FeedStatuId] [int] NOT NULL,
	[FeedStatu] [nchar](10) NULL,
	[StatuColor] [int] NULL,
 CONSTRAINT [PK_Parameter.FeedStatu] PRIMARY KEY CLUSTERED 
(
	[FeedStatuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
