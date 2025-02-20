USE [Tip_SportDB]
GO
/****** Object:  Table [Users].[RoleControls]    Script Date: 2/19/2025 7:03:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Users].[RoleControls](
	[RoleControlId] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[ControlId] [int] NULL,
	[IsUpdate] [bit] NULL,
	[IsDelete] [bit] NULL,
	[IsSelect] [bit] NULL,
	[IsInsert] [bit] NULL,
 CONSTRAINT [PK_RoleControls] PRIMARY KEY CLUSTERED 
(
	[RoleControlId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Users].[RoleControls] ADD  CONSTRAINT [DF_RoleControls_IsUpdate]  DEFAULT ((1)) FOR [IsUpdate]
GO
ALTER TABLE [Users].[RoleControls] ADD  CONSTRAINT [DF_RoleControls_IsDelete]  DEFAULT ((1)) FOR [IsDelete]
GO
ALTER TABLE [Users].[RoleControls] ADD  CONSTRAINT [DF_RoleControls_IsSelect]  DEFAULT ((1)) FOR [IsSelect]
GO
ALTER TABLE [Users].[RoleControls] ADD  CONSTRAINT [DF_RoleControls_IsInsert]  DEFAULT ((1)) FOR [IsInsert]
GO
ALTER TABLE [Users].[RoleControls]  WITH CHECK ADD  CONSTRAINT [FK_RoleControls_Controls] FOREIGN KEY([ControlId])
REFERENCES [Users].[Controls] ([ControlId])
GO
ALTER TABLE [Users].[RoleControls] CHECK CONSTRAINT [FK_RoleControls_Controls]
GO
ALTER TABLE [Users].[RoleControls]  WITH CHECK ADD  CONSTRAINT [FK_RoleControls_Roles] FOREIGN KEY([RoleId])
REFERENCES [Users].[Roles] ([RoleId])
GO
ALTER TABLE [Users].[RoleControls] CHECK CONSTRAINT [FK_RoleControls_Roles]
GO
