USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[BankAccount]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[BankAccount](
	[BankAccountId] [int] IDENTITY(1,1) NOT NULL,
	[BankId] [int] NULL,
	[BranchCode] [nvarchar](50) NULL,
	[AccountNo] [nvarchar](50) NULL,
	[IBAN] [nvarchar](50) NULL,
	[Name] [nvarchar](100) NULL,
	[Surname] [nvarchar](100) NULL,
	[CreateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_BankAccount] PRIMARY KEY CLUSTERED 
(
	[BankAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
