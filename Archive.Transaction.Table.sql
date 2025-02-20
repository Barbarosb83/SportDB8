USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Transaction]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Transaction](
	[TransactionId] [bigint] NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[Amount] [money] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[TransactionTypeId] [int] NOT NULL,
	[TransactionSourceId] [int] NULL,
	[TransactionComment] [nvarchar](250) NULL,
	[TransactionBalance] [money] NULL,
 CONSTRAINT [PK_Transaction] PRIMARY KEY CLUSTERED 
(
	[TransactionId] DESC,
	[CustomerId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
