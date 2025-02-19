USE [Tip_SportDB]
GO
/****** Object:  Table [Log].[ErrorCodes]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Log].[ErrorCodes](
	[ErrorCodeId] [int] NOT NULL,
	[ErrorCode] [nvarchar](250) NULL,
	[LangId] [int] NULL
) ON [PRIMARY]
GO
