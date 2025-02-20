USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[DeviceToken]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[DeviceToken](
	[TokenId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[DeviceId] [nvarchar](150) NULL,
	[AndroidToken] [nvarchar](150) NULL,
	[IOSToken] [nvarchar](150) NULL,
	[CreateDate] [datetime] NULL,
	[IsNotification] [bit] NULL,
 CONSTRAINT [PK_DeviceToken] PRIMARY KEY CLUSTERED 
(
	[TokenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
