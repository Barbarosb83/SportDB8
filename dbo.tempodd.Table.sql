USE [Tip_SportDB]
GO
/****** Object:  Table [dbo].[tempodd]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tempodd](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OddtypeId] [bigint] NULL,
	[SubOddtype] [bigint] NULL,
	[Outcome] [nvarchar](50) NULL
) ON [PRIMARY]
GO
