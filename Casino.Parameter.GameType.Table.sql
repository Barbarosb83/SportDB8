USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[Parameter.GameType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[Parameter.GameType](
	[ParameterGameTypeId] [int] IDENTITY(1,1) NOT NULL,
	[GameType] [nvarchar](50) NULL
) ON [PRIMARY]
GO
