USE [Tip_SportDB]
GO
/****** Object:  Table [Report].[SummaryTax]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Report].[SummaryTax](
	[ReportTaxId] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportDate] [date] NULL,
	[CustomerId] [bigint] NULL,
	[SlipCount] [int] NULL,
	[TotalAmount] [money] NULL,
	[SlipAmount] [money] NULL,
	[TaxAmount] [money] NULL,
 CONSTRAINT [PK_SummaryTax] PRIMARY KEY CLUSTERED 
(
	[ReportTaxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
