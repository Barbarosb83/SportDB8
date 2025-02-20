USE [Tip_SportDB]
GO
/****** Object:  Table [dbo].[testslip]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[testslip](
	[MatchCode] [nvarchar](50) NULL,
	[3way] [nvarchar](50) NULL,
	[FirtHalf] [nvarchar](50) NULL,
	[DoubleChance] [nvarchar](50) NULL,
	[FirstHalf3Way] [nvarchar](50) NULL,
	[Handicap] [nvarchar](50) NULL,
	[NextGoal] [nvarchar](50) NULL,
	[OverUnder] [nvarchar](50) NULL,
	[YesNo] [nvarchar](50) NULL,
	[Rest3way] [nvarchar](50) NULL,
	[RestFirstHalf3way] [nvarchar](50) NULL,
	[Special] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO
