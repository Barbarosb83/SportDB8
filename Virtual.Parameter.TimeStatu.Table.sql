USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[Parameter.TimeStatu]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[Parameter.TimeStatu](
	[TimeStatuId] [int] NOT NULL,
	[TimeStatuCode] [char](15) NULL,
	[StatuColor] [int] NULL,
	[TimeStatu] [nchar](15) NULL,
 CONSTRAINT [PK_Parameter.TimeStatu] PRIMARY KEY CLUSTERED 
(
	[TimeStatuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
