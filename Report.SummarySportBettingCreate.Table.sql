USE [Tip_SportDB]
GO
/****** Object:  Table [Report].[SummarySportBettingCreate]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Report].[SummarySportBettingCreate](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_SummarySportBettingCreate] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
