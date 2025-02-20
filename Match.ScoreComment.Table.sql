USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[ScoreComment]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[ScoreComment](
	[ScoreCommentId] [int] IDENTITY(1,1) NOT NULL,
	[MatchId] [bigint] NOT NULL,
	[ScoreComment] [nvarchar](250) NULL,
	[LanguageId] [int] NULL,
 CONSTRAINT [PK_ScoreComment] PRIMARY KEY CLUSTERED 
(
	[ScoreCommentId] ASC,
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScoreComment]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_ScoreComment] ON [Match].[ScoreComment]
(
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
