USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[DepositTransfer]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[DepositTransfer](
	[DepositTransferId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[TransferDateTime] [datetime] NULL,
	[TransferSourceId] [int] NULL,
	[CustomerNote] [nvarchar](50) NULL,
	[TransferBankId] [int] NULL,
	[TransferBankAcountId] [int] NULL,
	[DepositAmount] [money] NULL,
	[CurrencyId] [int] NULL,
	[IsBonus] [bit] NULL,
	[DepositStatuId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[UserId] [int] NULL,
	[UserComment] [nvarchar](250) NULL,
	[TransactionTypeId] [int] NULL
) ON [PRIMARY]
GO
