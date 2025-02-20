USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTournamentLanguage]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcTournamentLanguage]
@TournamentId int,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.[Parameter.Tournament].ParameterTournamentId, Language.[Parameter.Tournament].TournamentId, Language.Language.LanguageId, 
                      Language.Language.Language, Language.[Parameter.Tournament].TournamentName
FROM         Language.[Parameter.Tournament] INNER JOIN
                      Language.Language ON Language.[Parameter.Tournament].LanguageId = Language.Language.LanguageId
WHERE   Language.[Parameter.Tournament].TournamentId=@TournamentId                           

END


GO
