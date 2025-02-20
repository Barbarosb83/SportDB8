USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[EventLiveStreaming]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[EventLiveStreaming](
	[EventLiveId] [bigint] IDENTITY(1,1) NOT NULL,
	[BetradarMatchId] [bigint] NULL,
	[StartTime] [datetime] NULL,
	[HomeTeam] [nvarchar](250) NULL,
	[AwayTeam] [nvarchar](250) NULL,
	[Competition] [nvarchar](250) NULL,
	[Sport] [nvarchar](150) NULL,
	[Court] [nvarchar](150) NULL,
	[IsActive] [bit] NULL,
	[IsLive] [bit] NULL,
	[Mobil] [bit] NULL,
	[Web] [bit] NULL,
	[Country] [nvarchar](150) NULL
) ON [PRIMARY]
GO
