USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[BranchTransactionPass]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[BranchTransactionPass](
	[TransactionPassId] [bigint] NOT NULL,
	[BranchTransactionId] [bigint] NULL,
	[Password] [nvarchar](250) NULL,
	[IsPaid] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUserName] [nvarchar](50) NULL,
 CONSTRAINT [PK_BranchTransactionPass] PRIMARY KEY CLUSTERED 
(
	[TransactionPassId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
