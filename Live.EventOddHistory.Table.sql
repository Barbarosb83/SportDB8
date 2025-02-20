USE [Tip_SportDB]
GO
/****** Object:  Table [Live].[EventOddHistory]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Live].[EventOddHistory](
	[OddHistoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[OddId] [bigint] NULL,
	[OutCome] [nvarchar](50) NULL,
	[SpecialBetValue] [nvarchar](50) NULL,
	[OddValue] [float] NULL,
	[Suggestion] [float] NULL,
	[IsActive] [bit] NULL,
	[OddResult] [bit] NULL,
	[VoidFactor] [float] NULL,
	[IsCanceled] [bit] NULL,
	[IsEvaluated] [bit] NULL,
	[OddFactor] [float] NULL,
	[ChangeDate] [datetime] NULL,
 CONSTRAINT [PK_EventOddHistory] PRIMARY KEY CLUSTERED 
(
	[OddHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Live].[EventOddHistory] ADD  CONSTRAINT [DF_EventOddHistory_OddFactor]  DEFAULT ((1)) FOR [OddFactor]
GO
