USE [Tip_SportDB]
GO
/****** Object:  Table [dbo].[betslip]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[betslip](
	[Id] [bigint] NULL,
	[data] [nvarchar](max) NULL,
	[CreateDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
