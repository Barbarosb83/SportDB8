USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[CashoutProfitFactor]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[CashoutProfitFactor](
	[CashOutId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProfitValue1] [float] NULL,
	[ProfitValue2] [float] NULL,
	[FactorValue] [float] NULL,
 CONSTRAINT [PK_CashoutProfitFactor] PRIMARY KEY CLUSTERED 
(
	[CashOutId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
