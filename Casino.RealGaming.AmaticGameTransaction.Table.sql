USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[RealGaming.AmaticGameTransaction]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[RealGaming.AmaticGameTransaction](
	[AmaticGameTransactionId] [bigint] IDENTITY(1,1) NOT NULL,
	[GameId] [bigint] NULL,
	[CustomerId] [bigint] NOT NULL,
	[TradeId] [nvarchar](250) NULL,
	[BetAmount] [money] NULL,
	[CurrencyId] [int] NULL,
	[WinLose] [money] NULL,
	[BetInfo] [nvarchar](max) NULL,
	[CreateDate] [datetime] NULL,
	[Matrix] [nvarchar](250) NULL,
	[IpAddress] [nvarchar](150) NULL,
 CONSTRAINT [PK_RealGaming.AmaticGameTransaction] PRIMARY KEY CLUSTERED 
(
	[AmaticGameTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
