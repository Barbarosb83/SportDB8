USE [Tip_SportDB]
GO
/****** Object:  Table [Stadium].[Customers]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stadium].[Customers](
	[StadiumCustomerId] [bigint] IDENTITY(1,1) NOT NULL,
	[StadiumId] [bigint] NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[SlipId] [bigint] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CardChangeCount] [int] NULL,
	[IsWon] [bit] NULL,
	[IsPay] [bit] NULL,
	[IsStadiumWon] [bit] NULL,
	[StateId] [int] NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[StadiumCustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
