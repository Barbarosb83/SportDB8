USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[Corner]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[Corner](
	[CornerId] [int] IDENTITY(1,1) NOT NULL,
	[MatchId] [bigint] NOT NULL,
	[TeamNo] [int] NULL,
	[MatchTimeTypeId] [int] NULL,
	[CornerValue] [int] NULL,
	[Doubtful] [bit] NULL,
 CONSTRAINT [PK_Corner] PRIMARY KEY CLUSTERED 
(
	[CornerId] ASC,
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Corner]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Corner] ON [Match].[Corner]
(
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Match].[Corner]  WITH CHECK ADD  CONSTRAINT [FK_Corner_MatchTimeType] FOREIGN KEY([MatchTimeTypeId])
REFERENCES [Parameter].[MatchTimeType] ([MatchTimeTypeId])
GO
ALTER TABLE [Match].[Corner] CHECK CONSTRAINT [FK_Corner_MatchTimeType]
GO
