USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[SwissSoft.Customer]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[SwissSoft.Customer](
	[SwisssoftCustomerId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[TokenId] [nvarchar](150) NULL,
	[SesionId] [nvarchar](150) NULL,
 CONSTRAINT [PK_SwissSoft.Customer] PRIMARY KEY CLUSTERED 
(
	[SwisssoftCustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
