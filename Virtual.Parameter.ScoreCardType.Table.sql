USE [Tip_SportDB]
GO
/****** Object:  Table [Virtual].[Parameter.ScoreCardType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Virtual].[Parameter.ScoreCardType](
	[ScoreCardTypeId] [int] NOT NULL,
	[TypeName] [nchar](6) NOT NULL,
 CONSTRAINT [PK_Parameter.ScoreCardType] PRIMARY KEY CLUSTERED 
(
	[ScoreCardTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
