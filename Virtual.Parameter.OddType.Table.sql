USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[Parameter.OddType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[Parameter.OddType](
	[OddTypeId] [int] IDENTITY(1,1) NOT NULL,
	[OddType] [nvarchar](250) NOT NULL,
	[BetradarOddsTypeId] [bigint] NOT NULL,
	[BetradarOddsSubTypeId] [bigint] NULL,
	[OutcomesDescription] [nvarchar](250) NULL,
	[IsActive] [bit] NULL,
	[ShortSign] [nvarchar](20) NULL,
	[IsPopular] [bit] NULL,
 CONSTRAINT [PK_Parameter.OddType] PRIMARY KEY CLUSTERED 
(
	[OddTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Parameter.OddType]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Parameter.OddType] ON [Virtual].[Parameter.OddType]
(
	[BetradarOddsTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Parameter.OddType_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Parameter.OddType_1] ON [Virtual].[Parameter.OddType]
(
	[BetradarOddsSubTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
