USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.LiveTimeStatu]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.LiveTimeStatu](
	[TimeStatuId] [int] IDENTITY(1,1) NOT NULL,
	[ParameterTimeStatuId] [int] NOT NULL,
	[TimeStatu] [nvarchar](50) NULL,
	[LanguageId] [int] NOT NULL,
 CONSTRAINT [PK_Parameter.LiveTimeStatu] PRIMARY KEY CLUSTERED 
(
	[TimeStatuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Parameter.LiveTimeStatu]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Parameter.LiveTimeStatu] ON [Language].[Parameter.LiveTimeStatu]
(
	[ParameterTimeStatuId] ASC,
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
