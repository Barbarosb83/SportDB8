USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[DoublePlayer]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[DoublePlayer](
	[MatchDoublePlayerId] [bigint] IDENTITY(1,1) NOT NULL,
	[MatchId] [bigint] NULL,
	[PlayerId] [bigint] NULL,
	[PlayerName] [nvarchar](150) NULL,
	[LangId] [int] NULL,
	[Orders] [nvarchar](50) NULL,
	[SuperId] [bigint] NULL,
	[TeamId] [bigint] NULL,
 CONSTRAINT [PK_DoublePlayer] PRIMARY KEY CLUSTERED 
(
	[MatchDoublePlayerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
