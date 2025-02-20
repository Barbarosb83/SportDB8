USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Language]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Language](
	[LanguageId] [int] IDENTITY(1,1) NOT NULL,
	[Language] [nvarchar](50) NOT NULL,
	[Comments] [nvarchar](50) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[LanguageId] ASC,
	[Language] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
