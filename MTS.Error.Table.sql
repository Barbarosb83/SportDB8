USE [Tip_SportDB]
GO
/****** Object:  Table [MTS].[Error]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MTS].[Error](
	[MTSErrorId] [int] NOT NULL,
	[ErrorDescription] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
