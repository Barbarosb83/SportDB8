USE [Tip_SportDB]
GO
/****** Object:  Table [RiskManagement].[TerminalCloseBoxReport]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RiskManagement].[TerminalCloseBoxReport](
	[TerminalCloseBoxId] [bigint] IDENTITY(1,1) NOT NULL,
	[BranchId] [bigint] NULL,
	[UserId] [int] NULL,
	[Username] [nvarchar](150) NULL,
	[CreateDate] [datetime] NULL,
	[CustomerDeposit] [money] NULL,
	[CustomerWithdraw] [money] NULL,
	[CustomerTotal] [money] NULL,
	[BetStake] [money] NULL,
	[Tax] [money] NULL,
	[CancelBet] [money] NULL,
	[BetPayout] [money] NULL,
	[BetTotal] [money] NULL,
	[CreditVoucher] [money] NULL,
	[Balance] [money] NULL,
	[TransactionId] [bigint] NULL,
	[TerminalDeposit] [money] NULL,
	[TerminalWithdraw] [money] NULL,
	[TerminalTotal] [money] NULL,
 CONSTRAINT [PK_TerminalCloseBoxReport] PRIMARY KEY CLUSTERED 
(
	[TerminalCloseBoxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
