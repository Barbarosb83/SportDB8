USE [Tip_SportDB]
GO
/****** Object:  Table [Casino].[SwissSoft.CustomerTransaction]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Casino].[SwissSoft.CustomerTransaction](
	[SwissSoftTransactionId] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NULL,
	[SessionId] [nvarchar](150) NULL,
	[Action] [nvarchar](50) NULL,
	[Amount] [money] NULL,
	[ActionId] [nvarchar](150) NULL,
	[CreateDate] [datetime] NULL,
	[GameId] [nvarchar](100) NULL,
 CONSTRAINT [PK_SwissSoft.CustomerTransaction] PRIMARY KEY CLUSTERED 
(
	[SwissSoftTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
