USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[QrCodeLog]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[QrCodeLog](
	[QrCodeId] [bigint] IDENTITY(1,1) NOT NULL,
	[BranchId] [bigint] NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[Comment] [nvarchar](50) NULL,
 CONSTRAINT [PK_QrCodeLog] PRIMARY KEY CLUSTERED 
(
	[QrCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
