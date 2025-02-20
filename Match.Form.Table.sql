USE [Tip_SportDB]
GO
/****** Object:  Table [Match].[Form]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Match].[Form](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[TournamentId] [int] NOT NULL,
	[TeamId] [int] NOT NULL,
	[TeamName] [nvarchar](250) NULL,
	[Form] [nvarchar](50) NULL,
	[Win] [int] NULL,
	[Draw] [int] NULL,
	[Lost] [int] NULL,
	[Points] [int] NULL,
	[Goal] [nvarchar](150) NULL
) ON [PRIMARY]
GO
