USE [Tip_SportDB]
GO
/****** Object:  Table [Retail].[ValidatorTransaction]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Retail].[ValidatorTransaction](
	[TransactionId] [bigint] IDENTITY(1,1) NOT NULL,
	[TerminalId] [bigint] NULL,
	[TerminalTransactionId] [nvarchar](250) NULL,
	[CustomerId] [bigint] NULL,
	[CurrencyId] [int] NULL,
	[LocalTime] [datetime] NULL,
	[TransactionMoney] [money] NULL,
	[Status] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_ValidatorTransaction] PRIMARY KEY CLUSTERED 
(
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
