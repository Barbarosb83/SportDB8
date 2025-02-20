USE [Tip_SportDB]
GO
/****** Object:  Table [Stadium].[Transaction]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stadium].[Transaction](
	[StadiumTransactionId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[StadiumId] [bigint] NULL,
	[Amount] [money] NULL,
	[CurrencyId] [int] NULL,
	[TransactionDate] [datetime] NULL,
	[TransactionTypeId] [int] NULL,
 CONSTRAINT [PK_Transaction_1] PRIMARY KEY CLUSTERED 
(
	[StadiumTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
