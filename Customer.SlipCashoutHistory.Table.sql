USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[SlipCashoutHistory]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[SlipCashoutHistory](
	[HistoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[SlipId] [bigint] NOT NULL,
	[CashoutValue] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Activity] [nvarchar](50) NULL,
 CONSTRAINT [PK_SlipCashoutHistory] PRIMARY KEY CLUSTERED 
(
	[HistoryId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
