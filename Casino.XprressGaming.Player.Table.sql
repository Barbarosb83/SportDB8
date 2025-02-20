USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[XprressGaming.Player]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[XprressGaming.Player](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[XprressId] [bigint] NULL,
	[CustomerId] [bigint] NULL,
	[Status] [nvarchar](50) NULL,
	[Balance] [money] NULL,
	[Currency] [nvarchar](50) NULL,
 CONSTRAINT [PK_XprressGaming.Player] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
