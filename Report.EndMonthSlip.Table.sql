USE [Tip_SportDB]
GO
/****** Object:  Table [Report].[EndMonthSlip]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Report].[EndMonthSlip](
	[SlipEndId] [bigint] IDENTITY(1,1) NOT NULL,
	[SlipId] [bigint] NOT NULL,
	[CustomerId] [bigint] NULL,
	[Amount] [money] NULL,
	[BranchId] [bigint] NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_EndMonthSlip] PRIMARY KEY CLUSTERED 
(
	[SlipEndId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
