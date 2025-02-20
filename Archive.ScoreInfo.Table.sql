USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[ScoreInfo]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[ScoreInfo](
	[ScoreInfoId] [int] NOT NULL,
	[MatchId] [bigint] NOT NULL,
	[MatchTimeTypeId] [int] NOT NULL,
	[Score] [nvarchar](15) NULL,
	[DecidedByFA] [bit] NULL,
	[Comment] [nvarchar](250) NULL,
 CONSTRAINT [PK_ScoreInfo_1] PRIMARY KEY CLUSTERED 
(
	[ScoreInfoId] ASC,
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScoreInfo_1]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_ScoreInfo_1] ON [Archive].[ScoreInfo]
(
	[MatchId] ASC,
	[MatchTimeTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
