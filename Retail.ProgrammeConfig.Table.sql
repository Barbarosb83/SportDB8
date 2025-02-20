USE [Tip_SportDB]
GO
/****** Object:  Table [Retail].[ProgrammeConfig]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Retail].[ProgrammeConfig](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SportId] [int] NULL,
	[CategoryId] [int] NULL,
	[TournamentId] [int] NULL,
	[ReportCount] [int] NULL,
	[IsHighlights] [bit] NULL,
	[IsEnable] [bit] NULL,
 CONSTRAINT [PK_ProgrammeConfig] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Retail].[ProgrammeConfig] ADD  CONSTRAINT [DF_ProgrammeConfig_IsEnable]  DEFAULT ((1)) FOR [IsEnable]
GO
