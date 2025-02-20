USE [Tip_SportDB]
GO
/****** Object:  Table [Report].[BranchCommission]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Report].[BranchCommission](
	[BranchCommissionId] [bigint] IDENTITY(1,1) NOT NULL,
	[BranchId] [bigint] NULL,
	[CustomerId] [bigint] NULL,
	[Turnover] [money] NULL,
	[Hold] [money] NULL,
	[CurrencyId] [int] NULL,
	[BetTypeId] [int] NULL,
	[ReportDate] [datetime] NULL,
	[SlipId] [bigint] NULL,
 CONSTRAINT [PK_BranchCommission] PRIMARY KEY CLUSTERED 
(
	[BranchCommissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
