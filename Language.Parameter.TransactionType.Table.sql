USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.TransactionType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.TransactionType](
	[ParameterTranscationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[TransactionTypeId] [int] NOT NULL,
	[LanguageId] [int] NULL,
	[TransactionType] [nvarchar](50) NULL,
 CONSTRAINT [PK_Parameter.TransactionType] PRIMARY KEY CLUSTERED 
(
	[ParameterTranscationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
