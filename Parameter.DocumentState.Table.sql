USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[DocumentState]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[DocumentState](
	[DocumentStateId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentState] [nvarchar](50) NULL
) ON [PRIMARY]
GO
