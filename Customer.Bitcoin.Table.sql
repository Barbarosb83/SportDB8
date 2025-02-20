USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[Bitcoin]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[Bitcoin](
	[BitcoinId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[Bitcoin] [money] NULL,
	[BitcoinAddress] [nvarchar](150) NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_Bitcoin] PRIMARY KEY CLUSTERED 
(
	[BitcoinId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
