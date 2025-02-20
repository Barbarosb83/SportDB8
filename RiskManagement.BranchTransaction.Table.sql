USE [Tip_SportDB]
GO
/****** Object:  Table [RiskManagement].[BranchTransaction]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RiskManagement].[BranchTransaction](
	[BranchTransactionId] [bigint] IDENTITY(1,1) NOT NULL,
	[BranchId] [int] NULL,
	[CustomerId] [int] NULL,
	[TransactionTypeId] [int] NULL,
	[Amount] [money] NULL,
	[CurrencyId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[UserId] [int] NULL,
	[CashboxBalance] [money] NULL,
	[SlipId] [bigint] NULL,
	[IsView] [bit] NULL,
 CONSTRAINT [PK_BranchTransaction] PRIMARY KEY CLUSTERED 
(
	[BranchTransactionId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_BranchTransaction]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BranchTransaction] ON [RiskManagement].[BranchTransaction]
(
	[BranchId] ASC,
	[TransactionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_BranchTransaction_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BranchTransaction_1] ON [RiskManagement].[BranchTransaction]
(
	[SlipId] DESC,
	[TransactionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_BranchTransaction_2]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BranchTransaction_2] ON [RiskManagement].[BranchTransaction]
(
	[UserId] ASC,
	[TransactionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_BranchTransaction_3]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BranchTransaction_3] ON [RiskManagement].[BranchTransaction]
(
	[BranchId] ASC,
	[Amount] ASC,
	[TransactionTypeId] ASC,
	[CreateDate] ASC,
	[IsView] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_BranchTransaction_4]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BranchTransaction_4] ON [RiskManagement].[BranchTransaction]
(
	[UserId] DESC,
	[CreateDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [RiskManagement].[BranchTransaction] ADD  CONSTRAINT [DF_BranchTransaction_IsView]  DEFAULT ((1)) FOR [IsView]
GO
