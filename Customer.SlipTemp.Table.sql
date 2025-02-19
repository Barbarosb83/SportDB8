USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[SlipTemp]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[SlipTemp](
	[SlipId] [bigint] IDENTITY(24584,1) NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[TotalOddValue] [float] NULL,
	[Amount] [money] NULL,
	[SlipStateId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[GroupId] [bigint] NULL,
	[SlipTypeId] [int] NULL,
	[SourceId] [int] NULL,
	[SlipStatu] [int] NULL,
	[CurrencyId] [int] NULL,
	[EvaluateDate] [datetime] NULL,
	[EventCount] [int] NULL,
	[IsLive] [bit] NULL,
	[MTSTicketId] [bigint] NULL,
	[IsPayOut] [bit] NULL,
 CONSTRAINT [PK_SlipTemp] PRIMARY KEY CLUSTERED 
(
	[SlipId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Customer].[SlipTemp] ADD  CONSTRAINT [DF_SlipTemp_IsPayOut]  DEFAULT ((0)) FOR [IsPayOut]
GO
