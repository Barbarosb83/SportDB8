USE [Tip_SportDB]
GO
/****** Object:  Table [Customer].[SlipSystemTemp]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Customer].[SlipSystemTemp](
	[SystemSlipId] [bigint] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [PK_SystemSlipTemp] PRIMARY KEY CLUSTERED 
(
	[SystemSlipId] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Customer].[SlipSystemTemp] ADD  CONSTRAINT [DF_SlipSystemTemp_IsPayOut]  DEFAULT ((0)) FOR [IsPayOut]
GO
