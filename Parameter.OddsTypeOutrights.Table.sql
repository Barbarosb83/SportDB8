USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[OddsTypeOutrights]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[OddsTypeOutrights](
	[OddsTypeId] [int] IDENTITY(1,1) NOT NULL,
	[BetradarOddsTypeId] [int] NOT NULL,
	[OddsType] [nvarchar](150) NULL,
	[OutcomesDescription] [nvarchar](250) NULL,
	[SportId] [int] NOT NULL,
	[AvailabilityId] [int] NULL,
	[IsActive] [bit] NULL,
	[ShortSign] [nvarchar](20) NULL,
	[IsPopular] [bit] NULL,
	[SeqNumber] [int] NULL,
	[LSId] [int] NULL,
 CONSTRAINT [PK_OddsTypeOutrights] PRIMARY KEY CLUSTERED 
(
	[OddsTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
