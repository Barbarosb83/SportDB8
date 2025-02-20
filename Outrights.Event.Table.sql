USE [Tip_SportDB]
GO
/****** Object:  Table [Outrights].[Event]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Outrights].[Event](
	[EventId] [bigint] IDENTITY(1,1) NOT NULL,
	[EventBetradarId] [bigint] NOT NULL,
	[TournamentId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[EventDate] [datetime] NULL,
	[EventStartDate] [datetime] NULL,
	[EventEndDate] [datetime] NULL,
	[StageId] [bigint] NULL,
	[AAmsOutrightIDs] [nvarchar](50) NULL,
	[SequenceNumber] [int] NULL,
 CONSTRAINT [PK_Event_1] PRIMARY KEY CLUSTERED 
(
	[EventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Event_3]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Event_3] ON [Outrights].[Event]
(
	[EventBetradarId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Event_4]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Event_4] ON [Outrights].[Event]
(
	[TournamentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
