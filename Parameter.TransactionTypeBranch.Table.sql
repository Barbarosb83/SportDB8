USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[TransactionTypeBranch]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[TransactionTypeBranch](
	[BranchTransactionTypeId] [int] IDENTITY(1,1) NOT NULL,
	[TransactionType] [nvarchar](50) NULL,
	[Direction] [int] NULL
) ON [PRIMARY]
GO
