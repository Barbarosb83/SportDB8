USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Corner]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Corner](
	[CornerId] [int] NOT NULL,
	[MatchId] [bigint] NULL,
	[TeamNo] [int] NULL,
	[MatchTimeTypeId] [int] NULL,
	[CornerValue] [int] NULL,
	[Doubtful] [bit] NULL,
 CONSTRAINT [PK_Corner_1] PRIMARY KEY CLUSTERED 
(
	[CornerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
