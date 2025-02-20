USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Outrights.Event]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Outrights.Event](
	[EventId] [bigint] NOT NULL,
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
