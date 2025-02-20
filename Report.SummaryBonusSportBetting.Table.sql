USE [Tip_SportDB]
GO
/****** Object:  Table [Report].[SummaryBonusSportBetting]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Report].[SummaryBonusSportBetting](
	[SummaryBonusSportBettingId] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [PK_SummaryBonusSportBetting] PRIMARY KEY CLUSTERED 
(
	[SummaryBonusSportBettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
