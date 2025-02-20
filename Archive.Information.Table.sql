USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Information]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Information](
	[InformationId] [bigint] NOT NULL,
	[MatchId] [bigint] NOT NULL,
	[Information] [nvarchar](max) NULL,
	[LanguageId] [int] NULL,
 CONSTRAINT [PK_Information] PRIMARY KEY CLUSTERED 
(
	[InformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
