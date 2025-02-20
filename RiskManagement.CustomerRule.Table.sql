USE [Tip_SportDB]
GO
/****** Object:  Table [RiskManagement].[CustomerRule]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RiskManagement].[CustomerRule](
	[CustomerRuleId] [int] IDENTITY(1,1) NOT NULL,
	[RuleName] [nvarchar](150) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Priority] [int] NULL,
	[IsEnable] [bit] NULL,
	[ParameterRuleTimeId] [int] NULL,
	[ParameterRuleValueTypeId] [int] NULL,
	[Value] [decimal](18, 0) NULL,
	[ParameterRuleCompareTypeId] [int] NULL,
	[ParameterCustomerGroupId] [int] NULL,
 CONSTRAINT [PK_CustomerRule] PRIMARY KEY CLUSTERED 
(
	[CustomerRuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
