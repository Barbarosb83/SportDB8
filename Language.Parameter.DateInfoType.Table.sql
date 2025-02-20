USE [Tip_SportDB]
GO
/****** Object:  Table [Language].[Parameter.DateInfoType]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Language].[Parameter.DateInfoType](
	[ParameterDateInfoTypeId] [int] IDENTITY(1,1) NOT NULL,
	[DateInfoTypeId] [int] NOT NULL,
	[LanguageId] [int] NOT NULL,
	[DateInfoType] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_Parameter.DateInfoType] PRIMARY KEY CLUSTERED 
(
	[ParameterDateInfoTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Language].[Parameter.DateInfoType]  WITH CHECK ADD  CONSTRAINT [FK_Parameter.DateInfoType_DateInfoType] FOREIGN KEY([DateInfoTypeId])
REFERENCES [Parameter].[DateInfoType] ([DateInfoTypeId])
GO
ALTER TABLE [Language].[Parameter.DateInfoType] CHECK CONSTRAINT [FK_Parameter.DateInfoType_DateInfoType]
GO
