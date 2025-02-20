USE [Tip_SportDB]
GO
/****** Object:  Table [Report].[SummaryCash]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Report].[SummaryCash](
	[SummaryCashId] [int] IDENTITY(1,1) NOT NULL,
	[ReportDate] [date] NULL,
	[TransactionTypeId] [int] NULL,
	[Amount] [money] NULL,
	[CustomerId] [bigint] NULL,
 CONSTRAINT [PK_SummaryCash] PRIMARY KEY CLUSTERED 
(
	[SummaryCashId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_SummaryCash]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_SummaryCash] ON [Report].[SummaryCash]
(
	[ReportDate] DESC,
	[TransactionTypeId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
