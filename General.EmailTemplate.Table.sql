USE [Tip_SportDB]
GO
/****** Object:  Table [General].[EmailTemplate]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [General].[EmailTemplate](
	[EmailTemplateId] [int] NOT NULL,
	[TemplateName] [nvarchar](50) NOT NULL,
	[Purpose] [nvarchar](50) NOT NULL,
	[LanguageId] [int] NOT NULL,
	[HTML] [nvarchar](max) NOT NULL,
	[MailSubject] [nvarchar](max) NULL,
 CONSTRAINT [PK_EmailTemplate] PRIMARY KEY CLUSTERED 
(
	[EmailTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
