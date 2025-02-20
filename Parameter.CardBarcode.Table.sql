USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[CardBarcode]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[CardBarcode](
	[BarcodeId] [bigint] IDENTITY(1,1) NOT NULL,
	[BarcodeNumber] [bigint] NULL,
	[IsUsed] [bit] NULL,
 CONSTRAINT [PK_CardBarcode_1] PRIMARY KEY CLUSTERED 
(
	[BarcodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_CardBarcode_4]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_CardBarcode_4] ON [Parameter].[CardBarcode]
(
	[BarcodeNumber] ASC,
	[IsUsed] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
