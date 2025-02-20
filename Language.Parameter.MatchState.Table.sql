USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.MatchState]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.MatchState](
	[ParameterMatchStateId] [int] IDENTITY(1,1) NOT NULL,
	[MatchStateId] [int] NULL,
	[LanguageId] [int] NULL,
	[MatchState] [nvarchar](20) NULL,
 CONSTRAINT [PK_Language.Parameter.MatchState] PRIMARY KEY CLUSTERED 
(
	[ParameterMatchStateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
