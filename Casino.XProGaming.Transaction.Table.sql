USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[XProGaming.Transaction]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[XProGaming.Transaction](
	[TransactionId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[GameId] [bigint] NULL,
	[RoundId] [bigint] NULL,
	[Sequence] [int] NULL,
	[Amount] [money] NULL,
	[CurrencyId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[TransactionTypeId] [int] NULL,
 CONSTRAINT [PK_XProGaming.Transaction] PRIMARY KEY CLUSTERED 
(
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
