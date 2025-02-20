USE [Tip_SportDB]
GO
/****** Object:  Table [Report].[EndMonthBalance]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Report].[EndMonthBalance](
	[CustomerEndId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[BranchId] [int] NULL,
	[Balance] [money] NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_EndMonthBalance] PRIMARY KEY CLUSTERED 
(
	[CustomerEndId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
