USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[Spinmatic.Game]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[Spinmatic.Game](
	[GameId] [bigint] NULL,
	[Name] [nvarchar](150) NULL,
	[FriendlyName] [nvarchar](150) NULL,
	[IsPopular] [bit] NULL,
	[IsEnable] [bit] NULL,
	[ParameterGameTypeId] [int] NULL,
	[IsMobile] [bit] NULL
) ON [PRIMARY]
GO
