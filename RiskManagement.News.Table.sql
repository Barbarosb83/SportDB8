USE [Tip_SportDB]
GO
/****** Object:  Table [RiskManagement].[News]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RiskManagement].[News](
	[NewsId] [bigint] IDENTITY(1,1) NOT NULL,
	[News] [nvarchar](max) NULL,
	[LangId] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[CreateUserId] [int] NULL,
	[IsTerminalView] [bit] NULL,
	[IsBranchView] [bit] NULL,
	[IsTvView] [bit] NULL,
	[IsWebView] [bit] NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_News] PRIMARY KEY CLUSTERED 
(
	[NewsId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
