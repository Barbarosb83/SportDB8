USE [Tip_SportDB]
GO
/****** Object:  Table [General].[PaymentSystemSetting]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [General].[PaymentSystemSetting](
	[PaymentSystemSettingId] [int] NOT NULL,
	[OxxoUserName] [nvarchar](max) NULL,
	[OxxoPassword] [nvarchar](max) NULL,
	[OxxoHashCode] [nvarchar](max) NULL,
	[OxxoUrl] [nvarchar](max) NULL,
	[NetellerMerchantId] [nvarchar](max) NULL,
	[NetellerMerchantKey] [nvarchar](max) NULL,
	[NetellerMerchantName] [nvarchar](max) NULL,
	[NetellerMerchantAccount] [nvarchar](max) NULL,
	[NetellerURL] [nvarchar](max) NULL,
	[AstroPayXLogin] [nvarchar](max) NULL,
	[AstroPayXTransKey] [nvarchar](max) NULL,
	[AstroPayXSecretKey] [nvarchar](max) NULL,
	[NetellerMinDeposit] [money] NULL,
	[NetellerMinWithdraw] [money] NULL,
	[NetellerMaxDeposit] [money] NULL,
	[NetellerMaxWithdraw] [money] NULL,
	[EcoPayzMerchantAccountNumber] [int] NULL,
	[EcoPayzMerchantId] [int] NULL,
	[EcoPayzPassword] [nvarchar](max) NULL,
	[EcoPayzURL] [nvarchar](max) NULL,
	[EcoPayzMinDeposit] [money] NULL,
	[EcoPayzMinWithdraw] [money] NULL,
	[EcoPayzMaxDeposit] [money] NULL,
	[EcoPayzMaxWithdraw] [money] NULL,
	[BitcoinURL] [nvarchar](max) NULL,
	[BitcoinAPIKey] [nvarchar](max) NULL,
	[BitcoinPairingCode] [nvarchar](max) NULL,
	[BitcoinMinDeposit] [money] NULL,
	[BitcoinMinWithdraw] [money] NULL,
	[BitcoinMaxDeposit] [money] NULL,
	[BitcoinMaxWithdraw] [money] NULL,
	[IsOxxoEnabled] [bit] NULL,
	[IsNetellerEnabled] [bit] NULL,
	[IsAstroPayEnabled] [bit] NULL,
	[IsEcoPayzEnabled] [bit] NULL,
	[IsBitcoinEnabled] [bit] NULL,
 CONSTRAINT [PK_PaymentSystemSetting] PRIMARY KEY CLUSTERED 
(
	[PaymentSystemSettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
