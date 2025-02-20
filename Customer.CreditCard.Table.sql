USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[CreditCard]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[CreditCard](
	[CreditCardId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[ParameterBankId] [int] NULL,
	[CardNumber] [nvarchar](50) NULL,
	[CVCNo] [nvarchar](5) NULL,
	[ExpriedDate] [nvarchar](50) NULL,
	[IsApproved] [bit] NULL,
	[ApprovedUserId] [int] NULL,
	[ApprovedDate] [datetime] NULL,
	[ApprovedComment] [nvarchar](250) NULL,
 CONSTRAINT [PK_CreditCard] PRIMARY KEY CLUSTERED 
(
	[CreditCardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
