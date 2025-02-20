USE [Tip_SportDB]
GO
/****** Object:  Table [CasinoGame].[Game]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CasinoGame].[Game](
	[GameId] [bigint] NOT NULL,
	[GameName] [nvarchar](250) NULL,
	[GameText] [nvarchar](250) NULL,
	[GameImg] [nvarchar](50) NULL,
	[RowNumber] [int] NULL,
	[IsEnabled] [bit] NULL,
	[ProviderId] [bigint] NULL,
	[IsPopular] [bit] NULL,
	[CategoryId] [int] NULL,
	[Aggregator] [nvarchar](50) NULL,
	[ProductId] [bigint] NULL,
 CONSTRAINT [PK_Game] PRIMARY KEY CLUSTERED 
(
	[GameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
