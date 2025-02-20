USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcCategory]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Betradar].[Virtual.ProcCategory]
	@CategoryId bigint,
    @SportId bigint,
    @Category nvarchar(150)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT [CategoryId] FROM [Virtual].[Category] WHERE [Virtual].[Category].[CategoryId]=@CategoryId)
		BEGIN
				INSERT INTO [Virtual].[Category] ([CategoryId],[SportId],[Category])
						 VALUES (@CategoryId, @SportId, @Category)
		END
				

END


GO
