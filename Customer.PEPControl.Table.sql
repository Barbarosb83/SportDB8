USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[PEPControl]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[PEPControl](
	[CustomerPepId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[CreateDate] [datetime] NULL,
	[Description] [nvarchar](150) NULL,
	[ExpriedDate] [datetime] NULL,
	[IsPep] [bit] NULL,
	[IsSanction] [bit] NULL,
	[IsDoc] [bit] NULL,
	[UpdateUserId] [int] NULL,
	[UpdateDate] [datetime] NULL,
 CONSTRAINT [PK_PEPControl] PRIMARY KEY CLUSTERED 
(
	[CustomerPepId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
