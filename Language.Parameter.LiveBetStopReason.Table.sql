USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.LiveBetStopReason]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.LiveBetStopReason](
	[BetStopReasonId] [bigint] IDENTITY(1,1) NOT NULL,
	[ParameterReasonId] [int] NULL,
	[Reason] [nvarchar](250) NULL,
	[LanguageId] [int] NULL,
	[ReasonT] [nvarchar](250) NULL,
	[ReasonTV] [nvarchar](250) NULL,
 CONSTRAINT [PK_Parameter.LiveBetStopreason] PRIMARY KEY CLUSTERED 
(
	[BetStopReasonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_BBMC]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_BBMC] ON [Language].[Parameter.LiveBetStopReason]
(
	[ParameterReasonId] ASC,
	[LanguageId] ASC
)
INCLUDE([ReasonT]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_BBMC0]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_BBMC0] ON [Language].[Parameter.LiveBetStopReason]
(
	[LanguageId] ASC
)
INCLUDE([ParameterReasonId],[ReasonT]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_BBMC2]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_BBMC2] ON [Language].[Parameter.LiveBetStopReason]
(
	[ParameterReasonId] ASC,
	[LanguageId] ASC
)
INCLUDE([Reason]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Parameter.LiveBetStopReason]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Parameter.LiveBetStopReason] ON [Language].[Parameter.LiveBetStopReason]
(
	[ParameterReasonId] ASC,
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
