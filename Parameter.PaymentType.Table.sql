USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[PaymentType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[PaymentType](
	[PaymentTypeId] [int] IDENTITY(1,1) NOT NULL,
	[PaymentType] [nvarchar](150) NULL,
	[TypeId] [int] NULL,
	[TransactionTypeId] [int] NULL,
	[MinValue] [decimal](18, 2) NULL,
	[MaxValue] [decimal](18, 2) NULL,
	[IsActive] [bit] NULL,
	[RiskLevelId] [int] NULL,
	[Description] [nvarchar](150) NULL,
	[SeqNumber] [int] NULL,
 CONSTRAINT [PK_PaymentType] PRIMARY KEY CLUSTERED 
(
	[PaymentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
