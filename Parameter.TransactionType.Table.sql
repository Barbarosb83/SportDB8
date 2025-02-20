USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[TransactionType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[TransactionType](
	[TransactionTypeId] [int] NOT NULL,
	[TransactionType] [nvarchar](50) NULL,
	[Direction] [int] NULL,
	[IsActive] [bit] NULL,
	[IsOnline] [bit] NULL,
 CONSTRAINT [PK_TransactionType_1] PRIMARY KEY CLUSTERED 
(
	[TransactionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Parameter].[TransactionType] ADD  CONSTRAINT [DF_TransactionType_IsOnline]  DEFAULT ((0)) FOR [IsOnline]
GO
