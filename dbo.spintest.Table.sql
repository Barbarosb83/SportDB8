USE [Tip_SportDB]
GO
/****** Object:  Table [dbo].[spintest]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[spintest](
	[CustomerID] [bigint] NULL,
	[GameId] [nvarchar](250) NULL,
	[TransId] [nvarchar](250) NULL,
	[Amount] [money] NULL,
	[Round] [nvarchar](50) NULL,
	[CreateDate] [datetime] NULL
) ON [PRIMARY]
GO
