USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[Fixture]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[Fixture](
	[FixtureId] [int] IDENTITY(1,1) NOT NULL,
	[MatchId] [bigint] NOT NULL,
	[Latitude] [float] NULL,
	[Longitude] [float] NULL,
	[EventStart] [datetime] NULL,
	[EventDate] [datetime] NULL,
	[EventEndDate] [datetime] NULL,
	[EventName] [nvarchar](250) NULL,
	[EventOff] [bit] NULL,
	[HasStatistics] [bit] NULL,
	[StreamingMatch] [nvarchar](50) NULL,
	[NeutralGround] [bit] NULL,
	[LiveMultiCast] [bit] NULL,
	[LiveScore] [bit] NULL,
	[NumberOfSets] [bigint] NULL,
	[SeriesResult] [nvarchar](10) NULL,
	[SeriesResultWinner] [nvarchar](10) NULL,
	[AggregateScore] [nvarchar](10) NULL,
	[AggregateScoreWinner] [nvarchar](10) NULL,
	[NumberOfFrames] [int] NULL,
	[StatusInfoId] [int] NOT NULL,
	[CupRoundId] [int] NOT NULL,
	[Round] [bigint] NULL,
	[MatchNumber] [nvarchar](20) NULL,
	[VenueId] [int] NULL,
	[Comment] [nvarchar](250) NULL,
 CONSTRAINT [PK_Fixture] PRIMARY KEY CLUSTERED 
(
	[FixtureId] ASC,
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [BB_FX]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [BB_FX] ON [Match].[Fixture]
(
	[MatchId] ASC
)
INCLUDE([FixtureId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Match].[Fixture]  WITH CHECK ADD  CONSTRAINT [FK_Fixture_CupRound] FOREIGN KEY([CupRoundId])
REFERENCES [Parameter].[CupRound] ([CupRoundId])
GO
ALTER TABLE [Match].[Fixture] CHECK CONSTRAINT [FK_Fixture_CupRound]
GO
ALTER TABLE [Match].[Fixture]  WITH CHECK ADD  CONSTRAINT [FK_Fixture_StatusInfo] FOREIGN KEY([StatusInfoId])
REFERENCES [Parameter].[StatusInfo] ([StatusInfoId])
GO
ALTER TABLE [Match].[Fixture] CHECK CONSTRAINT [FK_Fixture_StatusInfo]
GO
