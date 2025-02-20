USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[StatusInfo]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[StatusInfo](
	[StatusInfoId] [int] NOT NULL,
	[StatusInfoName] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_StatusInfo] PRIMARY KEY CLUSTERED 
(
	[StatusInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
