USE [Tip_SportDB]
GO
/****** Object:  Table [RiskManagement].[SlipManuelEvo]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RiskManagement].[SlipManuelEvo](
	[SlipEvoId] [bigint] IDENTITY(1,1) NOT NULL,
	[SlipOddId] [bigint] NULL,
	[StateId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[IsEvo] [bit] NULL,
 CONSTRAINT [PK_SlipManuelEvo] PRIMARY KEY CLUSTERED 
(
	[SlipEvoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
