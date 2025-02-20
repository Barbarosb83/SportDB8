USE [Tip_SportDB]
GO
/****** Object:  Table [Cache].[Sport]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Cache].[Sport](
	[CacheSportId] [int] IDENTITY(1,1) NOT NULL,
	[SportId] [int] NOT NULL,
	[EventCount] [int] NULL,
	[EndDay] [int] NOT NULL,
 CONSTRAINT [PK_Sport_1] PRIMARY KEY CLUSTERED 
(
	[CacheSportId] ASC,
	[EndDay] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
