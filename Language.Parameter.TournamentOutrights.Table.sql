USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.TournamentOutrights]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.TournamentOutrights](
	[ParameterTournamentId] [int] IDENTITY(1,1) NOT NULL,
	[TournamentId] [int] NULL,
	[LanguageId] [int] NULL,
	[TournamentName] [nvarchar](250) NULL,
	[SuperTournamentName] [nvarchar](250) NULL,
 CONSTRAINT [PK_Parameter.TournamentOutrights] PRIMARY KEY CLUSTERED 
(
	[ParameterTournamentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Parameter.TournamentOutrights]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Parameter.TournamentOutrights] ON [Language].[Parameter.TournamentOutrights]
(
	[TournamentId] ASC,
	[LanguageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
