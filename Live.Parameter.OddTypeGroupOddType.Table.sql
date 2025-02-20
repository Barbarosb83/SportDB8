USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[Parameter.OddTypeGroupOddType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[Parameter.OddTypeGroupOddType](
	[OddTypeGroupOddTypeId] [int] IDENTITY(1,1) NOT NULL,
	[OddTypeGroupId] [int] NULL,
	[OddTypeId] [int] NULL,
	[SeqNumber] [int] NULL,
 CONSTRAINT [PK_Parameter.OddTypeGroupOddType] PRIMARY KEY CLUSTERED 
(
	[OddTypeGroupOddTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Parameter.OddTypeGroupOddType]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Parameter.OddTypeGroupOddType] ON [Live].[Parameter.OddTypeGroupOddType]
(
	[OddTypeGroupOddTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Parameter.OddTypeGroupOddType_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Parameter.OddTypeGroupOddType_1] ON [Live].[Parameter.OddTypeGroupOddType]
(
	[OddTypeGroupId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
