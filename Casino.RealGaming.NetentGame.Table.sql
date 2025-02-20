USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[RealGaming.NetentGame]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[RealGaming.NetentGame](
	[GameId] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[Title] [nvarchar](100) NULL,
	[Img] [nvarchar](150) NULL,
	[GameUrl] [nvarchar](max) NULL,
	[ParameterGameTypeId] [int] NULL,
	[IsPopular] [bit] NULL,
	[IsEnable] [bit] NULL,
	[CurrencyId] [int] NULL,
	[IsMobile] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
