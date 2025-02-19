USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTournamentList]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcTournamentList] 
 
AS

BEGIN
SET NOCOUNT ON;


 select TournamentId, TournamentName,NewBetradarId as BetradarId
FROM         Parameter.Tournament
WHERE     (TournamentId <> 0)

END


GO
