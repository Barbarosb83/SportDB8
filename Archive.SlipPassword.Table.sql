USE [Tip_SportDB]
GO
/****** Object:  Table [Archive].[SlipPassword]    Script Date: 2/19/2025 7:03:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Archive].[SlipPassword](
	[SlipPasswordId] [bigint] NOT NULL,
	[SlipId] [bigint] NULL,
	[Password] [nvarchar](150) NULL,
	[TryCount] [int] NULL,
 CONSTRAINT [PK_SlipPassword] PRIMARY KEY CLUSTERED 
(
	[SlipPasswordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Archive].[SlipPassword] ADD  CONSTRAINT [DF_SlipPassword_TryCount]  DEFAULT ((0)) FOR [TryCount]
GO
