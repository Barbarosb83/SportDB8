USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[Parameter.ConnectionStatu]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[Parameter.ConnectionStatu](
	[ConnectionStatuId] [int] NOT NULL,
	[ConnectionStatu] [char](10) NULL,
	[StatuColor] [int] NULL,
 CONSTRAINT [PK_Parameter.ConnectionStatu] PRIMARY KEY CLUSTERED 
(
	[ConnectionStatuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
