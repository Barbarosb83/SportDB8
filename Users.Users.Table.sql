USE [Tip_SportDB]
GO
/****** Object:  Table [Users].[Users]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[Users](
	[UserId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RegistrationNumber] [int] NULL,
	[UserName] [nvarchar](50) NULL,
	[Password] [nvarchar](95) NULL,
	[Name] [nvarchar](100) NULL,
	[Surname] [nvarchar](100) NULL,
	[Email] [nvarchar](100) NULL,
	[GsmNo] [nvarchar](50) NULL,
	[TCNumber] [nvarchar](11) NULL,
	[PhoneNumber] [nvarchar](50) NULL,
	[UnitCode] [int] NULL,
	[UnitName] [nvarchar](150) NULL,
	[TitleCode] [nvarchar](50) NULL,
	[TitleName] [nvarchar](150) NULL,
	[SessionId] [nvarchar](50) NULL,
	[OTP] [nvarchar](50) NULL,
	[PositionCode] [nvarchar](50) NULL,
	[PositionName] [nvarchar](150) NULL,
	[IsLockedOut] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[LastLoginDate] [datetime] NULL,
	[LastPasswordChangeDate] [datetime] NULL,
	[LastLockOutDate] [datetime] NULL,
	[FailedPasswordAttemptCount] [int] NULL,
	[IsDeleted] [bit] NULL,
	[IpAddress] [nvarchar](50) NULL,
	[LastLoginFailedDate] [datetime] NULL,
	[RefUserId] [int] NULL,
	[Photo] [nvarchar](250) NULL,
	[TimeZoneId] [int] NULL,
	[CurrencyId] [int] NULL,
	[LanguageId] [int] NULL,
	[Multiplier] [float] NULL,
	[MultipDate] [nvarchar](20) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_BBUU]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_BBUU] ON [Users].[Users]
(
	[UnitCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Users] ON [Users].[Users]
(
	[UserName] ASC,
	[Email] ASC,
	[Password] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users_1]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Users_1] ON [Users].[Users]
(
	[UserName] ASC,
	[TimeZoneId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Users_2]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Users_2] ON [Users].[Users]
(
	[UserId] ASC,
	[IsLockedOut] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Users].[Users] ADD  CONSTRAINT [DF_Users_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
