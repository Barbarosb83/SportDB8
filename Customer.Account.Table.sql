USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[Account]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[Account](
	[CustomerAccountId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[ParameterBankId] [int] NULL,
	[BranchCode] [nvarchar](50) NULL,
	[AccountNo] [nvarchar](150) NULL,
	[IBAN] [nvarchar](50) NULL,
	[AccountTypeId] [int] NULL,
	[IsApproved] [bit] NULL,
	[ApprovedUserId] [int] NULL,
	[ApprovedDate] [datetime] NULL,
	[ApprovedComment] [nvarchar](250) NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[CustomerAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
