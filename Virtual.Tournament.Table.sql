USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[Tournament]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[Tournament](
	[TournamentId] [bigint] NOT NULL,
	[CategoryId] [bigint] NULL,
	[SportId] [bigint] NULL,
	[Tournament] [nvarchar](250) NULL,
 CONSTRAINT [PK_Tournament_2] PRIMARY KEY CLUSTERED 
(
	[TournamentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
