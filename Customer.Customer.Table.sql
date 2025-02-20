USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[Customer]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[Customer](
	[CustomerId] [bigint] IDENTITY(1000,1) NOT FOR REPLICATION NOT NULL,
	[SalutationId] [int] NULL,
	[CustomerName] [nvarchar](150) NULL,
	[CurrencyId] [int] NULL,
	[Balance] [decimal](18, 2) NULL,
	[Username] [nvarchar](50) NULL,
	[Password] [nvarchar](95) NULL,
	[CreateDate] [datetime] NULL,
	[LastLoginDate] [datetime] NULL,
	[LastPasswordChangeDate] [datetime] NULL,
	[FailedPasswordAttemptCount] [int] NULL,
	[IpAddress] [nvarchar](50) NULL,
	[LastLoginFailedDate] [datetime] NULL,
	[IsLockedOut] [bit] NULL,
	[CustomerSurname] [nvarchar](50) NULL,
	[Email] [nvarchar](50) NULL,
	[Birthday] [datetime] NULL,
	[PhoneCodeId] [int] NULL,
	[PhoneNumber] [nvarchar](50) NULL,
	[LanguageId] [int] NULL,
	[BranchId] [int] NULL,
	[IsActive] [bit] NULL,
	[LastLockOutDate] [datetime] NULL,
	[TimeZoneId] [int] NULL,
	[OddsFormatId] [nvarchar](150) NULL,
	[CountryId] [int] NULL,
	[PasswordQuestionId] [int] NULL,
	[PasswordQuestion] [nvarchar](150) NULL,
	[ZipCode] [nvarchar](15) NULL,
	[Address] [nvarchar](250) NULL,
	[AddressAdditional] [nvarchar](250) NULL,
	[IsOddIncreasement] [bit] NULL,
	[IsOddDecreasements] [bit] NULL,
	[City] [nvarchar](150) NULL,
	[IsTempLock] [bit] NULL,
	[TempLockOutdate] [datetime] NULL,
	[RecoveryCode] [char](36) NULL,
	[RecoveryDate] [datetime] NULL,
	[GroupId] [int] NULL,
	[Bonus] [money] NULL,
	[IsVerification] [bit] NULL,
	[IsBranchCustomer] [bit] NULL,
	[IsTerminalCustomer] [bit] NULL,
	[IdNumber] [nvarchar](150) NULL,
	[PassportNumber] [nvarchar](150) NULL,
	[BirthPlace] [nvarchar](150) NULL,
	[TaxNo] [nvarchar](150) NULL,
	[RiskLevelId] [int] NULL,
	[SourceId] [int] NULL,
	[IsPromotion] [bit] NULL,
	[IsActiveChangeUser] [nvarchar](50) NULL,
	[IsActiveChangeDate] [datetime] NULL,
	[ChangeTempLockOutDate] [datetime] NULL,
	[CountryOfBirth] [nvarchar](150) NULL,
	[Nationalty] [nvarchar](150) NULL,
	[OasisId] [nvarchar](150) NULL,
	[AccountLockReason] [nvarchar](250) NULL,
	[IBAN] [nvarchar](50) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_CC1]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_CC1] ON [Customer].[Customer]
(
	[IsBranchCustomer] ASC
)
INCLUDE([CustomerId],[BranchId],[CountryId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CC2]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_CC2] ON [Customer].[Customer]
(
	[BranchId] ASC,
	[IsBranchCustomer] ASC
)
INCLUDE([CustomerId],[CountryId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Customer]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Customer] ON [Customer].[Customer]
(
	[Username] ASC,
	[Email] ASC,
	[Password] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Customer_1]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_1] ON [Customer].[Customer]
(
	[IsBranchCustomer] ASC,
	[IsTerminalCustomer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Customer_2]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_2] ON [Customer].[Customer]
(
	[CustomerId] ASC,
	[IsTerminalCustomer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Customer_3]    Script Date: 2/19/2025 7:03:37 AM ******/
CREATE NONCLUSTERED INDEX [IX_Customer_3] ON [Customer].[Customer]
(
	[CustomerId] ASC,
	[BranchId] ASC,
	[IsBranchCustomer] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [Customer].[Customer] ADD  CONSTRAINT [DF_Customer_PhoneNumber]  DEFAULT ((1)) FOR [PhoneNumber]
GO
