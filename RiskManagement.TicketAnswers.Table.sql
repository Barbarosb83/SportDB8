USE [Tip_SportDB]
GO
/****** Object:  Table [RiskManagement].[TicketAnswers]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RiskManagement].[TicketAnswers](
	[TicketAnswerId] [bigint] IDENTITY(1,1) NOT NULL,
	[TicketId] [int] NOT NULL,
	[Answer] [nvarchar](max) NULL,
	[CreateDate] [datetime] NULL,
	[UserId] [int] NULL,
	[UploadFile] [nvarchar](250) NULL,
	[IsRead] [bit] NULL,
 CONSTRAINT [PK_TicketAnswers] PRIMARY KEY CLUSTERED 
(
	[TicketAnswerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
