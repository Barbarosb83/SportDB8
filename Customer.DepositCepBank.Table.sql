USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[DepositCepBank]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[DepositCepBank](
	[DepositCepBankId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[CepBankId] [int] NULL,
	[RefNoOrGsmPass] [nvarchar](50) NULL,
	[SourceTCKN] [nvarchar](11) NULL,
	[SourceGSMNo] [nvarchar](50) NULL,
	[ReciverGSMNo] [nvarchar](50) NULL,
	[ReciverBirthday] [date] NULL,
	[DepositAmount] [money] NULL,
	[CurrencyId] [int] NULL,
	[IsBonus] [bit] NULL,
	[DepositStatuId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[UserId] [int] NULL
) ON [PRIMARY]
GO
