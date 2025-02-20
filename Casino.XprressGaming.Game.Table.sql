USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[XprressGaming.Game]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[XprressGaming.Game](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[GameId] [bigint] NULL,
	[Name] [nvarchar](150) NULL,
	[FriendlyName] [nvarchar](150) NULL,
	[IsPopular] [bit] NULL,
	[IsEnable] [bit] NULL,
	[ParameterGameTypeId] [int] NULL,
	[IMG] [nvarchar](150) NULL,
	[IsMobile] [bit] NULL,
	[ProviderId] [int] NULL,
 CONSTRAINT [PK_XprressGaming.Game] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
