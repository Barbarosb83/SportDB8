USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[FixtureDateInfo]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[FixtureDateInfo](
	[FixtureDateInfoId] [int] NOT NULL,
	[FixtureId] [int] NOT NULL,
	[DateInfoTypeId] [int] NOT NULL,
	[Comment] [nvarchar](250) NULL,
	[ConfirmedMatchStart] [datetime] NULL,
	[MatchDate] [datetime] NULL,
	[LanguageId] [int] NULL,
 CONSTRAINT [PK_FixtureDateInfo_1] PRIMARY KEY CLUSTERED 
(
	[FixtureDateInfoId] DESC,
	[FixtureId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_FixtureDateInfo]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_FixtureDateInfo] ON [Archive].[FixtureDateInfo]
(
	[MatchDate] DESC,
	[FixtureId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_FixtureDateInfo_3]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_FixtureDateInfo_3] ON [Archive].[FixtureDateInfo]
(
	[MatchDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
