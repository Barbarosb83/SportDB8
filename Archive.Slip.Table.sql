USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Slip]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Slip](
	[SlipId] [bigint] NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[TotalOddValue] [float] NULL,
	[Amount] [money] NULL,
	[SlipStateId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[GroupId] [bigint] NULL,
	[SlipTypeId] [int] NULL,
	[SourceId] [int] NULL,
	[SlipStatu] [int] NULL,
	[CurrencyId] [int] NULL,
	[EvaluateDate] [datetime] NULL,
	[EventCount] [int] NULL,
	[IsLive] [bit] NULL,
	[MTSTicketId] [bigint] NULL,
	[IsPayOut] [bit] NULL,
 CONSTRAINT [PK_Slip_1] PRIMARY KEY CLUSTERED 
(
	[SlipId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_BBARS]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_BBARS] ON [Archive].[Slip]
(
	[SlipStateId] ASC,
	[CreateDate] ASC,
	[SlipTypeId] ASC
)
INCLUDE([SlipId],[CustomerId],[TotalOddValue],[Amount],[SourceId],[SlipStatu],[EventCount],[IsLive],[IsPayOut]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Slip]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Slip] ON [Archive].[Slip]
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Slip_1]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Slip_1] ON [Archive].[Slip]
(
	[SlipStateId] DESC,
	[CreateDate] DESC,
	[CustomerId] DESC,
	[SourceId] DESC,
	[SlipStatu] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Slip_5]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Slip_5] ON [Archive].[Slip]
(
	[SlipId] DESC,
	[SlipTypeId] ASC,
	[IsPayOut] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Slip_3]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED COLUMNSTORE INDEX [IX_Slip_3] ON [Archive].[Slip]
(
	[SlipTypeId],
	[CustomerId]
)WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0, DATA_COMPRESSION = COLUMNSTORE) ON [PRIMARY]
GO
