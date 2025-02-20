USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[CurrencyParity]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[CurrencyParity](
	[CurrencyParityId] [int] IDENTITY(1,1) NOT NULL,
	[ParityDate] [datetime] NULL,
	[CurrencyId] [int] NULL,
	[Parity] [decimal](18, 6) NULL,
 CONSTRAINT [PK_CurrencyParity] PRIMARY KEY CLUSTERED 
(
	[CurrencyParityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
