USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[Sport]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[Sport](
	[SportId] [int] IDENTITY(1,1) NOT NULL,
	[BetRadarSportId] [int] NOT NULL,
	[SportName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Icon] [nvarchar](20) NULL,
	[IconColor] [nvarchar](20) NULL,
	[Limit] [money] NULL,
	[LimitPerTicket] [money] NULL,
	[AvailabilityId] [int] NULL,
	[SquanceNumber] [int] NULL,
	[LSId] [int] NULL,
 CONSTRAINT [PK_Sport] PRIMARY KEY CLUSTERED 
(
	[SportId] ASC,
	[BetRadarSportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Parameter].[Sport] ADD  CONSTRAINT [DF_Sport_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
