USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[OddsType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[OddsType](
	[OddsTypeId] [int] NOT NULL,
	[BetradarOddsTypeId] [int] NOT NULL,
	[OddsType] [nvarchar](150) NULL,
	[OutcomesDescription] [nvarchar](250) NULL,
	[SportId] [int] NOT NULL,
	[AvailabilityId] [int] NULL,
	[IsActive] [bit] NULL,
	[ShortSign] [nvarchar](20) NULL,
	[IsPopular] [bit] NULL,
	[SeqNumber] [int] NULL,
	[LSId] [int] NULL,
 CONSTRAINT [PK_OddsType] PRIMARY KEY CLUSTERED 
(
	[OddsTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_OddsType]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_OddsType] ON [Parameter].[OddsType]
(
	[BetradarOddsTypeId] ASC,
	[SportId] ASC,
	[OddsTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = OFF, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_OddsType_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_OddsType_1] ON [Parameter].[OddsType]
(
	[OddsTypeId] ASC,
	[BetradarOddsTypeId] ASC,
	[SportId] ASC,
	[IsActive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_OddsType_2]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_OddsType_2] ON [Parameter].[OddsType]
(
	[BetradarOddsTypeId] ASC,
	[IsActive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
