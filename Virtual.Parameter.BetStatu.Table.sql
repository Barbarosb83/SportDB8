USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[Parameter.BetStatu]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[Parameter.BetStatu](
	[BetStatuId] [int] NOT NULL,
	[BetStatu] [char](10) NULL,
	[StatuColor] [int] NULL,
 CONSTRAINT [PK_Parameter.BetStatu] PRIMARY KEY CLUSTERED 
(
	[BetStatuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
