USE [Tip_SportDB]
GO
/****** Object:  Table [Report].[BranchCommissionBalance]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Report].[BranchCommissionBalance](
	[BranchCommissionBalanceId] [bigint] IDENTITY(1,1) NOT NULL,
	[BranchId] [bigint] NULL,
	[Amount] [money] NULL,
	[CurrencyId] [int] NULL,
	[StartDate] [date] NULL,
	[BetTypeId] [int] NULL,
	[EndDate] [date] NULL,
	[IsPaid] [bit] NULL,
 CONSTRAINT [PK_BranchCommissionBalance] PRIMARY KEY CLUSTERED 
(
	[BranchCommissionBalanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
