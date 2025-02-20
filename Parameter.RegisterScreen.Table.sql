USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[RegisterScreen]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[RegisterScreen](
	[RegisterScreenId] [int] IDENTITY(1,1) NOT NULL,
	[FieldName] [nvarchar](50) NULL,
	[IsVisible] [bit] NULL,
	[IsRequried] [bit] NULL,
	[DefalutValue] [nvarchar](50) NULL
) ON [PRIMARY]
GO
