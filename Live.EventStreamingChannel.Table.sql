USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[EventStreamingChannel]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[EventStreamingChannel](
	[StreamingChannelId] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [bigint] NOT NULL,
	[StreamingChannel] [nvarchar](100) NULL,
	[BetradarStreamingChannelId] [bigint] NULL,
 CONSTRAINT [PK_EventStreamingChannel] PRIMARY KEY CLUSTERED 
(
	[StreamingChannelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_EventStreamingChannel]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_EventStreamingChannel] ON [Live].[EventStreamingChannel]
(
	[EventId] ASC,
	[StreamingChannelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
