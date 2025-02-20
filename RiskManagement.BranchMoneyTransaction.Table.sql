USE [Tip_SportDB]
GO
/****** Object:  Table [RiskManagement].[BranchMoneyTransaction]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RiskManagement].[BranchMoneyTransaction](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TransId] [bigint] NOT NULL,
	[TransTypeId] [int] NOT NULL,
	[BranchId] [bigint] NOT NULL,
 CONSTRAINT [PK_BranchMoneyTransaction] PRIMARY KEY CLUSTERED 
(
	[Id] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_BranchMoneyTransaction]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_BranchMoneyTransaction] ON [RiskManagement].[BranchMoneyTransaction]
(
	[BranchId] DESC,
	[TransTypeId] DESC,
	[TransId] DESC
)
INCLUDE([Id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
