USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[CashoutKey2]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[CashoutKey2](
	[CashOutId] [int] IDENTITY(1,1) NOT NULL,
	[Value1] [float] NULL,
	[Value2] [float] NULL,
	[OddKey] [float] NULL,
 CONSTRAINT [PK_CashoutKey2] PRIMARY KEY CLUSTERED 
(
	[CashOutId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
