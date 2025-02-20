USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[SlipSystem]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[SlipSystem](
	[SystemSlipId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[MaxGain] [money] NULL,
	[TotalOddValue] [float] NULL,
	[Amount] [money] NULL,
	[SlipStateId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[GroupId] [bigint] NULL,
	[SlipTypeId] [int] NULL,
	[SourceId] [int] NULL,
	[SlipStatuId] [int] NULL,
	[CurrencyId] [int] NULL,
	[EvaluateDate] [datetime] NULL,
	[EventCount] [int] NULL,
	[IsLive] [bit] NULL,
	[System] [nvarchar](150) NULL,
	[IsPayOut] [bit] NULL,
	[CouponCount] [int] NULL,
	[NewSlipTypeId] [int] NULL,
	[MaxGain2] [money] NULL,
 CONSTRAINT [PK_SystemSlip] PRIMARY KEY CLUSTERED 
(
	[SystemSlipId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_BBB]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_BBB] ON [Customer].[SlipSystem]
(
	[CreateDate] ASC,
	[NewSlipTypeId] ASC
)
INCLUDE([CustomerId],[SlipStateId],[SlipTypeId],[SourceId],[SlipStatuId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_BBCS]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_BBCS] ON [Customer].[SlipSystem]
(
	[SlipStateId] ASC,
	[IsPayOut] ASC
)
INCLUDE([SystemSlipId],[CustomerId],[EvaluateDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CSSSN]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_CSSSN] ON [Customer].[SlipSystem]
(
	[SlipStateId] ASC,
	[SlipStatuId] ASC,
	[NewSlipTypeId] ASC
)
INCLUDE([CustomerId],[MaxGain],[Amount],[CreateDate],[SourceId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_SlipSystem]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_SlipSystem] ON [Customer].[SlipSystem]
(
	[SystemSlipId] DESC,
	[IsPayOut] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_SlipSystem_1]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_SlipSystem_1] ON [Customer].[SlipSystem]
(
	[NewSlipTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_SlipSystem_2]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_SlipSystem_2] ON [Customer].[SlipSystem]
(
	[CustomerId] ASC,
	[NewSlipTypeId] ASC,
	[SlipStateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Customer].[SlipSystem] ADD  CONSTRAINT [DF_SlipSystem_IsPayOut]  DEFAULT ((0)) FOR [IsPayOut]
GO
