USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[OddResult]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[OddResult](
	[OddResultId] [bigint] IDENTITY(1,1) NOT NULL,
	[BetradarMatchId] [bigint] NOT NULL,
	[OddsTypeId] [int] NOT NULL,
	[Outcome] [nvarchar](50) NOT NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[ParameterOddId] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_OddResult_1] PRIMARY KEY CLUSTERED 
(
	[OddResultId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
