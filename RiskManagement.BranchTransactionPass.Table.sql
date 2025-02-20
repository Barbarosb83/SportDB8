USE [Tip_SportDB]
GO
/****** Object:  Table [RiskManagement].[BranchTransactionPass]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RiskManagement].[BranchTransactionPass](
	[TransactionPassId] [bigint] IDENTITY(1,1) NOT NULL,
	[BranchTransactionId] [bigint] NULL,
	[Password] [nvarchar](250) NULL,
	[IsPaid] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUserName] [nvarchar](50) NULL,
 CONSTRAINT [PK_BranchTransactionPass] PRIMARY KEY CLUSTERED 
(
	[TransactionPassId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_BranchTransactionPass]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BranchTransactionPass] ON [RiskManagement].[BranchTransactionPass]
(
	[BranchTransactionId] DESC,
	[IsPaid] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_BranchTransactionPass_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BranchTransactionPass_1] ON [RiskManagement].[BranchTransactionPass]
(
	[BranchTransactionId] ASC,
	[Password] ASC,
	[IsPaid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
