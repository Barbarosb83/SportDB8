USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.Sport]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.Sport](
	[ParameterSportId] [int] IDENTITY(1,1) NOT NULL,
	[SportId] [int] NOT NULL,
	[LanguageId] [int] NOT NULL,
	[SportName] [nvarchar](50) NULL,
 CONSTRAINT [PK_Parameter.Sport] PRIMARY KEY CLUSTERED 
(
	[ParameterSportId] ASC,
	[SportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Parameter.Sport]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Parameter.Sport] ON [Language].[Parameter.Sport]
(
	[SportId] ASC,
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
