USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Ip]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Ip](
	[CustomerIpId] [bigint] NOT NULL,
	[CustomerId] [int] NULL,
	[IpAddress] [nvarchar](100) NOT NULL,
	[LoginDate] [datetime] NULL,
 CONSTRAINT [PK_Ip] PRIMARY KEY CLUSTERED 
(
	[CustomerIpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
