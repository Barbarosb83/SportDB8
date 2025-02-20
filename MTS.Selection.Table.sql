USE [Tip_SportDB]
GO
/****** Object:  Table [MTS].[Selection]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MTS].[Selection](
	[SelectionId] [bigint] IDENTITY(1,1) NOT NULL,
	[TicketId] [bigint] NOT NULL,
	[line] [nchar](10) NOT NULL,
	[BetradarOddsTypeId] [int] NOT NULL,
	[BetradarOddsSubTypeId] [int] NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[Outcome] [nvarchar](50) NULL,
	[BetradarMatchId] [bigint] NOT NULL,
	[OddValue] [float] NOT NULL,
	[bank] [int] NULL,
	[ways] [int] NULL,
	[OddId] [bigint] NULL,
	[Amount] [money] NULL,
	[StateId] [int] NULL,
	[BetTypeId] [int] NULL,
	[MatchId] [bigint] NULL,
	[ParameterOddId] [int] NULL,
	[EventName] [nvarchar](150) NULL,
	[EventDate] [datetime] NULL,
	[CurrencyId] [int] NULL,
 CONSTRAINT [PK_Selection] PRIMARY KEY CLUSTERED 
(
	[SelectionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
