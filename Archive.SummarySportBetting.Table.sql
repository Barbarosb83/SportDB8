USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[SummarySportBetting]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[SummarySportBetting](
	[SummarySportBettingId] [int] NOT NULL,
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
	[BranchId] [bigint] NULL,
	[BonusAmount] [money] NULL,
	[WonSlipAll] [money] NULL,
 CONSTRAINT [PK_SummarySportBetting] PRIMARY KEY CLUSTERED 
(
	[SummarySportBettingId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
