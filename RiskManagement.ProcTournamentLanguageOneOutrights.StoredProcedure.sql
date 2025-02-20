USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTournamentLanguageOneOutrights]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcTournamentLanguageOneOutrights]
@ParameterTournamentId bigint


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.[Parameter.TournamentOutrights].ParameterTournamentId, Language.[Parameter.TournamentOutrights].TournamentId, Language.Language.LanguageId, 
                      Language.Language.Language, Language.[Parameter.TournamentOutrights].TournamentName
FROM         Language.[Parameter.TournamentOutrights] INNER JOIN
                      Language.Language ON Language.[Parameter.TournamentOutrights].LanguageId = Language.Language.LanguageId
WHERE   Language.[Parameter.TournamentOutrights].ParameterTournamentId=@ParameterTournamentId

END


GO
