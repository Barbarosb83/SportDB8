USE [Tip_SportDB]
GO
/****** Object:  Table [Report].[SummarySportBetting2]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Report].[SummarySportBetting2](
	[SummarySportBettingId] [int] IDENTITY(1,1) NOT NULL,
	[ReportDate] [date] NULL,
	[SlipCount] [int] NULL,
	[SlipAmount] [money] NULL,
	[OpenSlipCount] [int] NULL,
	[OpenSlipAmount] [money] NULL,
	[OpenSlipPayOut] [money] NULL,
	[WonSlipCount] [int] NULL,
	[WonSlipAmount] [money] NULL,
	[WonSlipPayOut] [money] NULL,
	[LostSlipCount] [int] NULL,
	[LostSlipAmount] [money] NULL,
	[CancelSlipCount] [int] NULL,
	[CancelSlipAmount] [money] NULL,
	[CustomerId] [bigint] NULL,
	[SourceId] [int] NULL,
	[TaxCount] [int] NULL,
	[Tax] [money] NULL,
	[PayOutCount] [int] NULL,
	[PayOutAmount] [money] NULL,
	[OrgSlipAmount] [money] NULL,
	[OrgOpenSlipAmount] [money] NULL,
	[OrgOpenSlipPayOut] [money] NULL,
	[OrgWonSlipAmount] [money] NULL,
	[OrgWonSlipPayOut] [money] NULL,
	[OrgLostSlipAmount] [money] NULL,
	[OrgCancelSlipAmount] [money] NULL,
	[OrgTax] [money] NULL,
	[OrgPayOutAmount] [money] NULL,
	[CashoutSlipCount] [int] NULL,
	[CashoutSlipAmount] [money] NULL,
	[OrgCashoutSlipAmount] [money] NULL,
	[Isview] [bit] NULL,
	[OnlineDeposit] [money] NULL,
	[OnlineWithDraw] [money] NULL,
 CONSTRAINT [PK_SummarySportBetting2] PRIMARY KEY CLUSTERED 
(
	[SummarySportBettingId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_SummarySportBetting2]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_SummarySportBetting2] ON [Report].[SummarySportBetting2]
(
	[ReportDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
