USE [Tip_SportDB]
GO
/****** Object:  Table [Users].[NotificationForm]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[NotificationForm](
	[NotificationFormId] [int] IDENTITY(1,1) NOT NULL,
	[NotificationForm] [nvarchar](100) NULL,
	[NotificationFormLink] [nvarchar](max) NULL,
 CONSTRAINT [PK_NotificationForm] PRIMARY KEY CLUSTERED 
(
	[NotificationFormId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
