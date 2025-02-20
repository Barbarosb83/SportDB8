USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.LiveOdds]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.LiveOdds](
	[ParameterLiveOddId] [int] IDENTITY(1,1) NOT NULL,
	[OddsId] [int] NOT NULL,
	[LanguageId] [int] NOT NULL,
	[OutComes] [nvarchar](150) NULL,
 CONSTRAINT [PK_Parameter.LiveOdds] PRIMARY KEY CLUSTERED 
(
	[ParameterLiveOddId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Parameter.LiveOdds]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Parameter.LiveOdds] ON [Language].[Parameter.LiveOdds]
(
	[OddsId] ASC,
	[LanguageId] ASC,
	[OutComes] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
