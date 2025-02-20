USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[GoldenBox.Customer]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[GoldenBox.Customer](
	[GoldenBoxCustomerId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[Token] [nvarchar](250) NULL,
 CONSTRAINT [PK_GoldenBox.Customer] PRIMARY KEY CLUSTERED 
(
	[GoldenBoxCustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
