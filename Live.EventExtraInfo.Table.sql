USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[EventExtraInfo]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[EventExtraInfo](
	[ExtraInfoId] [int] IDENTITY(1,1) NOT NULL,
	[EventId] [bigint] NOT NULL,
	[ExtraInfoType] [nvarchar](100) NULL,
	[ExtraInfoValue] [nvarchar](100) NULL,
 CONSTRAINT [PK_EventExtraInfo] PRIMARY KEY CLUSTERED 
(
	[ExtraInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
