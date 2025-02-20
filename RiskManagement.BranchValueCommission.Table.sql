USE [Tip_SportDB]
GO
/****** Object:  Table [RiskManagement].[BranchValueCommission]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RiskManagement].[BranchValueCommission](
	[BranchValueCommissionId] [int] IDENTITY(1,1) NOT NULL,
	[BranchId] [int] NULL,
	[Value1] [money] NULL,
	[Value2] [money] NULL,
	[CommissionRate] [float] NULL,
	[BetTypeId] [int] NULL,
 CONSTRAINT [PK_BranchValueCommission] PRIMARY KEY CLUSTERED 
(
	[BranchValueCommissionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
