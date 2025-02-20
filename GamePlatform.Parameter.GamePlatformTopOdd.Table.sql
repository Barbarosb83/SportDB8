USE [Tip_SportDB]
GO
/****** Object:  Table [GamePlatform].[Parameter.GamePlatformTopOdd]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [GamePlatform].[Parameter.GamePlatformTopOdd](
	[GamePlatformOddId] [int] IDENTITY(1,1) NOT NULL,
	[ParameterOddId] [int] NOT NULL,
	[SportId] [int] NOT NULL,
	[OutCome] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_Parameter.GamePlatformTopOdd] PRIMARY KEY CLUSTERED 
(
	[GamePlatformOddId] ASC,
	[ParameterOddId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Parameter.GamePlatformTopOdd]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Parameter.GamePlatformTopOdd] ON [GamePlatform].[Parameter.GamePlatformTopOdd]
(
	[ParameterOddId] ASC,
	[SportId] ASC,
	[OutCome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
