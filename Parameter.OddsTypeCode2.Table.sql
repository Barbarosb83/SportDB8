USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[OddsTypeCode2]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[OddsTypeCode2](
	[OddTypeCodeId] [bigint] IDENTITY(1,1) NOT NULL,
	[Comments] [nvarchar](50) NULL,
	[Tip] [nvarchar](10) NULL,
	[FirstHalf] [nvarchar](10) NULL,
	[DoubleChance] [nvarchar](10) NULL,
	[FirstHalfTip] [nvarchar](10) NULL,
	[Handicap] [nvarchar](10) NULL,
	[NextGoal] [nvarchar](10) NULL,
	[OverUnder] [nvarchar](10) NULL,
	[YesNo] [nvarchar](10) NULL,
	[Rest3way] [nvarchar](10) NULL,
	[RestFirstHalf3way] [nvarchar](10) NULL,
	[Special] [nvarchar](10) NULL,
	[BetType] [int] NULL,
	[BetradarOddTypeId] [int] NULL,
	[BetradarSubTyepId] [int] NULL,
	[OutCome] [nvarchar](50) NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
 CONSTRAINT [PK_OddsTypeCode2] PRIMARY KEY CLUSTERED 
(
	[OddTypeCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
