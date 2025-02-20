USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[LuckyStreak.Transaction]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[LuckyStreak.Transaction](
	[LuckyStreakTransactionId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[TransactionRequestId] [nvarchar](250) NULL,
	[EventType] [nvarchar](250) NULL,
	[EventSubType] [nvarchar](250) NULL,
	[EventId] [nvarchar](250) NULL,
	[Direction] [nvarchar](50) NULL,
	[CurrencyId] [int] NULL,
	[Amount] [money] NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_LuckyStreak.Transaction] PRIMARY KEY CLUSTERED 
(
	[LuckyStreakTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
