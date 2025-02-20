USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Tax]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Tax](
	[TaxId] [bigint] NOT NULL,
	[CustomerId] [bigint] NULL,
	[SlipId] [bigint] NULL,
	[TotalAmount] [money] NULL,
	[SlipAmount] [money] NULL,
	[TaxAmount] [money] NULL,
	[CurrencyId] [int] NULL,
	[TransactionTypeId] [int] NULL,
	[TaxStatusId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[SourceId] [int] NULL,
	[SlipTypeId] [int] NULL
) ON [PRIMARY]
GO
