USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[NewOddType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[NewOddType](
	[OddId] [bigint] NULL,
	[OddType] [nvarchar](250) NULL,
	[OddTypeId] [int] NULL,
	[SubOddTypeId] [int] NULL,
	[OutComeId] [nvarchar](250) NULL,
	[OutCome] [nvarchar](250) NULL,
	[Sport] [nvarchar](250) NULL,
	[Language] [nvarchar](50) NULL
) ON [PRIMARY]
GO
