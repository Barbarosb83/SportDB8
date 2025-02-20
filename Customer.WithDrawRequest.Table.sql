USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[WithDrawRequest]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[WithDrawRequest](
	[CustomerWithdrawId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[Amount] [money] NULL,
	[CurrencyId] [int] NULL,
	[TransactionTypeId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_WithDrawRequest_1] PRIMARY KEY CLUSTERED 
(
	[CustomerWithdrawId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_WithDrawRequest]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_WithDrawRequest] ON [Customer].[WithDrawRequest]
(
	[CustomerId] ASC,
	[TransactionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
