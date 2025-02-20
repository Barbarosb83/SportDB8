USE [Tip_SportDB]
GO
/****** Object:  Table [Stadium].[Stadium]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stadium].[Stadium](
	[StadiumId] [bigint] IDENTITY(1,1) NOT NULL,
	[BranchId] [bigint] NULL,
	[EntranceFee] [money] NULL,
	[CurrencyId] [int] NULL,
	[MaxPlayer] [int] NULL,
	[MinPlayer] [int] NULL,
	[MinOddValue] [float] NULL,
	[MaxOddValue] [float] NULL,
	[ServiceFee] [float] NULL,
	[CardChangeCount] [int] NULL,
	[CardView] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[Comment] [nvarchar](max) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreateRuleId] [int] NULL,
	[ActivePlayerCount] [int] NULL,
	[CreateUserId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
