USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[SummaryCasinoBetting]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[SummaryCasinoBetting](
	[SummaryCasinoBettingId] [int] NOT NULL,
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
	[OrgSlipAmount] [money] NULL,
	[OrgOpenSlipAmount] [money] NULL,
	[OrgOpenSlipPayOut] [money] NULL,
	[OrgWonSlipAmount] [money] NULL,
	[OrgWonSlipPayOut] [money] NULL,
	[OrgLostSlipAmount] [money] NULL,
	[OrgCancelSlipAmount] [money] NULL,
 CONSTRAINT [PK_SummaryCasinoBetting] PRIMARY KEY CLUSTERED 
(
	[SummaryCasinoBettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
