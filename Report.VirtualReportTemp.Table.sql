USE [Tip_SportDB]
GO
/****** Object:  Table [Report].[VirtualReportTemp]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Report].[VirtualReportTemp](
	[RowNum] [int] NULL,
	[ReportDate] [date] NULL,
	[VFLSeason] [nvarchar](50) NULL,
	[SourceId] [int] NULL,
	[BetsCount] [int] NULL,
	[TurnOver] [money] NULL,
	[HouseHold] [money] NULL,
	[Margin] [float] NULL,
	[BetsCountSingle] [int] NULL,
	[TurnOverSingle] [money] NULL,
	[HouseHoldSingle] [money] NULL,
	[MarginSingle] [float] NULL,
	[BetsCountCombi] [int] NULL,
	[TurnOverCombi] [money] NULL,
	[HouseHoldCombi] [money] NULL,
	[MarginCombi] [float] NULL
) ON [PRIMARY]
GO
