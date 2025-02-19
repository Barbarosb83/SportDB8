USE [Tip_SportDB]
GO
/****** Object:  Table [Users].[Controls]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[Controls](
	[ControlId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Title] [nvarchar](50) NULL,
	[ControlTypeId] [int] NOT NULL,
	[ParentControlId] [int] NULL,
	[Icon] [nvarchar](50) NULL,
	[Description] [nvarchar](150) NULL,
	[SeqNumber] [int] NULL,
 CONSTRAINT [PK_Controls] PRIMARY KEY CLUSTERED 
(
	[ControlId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Users].[Controls]  WITH CHECK ADD  CONSTRAINT [FK_Controls_ControlTypes] FOREIGN KEY([ControlTypeId])
REFERENCES [Users].[ControlTypes] ([ControlTypeId])
GO
ALTER TABLE [Users].[Controls] CHECK CONSTRAINT [FK_Controls_ControlTypes]
GO
