USE [Tip_SportDB]
GO
/****** Object:  Table [Users].[Notifications]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[Notifications](
	[NotificationId] [int] IDENTITY(1,1) NOT NULL,
	[FromUserId] [int] NULL,
	[ToUserId] [int] NULL,
	[NotificationFormId] [int] NULL,
	[ControlId] [int] NULL,
	[Notification] [nvarchar](max) NULL,
	[CreateDate] [datetime] NULL,
	[IsSmsSend] [bit] NULL,
	[IsEmailSend] [bit] NULL,
	[IsNotyRead] [bit] NULL,
	[CustomerId] [bigint] NULL,
 CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED 
(
	[NotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_BBUN]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BBUN] ON [Users].[Notifications]
(
	[ToUserId] ASC,
	[IsNotyRead] ASC
)
INCLUDE([FromUserId],[NotificationFormId],[ControlId],[Notification],[CreateDate],[CustomerId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Notifications]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Notifications] ON [Users].[Notifications]
(
	[ToUserId] ASC,
	[IsNotyRead] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_UN]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_UN] ON [Users].[Notifications]
(
	[ToUserId] ASC,
	[NotificationFormId] ASC,
	[IsNotyRead] ASC
)
INCLUDE([FromUserId],[ControlId],[Notification],[CreateDate],[CustomerId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
