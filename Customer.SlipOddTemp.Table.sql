USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[SlipOddTemp]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[SlipOddTemp](
	[SlipOddId] [bigint] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SlipId] [bigint] NOT NULL,
	[OddId] [bigint] NULL,
	[OddValue] [float] NULL,
	[Amount] [money] NULL,
	[StateId] [int] NULL,
	[BetTypeId] [int] NULL,
	[OutCome] [nvarchar](50) NULL,
	[MatchId] [bigint] NOT NULL,
	[OddsTypeId] [int] NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[ParameterOddId] [int] NULL,
	[EventName] [nvarchar](150) NULL,
	[EventDate] [datetime] NULL,
	[CurrencyId] [int] NULL,
	[Score] [nvarchar](50) NULL,
	[ScoreTimeStatu] [nvarchar](150) NULL,
	[SportId] [int] NULL,
	[Banko] [int] NULL,
	[BetradarMatchId] [bigint] NOT NULL,
	[OddProbValue] [float] NULL,
 CONSTRAINT [PK_SlipOddTemp] PRIMARY KEY CLUSTERED 
(
	[SlipOddId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Customer].[SlipOddTemp]  WITH CHECK ADD  CONSTRAINT [FK_SlipOddTemp_SlipState] FOREIGN KEY([StateId])
REFERENCES [Parameter].[SlipState] ([StateId])
GO
ALTER TABLE [Customer].[SlipOddTemp] CHECK CONSTRAINT [FK_SlipOddTemp_SlipState]
GO
