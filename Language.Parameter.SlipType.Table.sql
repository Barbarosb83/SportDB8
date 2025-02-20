USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.SlipType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.SlipType](
	[ParameterSlipTypeId] [int] IDENTITY(1,1) NOT NULL,
	[SlipTypeId] [int] NULL,
	[LanguageId] [int] NULL,
	[SlipType] [nvarchar](20) NULL,
 CONSTRAINT [PK_Parameter.SlipType] PRIMARY KEY CLUSTERED 
(
	[ParameterSlipTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Parameter.SlipType]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Parameter.SlipType] ON [Language].[Parameter.SlipType]
(
	[SlipTypeId] ASC,
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
