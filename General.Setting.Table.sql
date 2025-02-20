USE [Tip_SportDB]
GO
/****** Object:  Table [General].[Setting]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [General].[Setting](
	[SettingId] [int] NOT NULL,
	[CompanyName] [nvarchar](100) NULL,
	[MaxDayPeriod] [int] NOT NULL,
	[MaxCopySlip] [int] NULL,
	[UseSameAmountPerSystemCombi] [bit] NULL,
	[EmailSMTP] [nvarchar](50) NULL,
	[EmailAccount] [nvarchar](50) NULL,
	[EmailPort] [int] NULL,
	[EmailPassword] [nvarchar](50) NULL,
	[MaxWinningLimit] [money] NULL,
	[SystemCurrencyId] [int] NULL,
	[Address] [nvarchar](max) NULL,
	[CustomerDailyDeposit] [money] NULL,
	[CustomerDailyWithdraw] [money] NULL,
 CONSTRAINT [PK_Setting_1] PRIMARY KEY CLUSTERED 
(
	[SettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
