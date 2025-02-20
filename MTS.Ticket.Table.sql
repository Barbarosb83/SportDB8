USE [Tip_SportDB]
GO
/****** Object:  Table [MTS].[Ticket]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MTS].[Ticket](
	[TicketId] [bigint] IDENTITY(1,1) NOT NULL,
	[betSHA1] [char](40) NOT NULL,
	[channelID] [nvarchar](10) NOT NULL,
	[endCustomerID] [bigint] NOT NULL,
	[endCustomerIP] [nchar](15) NOT NULL,
	[shopID] [nchar](10) NULL,
	[terminalID] [nchar](10) NULL,
	[deviceID] [nchar](10) NULL,
	[languageID] [nchar](2) NOT NULL,
	[stk] [money] NOT NULL,
	[cur] [nchar](3) NOT NULL,
	[sys] [nchar](20) NULL,
	[ts_UTC] [nchar](14) NOT NULL,
	[TotalOddValue] [float] NULL,
	[SlipStateId] [int] NULL,
	[GroupId] [bigint] NULL,
	[SlipTypeId] [int] NULL,
	[SourceId] [int] NULL,
	[SlipStatu] [int] NULL,
	[CurrencyId] [int] NULL,
	[resultCode] [int] NULL,
	[result] [nvarchar](50) NULL,
	[exceptionMessage] [nvarchar](max) NULL,
	[intExceptionMessage] [nvarchar](max) NULL,
	[exchangeRate] [nvarchar](10) NULL,
	[betAcceptanceId] [nvarchar](max) NULL,
	[HasSent] [bit] NULL,
	[SlipId] [bigint] NULL,
 CONSTRAINT [PK_Ticket] PRIMARY KEY CLUSTERED 
(
	[TicketId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
