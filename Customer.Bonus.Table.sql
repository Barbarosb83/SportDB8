USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[Bonus]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[Bonus](
	[CustomerBonusId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[BonusId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[BonusAmount] [money] NULL,
	[ExpriedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[IsUsed] [bit] NULL,
	[DepositAmount] [money] NULL,
	[UsedDate] [datetime] NULL,
	[UsedSlipId] [bigint] NULL,
 CONSTRAINT [PK_Bonus] PRIMARY KEY CLUSTERED 
(
	[CustomerBonusId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Bonus]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Bonus] ON [Customer].[Bonus]
(
	[CustomerId] ASC,
	[IsUsed] ASC,
	[IsActive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
