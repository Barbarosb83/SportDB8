USE [Tip_SportDB]
GO
/****** Object:  Table [RiskManagement].[WithdrawRequestAuto]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RiskManagement].[WithdrawRequestAuto](
	[WithdrawRequestId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[RequestDate] [datetime] NOT NULL,
	[Amount] [money] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[TransactionType] [int] NOT NULL,
	[IsApproved] [bit] NULL,
	[ApprovedUserId] [int] NULL,
	[ApprovedDate] [datetime] NULL,
	[TransactionCode] [nvarchar](100) NULL,
	[AccountId] [nvarchar](max) NULL,
	[BankId] [int] NULL,
	[CustomerNote] [nvarchar](250) NULL,
	[IsApproved1] [bit] NULL,
	[Approved1UserId] [int] NULL,
	[Approved1Date] [datetime] NULL,
	[ApprovedComment] [nvarchar](250) NULL,
	[Approved1Comment] [nvarchar](250) NULL,
 CONSTRAINT [PK_WithdrawRequestAuto] PRIMARY KEY CLUSTERED 
(
	[WithdrawRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
