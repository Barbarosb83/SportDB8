USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Virtual].[GamePlatform.ProcVTORound]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Virtual].[GamePlatform.ProcVTORound]
	@LangId int,
	@RoundId int,
	@TournamentId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select Tournament,(SELECT   Virtual.[Parameter.TennisRound].[Round] FROM Virtual.[Parameter.TennisRound] where Virtual.[Parameter.TennisRound].TennisRoundId=@RoundId)  as RoundName
from Virtual.Tournament where Virtual.Tournament.TournamentId=@TournamentId
    
END


GO
