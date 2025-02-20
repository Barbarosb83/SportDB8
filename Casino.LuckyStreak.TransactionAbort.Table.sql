USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[LuckyStreak.TransactionAbort]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[LuckyStreak.TransactionAbort](
	[LuckyStreakTransactionAbortId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[TransactionRequestId] [nvarchar](250) NULL,
	[AbortTransactionRequestId] [nvarchar](250) NULL,
	[AbortTime] [datetime] NULL,
	[CurrencyId] [int] NULL,
	[Amount] [money] NULL,
	[Direction] [nvarchar](50) NULL,
 CONSTRAINT [PK_LuckyStreak.TransactionAbort] PRIMARY KEY CLUSTERED 
(
	[LuckyStreakTransactionAbortId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
