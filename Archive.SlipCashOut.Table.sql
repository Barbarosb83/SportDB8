USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[SlipCashOut]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[SlipCashOut](
	[SlipCashoutId] [bigint] NOT NULL,
	[SlipId] [bigint] NOT NULL,
	[CashOutValue] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SlipCashOut_1] PRIMARY KEY CLUSTERED 
(
	[SlipCashoutId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
