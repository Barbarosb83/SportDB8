USE [Tip_SportDB]
GO
/****** Object:  Table [Stadium].[Tournament]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stadium].[Tournament](
	[StadiumTournamentId] [bigint] IDENTITY(1,1) NOT NULL,
	[StadiumId] [bigint] NOT NULL,
	[TournamentId] [bigint] NOT NULL,
 CONSTRAINT [PK_Tournament_3] PRIMARY KEY CLUSTERED 
(
	[StadiumTournamentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
