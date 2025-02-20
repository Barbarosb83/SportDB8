USE [Tip_SportDB]
GO
/****** Object:  Table [CasinoGame].[Provider]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [CasinoGame].[Provider](
	[ProviderId] [bigint] NOT NULL,
	[ProviderName] [nvarchar](250) NULL,
	[ProviderKey] [nvarchar](50) NULL,
	[ProviderText] [nvarchar](50) NULL,
	[Img] [nvarchar](50) NULL,
	[Logo] [nvarchar](50) NULL,
	[RowNumber] [int] NULL,
	[IsEnabled] [bit] NULL,
 CONSTRAINT [PK_Provider] PRIMARY KEY CLUSTERED 
(
	[ProviderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
