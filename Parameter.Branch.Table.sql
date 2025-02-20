USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[Branch]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[Branch](
	[BranchId] [int] IDENTITY(10,1) NOT NULL,
	[BrancName] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[Balance] [decimal](18, 2) NULL,
	[CommisionRate] [float] NULL,
	[IsActive] [bit] NULL,
	[CurrencyId] [int] NULL,
	[BranchCommisionTypeId] [int] NULL,
	[IsBonusDeducting] [bit] NULL,
	[MaxWinningLimit] [money] NULL,
	[MaxCopySlip] [int] NULL,
	[BrachCode] [bigint] NULL,
	[MinTicketLimit] [money] NULL,
	[MaxEventForTicket] [int] NULL,
	[ParentBranchId] [int] NULL,
	[IsWebPos] [bit] NULL,
	[Address] [nvarchar](max) NULL,
	[IsTerminal] [bit] NULL,
	[Api_url] [nvarchar](max) NULL,
	[IsAnonymousBet] [bit] NULL,
	[IsTest] [bit] NULL,
	[MainBranchId] [bigint] NULL,
	[OasisGUID] [nvarchar](250) NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[BranchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_Branch]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Branch] ON [Parameter].[Branch]
(
	[ParentBranchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Branch_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Branch_1] ON [Parameter].[Branch]
(
	[BranchId] ASC,
	[IsTerminal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Parameter].[Branch] ADD  CONSTRAINT [DF_Branch_IsAnonymousBet]  DEFAULT ((1)) FOR [IsAnonymousBet]
GO
