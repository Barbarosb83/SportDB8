USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Betradar].[Virtual.ProcTournament]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Betradar].[Virtual.ProcTournament]
	@TournamentId bigint,
	@CategoryId bigint,
    @SportId bigint,
    @Tournament nvarchar(250)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (SELECT [TournamentId] FROM [Virtual].[Tournament] WHERE [Virtual].[Tournament].[TournamentId]=@TournamentId)
			BEGIN
			
				INSERT INTO [Virtual].[Tournament] ([TournamentId] ,[CategoryId],[SportId],[Tournament])
					VALUES (@TournamentId,@CategoryId,@SportId,@Tournament)
					     
     		END
     		else
     		begin
     			UPDATE [OxxoBet].[Virtual].[Tournament]
				   SET [TournamentId] = @TournamentId
					  ,[CategoryId] = @CategoryId
					  ,[SportId] = @SportId
					  ,[Tournament] = @Tournament
				WHERE [Virtual].[Tournament].[TournamentId]=@TournamentId


     		end
				

END


GO
