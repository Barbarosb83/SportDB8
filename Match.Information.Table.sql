USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[Information]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[Information](
	[InformationId] [bigint] IDENTITY(1,1) NOT NULL,
	[MatchId] [bigint] NOT NULL,
	[Information] [nvarchar](max) NULL,
	[LanguageId] [int] NULL,
 CONSTRAINT [PK_Information_1] PRIMARY KEY CLUSTERED 
(
	[InformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_Information]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Information] ON [Match].[Information]
(
	[MatchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
