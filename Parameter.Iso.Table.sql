USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[Iso]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[Iso](
	[IsoId] [int] NOT NULL,
	[BetradarIsoId] [bigint] NOT NULL,
	[IsoName] [nchar](3) NULL,
	[IsoName3] [nvarchar](3) NULL,
	[PhoneCode] [nvarchar](10) NULL,
	[CountryName] [nvarchar](250) NULL,
	[IsoName2] [nvarchar](2) NULL,
 CONSTRAINT [PK_Iso] PRIMARY KEY CLUSTERED 
(
	[IsoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_Iso]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_Iso] ON [Parameter].[Iso]
(
	[BetradarIsoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
