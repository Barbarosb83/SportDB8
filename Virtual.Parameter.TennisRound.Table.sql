USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[Parameter.TennisRound]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[Parameter.TennisRound](
	[TennisRoundId] [int] NOT NULL,
	[Round] [nvarchar](15) NULL,
 CONSTRAINT [PK_Parameter.TennisRound] PRIMARY KEY CLUSTERED 
(
	[TennisRoundId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
