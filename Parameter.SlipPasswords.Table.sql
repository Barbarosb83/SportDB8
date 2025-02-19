USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[SlipPasswords]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[SlipPasswords](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SlipPassword] [bigint] NULL,
	[SHAPassword] [nvarchar](250) NULL
) ON [PRIMARY]
GO
