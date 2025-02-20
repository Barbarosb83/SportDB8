USE [Tip_SportDB]
GO
/****** Object:  Table [Report].[VFLReport]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Report].[VFLReport](
	[VSReportId] [int] IDENTITY(1,1) NOT NULL,
	[ReportDate] [date] NULL,
	[VFLSeason] [nvarchar](50) NULL,
	[SourceId] [int] NULL,
	[BetsCount] [int] NULL,
	[TurnOver] [money] NULL,
	[BetGain] [money] NULL,
	[IsSingle] [bit] NULL
) ON [PRIMARY]
GO
