USE [Tip_SportDB]
GO
/****** Object:  Table [RiskManagement].[BranchDepositRequest]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RiskManagement].[BranchDepositRequest](
	[BranchDepositId] [int] IDENTITY(1,1) NOT NULL,
	[RequestUserId] [int] NULL,
	[BranchId] [int] NULL,
	[RequestDate] [datetime] NULL,
	[Amount] [money] NULL,
	[CurrencyId] [int] NULL,
	[BranchNote] [nvarchar](150) NULL,
	[IsApproved] [bit] NULL,
	[ApprovedUserId] [int] NULL,
	[ApprovedDate] [datetime] NULL,
	[TransactionTypeId] [int] NULL
) ON [PRIMARY]
GO
