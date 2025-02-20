USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[SlipHistory]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[SlipHistory](
	[SlipHistoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[SlipOddId] [bigint] NULL,
	[ActionType] [int] NULL,
	[ActionDate] [datetime] NULL,
	[UserId] [int] NULL,
	[OldStateId] [int] NULL,
 CONSTRAINT [PK_SlipHistory] PRIMARY KEY CLUSTERED 
(
	[SlipHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
