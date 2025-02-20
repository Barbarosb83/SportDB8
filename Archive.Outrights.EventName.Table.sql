USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[Outrights.EventName]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[Outrights.EventName](
	[EventNameId] [bigint] NOT NULL,
	[EventId] [bigint] NOT NULL,
	[EventName] [nvarchar](250) NOT NULL,
	[LanguageId] [int] NOT NULL,
 CONSTRAINT [PK_EventName] PRIMARY KEY CLUSTERED 
(
	[EventNameId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
