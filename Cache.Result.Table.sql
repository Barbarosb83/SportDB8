USE [Tip_SportDB]
GO
/****** Object:  Table [Cache].[Result]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cache].[Result](
	[ResultId] [int] IDENTITY(1,1) NOT NULL,
	[EventDate] [datetime] NULL,
	[Team1Id] [bigint] NULL,
	[Team2Id] [bigint] NULL,
	[FTScore] [nvarchar](50) NULL,
	[HTScore] [nvarchar](50) NULL,
	[SportId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	[TournamentId] [int] NOT NULL,
	[MatchId] [bigint] NULL,
 CONSTRAINT [PK_Result] PRIMARY KEY CLUSTERED 
(
	[ResultId] ASC,
	[SportId] ASC,
	[CategoryId] ASC,
	[TournamentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
