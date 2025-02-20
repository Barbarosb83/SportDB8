USE [Tip_SportDB]
GO
/****** Object:  Table [Parameter].[PaymentTypeDescription]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Parameter].[PaymentTypeDescription](
	[PaymentDescId] [int] IDENTITY(1,1) NOT NULL,
	[PaymentTypeId] [int] NULL,
	[LanguageId] [int] NULL,
	[Title] [nvarchar](150) NULL,
	[DescriptionTitle] [nvarchar](150) NULL,
	[Description] [nvarchar](150) NULL,
 CONSTRAINT [PK_PaymentTypeDescription] PRIMARY KEY CLUSTERED 
(
	[PaymentDescId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_PaymentTypeDescription]    Script Date: 2/19/2025 7:03:38 AM ******/
CREATE NONCLUSTERED INDEX [IX_PaymentTypeDescription] ON [Parameter].[PaymentTypeDescription]
(
	[PaymentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
