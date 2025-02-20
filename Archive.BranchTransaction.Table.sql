USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[BranchTransaction]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[BranchTransaction](
	[BranchTransactionId] [bigint] NOT NULL,
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
