USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[FixtureDateInfo]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[FixtureDateInfo](
	[FixtureDateInfoId] [int] IDENTITY(1,1) NOT NULL,
	[FixtureId] [int] NOT NULL,
	[DateInfoTypeId] [int] NOT NULL,
	[Comment] [nvarchar](250) NULL,
	[ConfirmedMatchStart] [datetime] NULL,
	[MatchDate] [datetime] NULL,
	[LanguageId] [int] NULL,
 CONSTRAINT [PK_FixtureDateInfo] PRIMARY KEY CLUSTERED 
(
	[FixtureDateInfoId] ASC,
	[FixtureId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_FixtureDateInfo_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_FixtureDateInfo_1] ON [Match].[FixtureDateInfo]
(
	[FixtureId] ASC,
	[LanguageId] ASC,
	[MatchDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_FixtureDateInfo_2]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_FixtureDateInfo_2] ON [Match].[FixtureDateInfo]
(
	[FixtureId] ASC,
	[MatchDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Match].[FixtureDateInfo]  WITH CHECK ADD  CONSTRAINT [FK_FixtureDateInfo_DateInfoType] FOREIGN KEY([DateInfoTypeId])
REFERENCES [Parameter].[DateInfoType] ([DateInfoTypeId])
GO
ALTER TABLE [Match].[FixtureDateInfo] CHECK CONSTRAINT [FK_FixtureDateInfo_DateInfoType]
GO
