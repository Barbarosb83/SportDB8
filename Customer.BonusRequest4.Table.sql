USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[BonusRequest4]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[BonusRequest4](
	[BonusRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[BonusId] [int] NULL,
	[IsEnable] [bit] NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_BonusRequest4] PRIMARY KEY CLUSTERED 
(
	[BonusRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
