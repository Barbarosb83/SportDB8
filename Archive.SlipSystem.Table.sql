USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[SlipSystem]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[SlipSystem](
	[SystemSlipId] [bigint] NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[MaxGain] [money] NULL,
	[TotalOddValue] [float] NULL,
	[Amount] [money] NULL,
	[SlipStateId] [int] NULL,
	[CreateDate] [datetime] NULL,
	[GroupId] [bigint] NULL,
	[SlipTypeId] [int] NULL,
	[SourceId] [int] NULL,
	[SlipStatuId] [int] NULL,
	[CurrencyId] [int] NULL,
	[EvaluateDate] [datetime] NULL,
	[EventCount] [int] NULL,
	[IsLive] [bit] NULL,
	[System] [nvarchar](150) NULL,
	[IsPayOut] [bit] NULL,
	[CouponCount] [int] NULL,
	[NewSlipTypeId] [int] NULL,
	[MaxGain2] [money] NULL,
 CONSTRAINT [PK_SystemSlip] PRIMARY KEY CLUSTERED 
(
	[SystemSlipId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
