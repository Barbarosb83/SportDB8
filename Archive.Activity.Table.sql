USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Activity]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Activity](
	[CustomerActivityId] [bigint] NOT NULL,
	[CustomerId] [bigint] NULL,
	[ActivtyId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[Browserr] [nvarchar](150) NULL,
	[IpAddress] [nvarchar](150) NULL,
 CONSTRAINT [PK_Login] PRIMARY KEY CLUSTERED 
(
	[CustomerActivityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
