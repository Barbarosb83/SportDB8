USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[Card]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[Card](
	[CardId] [int] IDENTITY(1,1) NOT NULL,
	[BetradarCardId] [bigint] NOT NULL,
	[Time] [nvarchar](10) NULL,
	[CardTypeId] [int] NULL,
	[PlayerId] [int] NULL,
	[MatchId] [bigint] NOT NULL,
	[Doubtful] [bit] NULL,
	[TeamId] [int] NULL,
	[PlayerName] [nvarchar](250) NULL,
 CONSTRAINT [PK_Card] PRIMARY KEY CLUSTERED 
(
	[CardId] ASC,
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Card]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Card] ON [Match].[Card]
(
	[BetradarCardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Card_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Card_1] ON [Match].[Card]
(
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Match].[Card]  WITH CHECK ADD  CONSTRAINT [FK_Card_CardType] FOREIGN KEY([CardTypeId])
REFERENCES [Parameter].[CardType] ([CardTypeId])
GO
ALTER TABLE [Match].[Card] CHECK CONSTRAINT [FK_Card_CardType]
GO
ALTER TABLE [Match].[Card]  WITH CHECK ADD  CONSTRAINT [FK_Card_TeamPlayer] FOREIGN KEY([PlayerId])
REFERENCES [Parameter].[TeamPlayer] ([TeamPlayerId])
GO
ALTER TABLE [Match].[Card] CHECK CONSTRAINT [FK_Card_TeamPlayer]
GO
