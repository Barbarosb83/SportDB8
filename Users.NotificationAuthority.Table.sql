USE [Tip_SportDB]
GO
/****** Object:  Table [Users].[NotificationAuthority]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[NotificationAuthority](
	[NotificationAuthorityId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[NotificationFormId] [int] NULL,
	[IsEmail] [bit] NULL,
	[IsSms] [bit] NULL,
	[IsNotification] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_NotificationAuthority] PRIMARY KEY CLUSTERED 
(
	[NotificationAuthorityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
