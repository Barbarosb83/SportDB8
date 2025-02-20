USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[Currency]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[Currency](
	[CurrencyId] [int] IDENTITY(1,1) NOT NULL,
	[Currency] [nvarchar](50) NULL,
	[Sybol] [nvarchar](3) NULL,
	[Symbol3] [nchar](3) NULL,
	[DecimalFormat] [nvarchar](10) NULL,
	[Multiplier] [int] NULL,
 CONSTRAINT [PK_Currency] PRIMARY KEY CLUSTERED 
(
	[CurrencyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
