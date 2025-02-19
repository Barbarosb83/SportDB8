USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[NewCompetitor]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[NewCompetitor](
	[CompId] [bigint] NULL,
	[BetradarId] [bigint] NULL,
	[Competitor] [nvarchar](250) NULL,
	[Lang] [nvarchar](50) NULL
) ON [PRIMARY]
GO
