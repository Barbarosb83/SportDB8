USE [Tip_SportDB]
GO
/****** Object:  Table [MTS].[ErrorCancellation]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [MTS].[ErrorCancellation](
	[ErrorCancellationId] [bigint] NOT NULL,
	[ErrorDescription] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ErrorCancellation] PRIMARY KEY CLUSTERED 
(
	[ErrorCancellationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
