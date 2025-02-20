USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[BitcoinTransaction]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[BitcoinTransaction](
	[BitcoinTransactionId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[Amount] [money] NOT NULL,
	[CurrencyId] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Status] [nvarchar](10) NULL,
	[InvoiceId] [nvarchar](150) NULL,
 CONSTRAINT [PK_BitcoinTransaction] PRIMARY KEY CLUSTERED 
(
	[BitcoinTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
