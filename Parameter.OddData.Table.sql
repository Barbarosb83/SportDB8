USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[OddData]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[OddData](
	[OddDataId] [int] IDENTITY(1,1) NOT NULL,
	[OddData] [nvarchar](max) NULL,
	[CreateDate] [datetime] NULL,
	[UpdateDate] [datetime] NULL,
	[Types] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
