USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[BranchForbiddenOddType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[BranchForbiddenOddType](
	[ForbiddenOddId] [bigint] IDENTITY(1,1) NOT NULL,
	[BranchId] [int] NULL,
	[ParameterOddTypeId] [int] NULL,
	[BetTypeId] [int] NULL,
 CONSTRAINT [PK_BranchForbiddenOddType] PRIMARY KEY CLUSTERED 
(
	[ForbiddenOddId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_BranchForbiddenOddType]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BranchForbiddenOddType] ON [Parameter].[BranchForbiddenOddType]
(
	[BranchId] ASC,
	[ParameterOddTypeId] ASC,
	[BetTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
