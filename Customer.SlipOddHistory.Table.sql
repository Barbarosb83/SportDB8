USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[SlipOddHistory]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[SlipOddHistory](
	[SlipId] [bigint] NULL,
	[OddId] [bigint] NULL,
	[OddValue] [float] NULL,
	[Amount] [money] NULL,
	[StateId] [int] NULL,
	[BetType] [int] NULL,
	[EventName] [nvarchar](150) NULL,
	[MatchId] [bigint] NULL,
	[CustomerId] [bigint] NULL,
	[LangId] [int] NULL,
	[Banko] [int] NULL
) ON [PRIMARY]
GO
