USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[GoldenBox.Customertransaction]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[GoldenBox.Customertransaction](
	[GoldenBoxTransactionId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[Token] [nvarchar](250) NULL,
	[TicketId] [bigint] NULL,
	[Amount] [money] NULL,
	[CurrencyId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[Action] [nvarchar](10) NULL,
 CONSTRAINT [PK_GoldenBox.Customertransaction] PRIMARY KEY CLUSTERED 
(
	[GoldenBoxTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
