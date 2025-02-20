USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[TransactionLog]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[TransactionLog](
	[TransactionLogId] [int] NOT NULL,
	[SpDescriptionId] [int] NULL,
	[TransactionTypeId] [int] NULL,
	[Username] [nvarchar](50) NULL,
	[RowId] [nvarchar](50) NULL,
	[TableName] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[NewValues] [nvarchar](max) NULL,
	[OldValues] [nvarchar](max) NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_TransactionLog] PRIMARY KEY CLUSTERED 
(
	[TransactionLogId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
