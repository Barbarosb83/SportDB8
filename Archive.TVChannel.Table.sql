USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[TVChannel]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[TVChannel](
	[MatchTVChannelId] [int] NOT NULL,
	[MatchId] [bigint] NOT NULL,
	[TVChannelId] [int] NOT NULL,
	[TVChannel] [nvarchar](250) NULL,
	[StartDate] [datetime] NULL
) ON [PRIMARY]
GO
