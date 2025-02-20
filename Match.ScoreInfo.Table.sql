USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[ScoreInfo]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[ScoreInfo](
	[ScoreInfoId] [int] IDENTITY(1,1) NOT NULL,
	[MatchId] [bigint] NOT NULL,
	[MatchTimeTypeId] [int] NOT NULL,
	[Score] [nvarchar](15) NULL,
	[DecidedByFA] [bit] NULL,
	[Comment] [nvarchar](250) NULL,
 CONSTRAINT [PK_ScoreInfo] PRIMARY KEY CLUSTERED 
(
	[ScoreInfoId] ASC,
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_ScoreInfo_2]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_ScoreInfo_2] ON [Match].[ScoreInfo]
(
	[MatchId] ASC,
	[MatchTimeTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Match].[ScoreInfo]  WITH CHECK ADD  CONSTRAINT [FK_ScoreInfo_MatchTimeType] FOREIGN KEY([MatchTimeTypeId])
REFERENCES [Parameter].[MatchTimeType] ([MatchTimeTypeId])
GO
ALTER TABLE [Match].[ScoreInfo] CHECK CONSTRAINT [FK_ScoreInfo_MatchTimeType]
GO
