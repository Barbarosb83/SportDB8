USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[Notes]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[Notes](
	[CustomerNotesId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUserId] [int] NULL,
	[Notes] [nvarchar](350) NULL,
	[IsPrivate] [bit] NULL
) ON [PRIMARY]
GO
