USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[ZipCode]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[ZipCode](
	[ZipCodeId] [bigint] IDENTITY(1,1) NOT NULL,
	[Zipcode] [nvarchar](20) NULL,
	[Ort] [nvarchar](150) NULL,
	[City] [nvarchar](150) NULL,
 CONSTRAINT [PK_ZipCode] PRIMARY KEY CLUSTERED 
(
	[ZipCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
