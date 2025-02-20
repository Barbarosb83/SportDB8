USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.CardType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.CardType](
	[ParameterCardTypeId] [int] IDENTITY(1,1) NOT NULL,
	[CardTypeId] [int] NOT NULL,
	[LanguageId] [int] NOT NULL,
	[CardName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Parameter.CardType] PRIMARY KEY CLUSTERED 
(
	[ParameterCardTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
