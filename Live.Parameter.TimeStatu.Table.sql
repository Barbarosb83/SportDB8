USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[Parameter.TimeStatu]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[Parameter.TimeStatu](
	[TimeStatuId] [int] NOT NULL,
	[TimeStatuCode] [char](25) NULL,
	[StatuColor] [int] NULL,
	[TimeStatu] [nvarchar](50) NULL,
 CONSTRAINT [PK_Parameter.TimeStatu] PRIMARY KEY CLUSTERED 
(
	[TimeStatuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
