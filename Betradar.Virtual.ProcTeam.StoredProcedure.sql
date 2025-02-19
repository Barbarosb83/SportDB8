USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcTeam]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Betradar].[Virtual.ProcTeam]
	@TeamId bigint,
    @Team nvarchar(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT [TeamId] FROM [Virtual].[Team] WHERE [Virtual].[Team].[TeamId]=@TeamId)
			BEGIN
			
				INSERT INTO [Virtual].[Team]
					   ([TeamId]
					   ,[Team])
				 VALUES
					   (@TeamId
					   ,@Team)


					     
     		END
				

END


GO
