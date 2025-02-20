USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.CupRound]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.CupRound](
	[ParameterCupRoundId] [int] IDENTITY(1,1) NOT NULL,
	[CupRoundId] [int] NOT NULL,
	[LanguageId] [int] NOT NULL,
	[CupRoundName] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Parameter.CupRound] PRIMARY KEY CLUSTERED 
(
	[ParameterCupRoundId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Language].[Parameter.CupRound]  WITH CHECK ADD  CONSTRAINT [FK_Parameter.CupRound_CupRound] FOREIGN KEY([CupRoundId])
REFERENCES [Parameter].[CupRound] ([CupRoundId])
GO
ALTER TABLE [Language].[Parameter.CupRound] CHECK CONSTRAINT [FK_Parameter.CupRound_CupRound]
GO
