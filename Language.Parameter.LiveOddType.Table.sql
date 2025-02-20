USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.LiveOddType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.LiveOddType](
	[ParametersLiveOddTypeId] [int] IDENTITY(1,1) NOT NULL,
	[OddTypeId] [int] NOT NULL,
	[LanguageId] [int] NOT NULL,
	[OddsType] [nvarchar](150) NULL,
	[ShortOddType] [nvarchar](150) NULL,
 CONSTRAINT [PK_Parameter.LiveOddType] PRIMARY KEY CLUSTERED 
(
	[ParametersLiveOddTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_LPBB]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_LPBB] ON [Language].[Parameter.LiveOddType]
(
	[LanguageId] ASC
)
INCLUDE([OddTypeId],[OddsType],[ShortOddType]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Parameter.LiveOddType]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Parameter.LiveOddType] ON [Language].[Parameter.LiveOddType]
(
	[OddTypeId] ASC,
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
