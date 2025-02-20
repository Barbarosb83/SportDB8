USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.PasswordQuestion]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.PasswordQuestion](
	[ParameterPasswordQuestionId] [int] IDENTITY(1,1) NOT NULL,
	[PasswordQuestionId] [int] NULL,
	[LanguageId] [int] NULL,
	[PasswordQuestion] [nvarchar](150) NULL,
 CONSTRAINT [PK_Parameter.PasswordQuestion] PRIMARY KEY CLUSTERED 
(
	[ParameterPasswordQuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
