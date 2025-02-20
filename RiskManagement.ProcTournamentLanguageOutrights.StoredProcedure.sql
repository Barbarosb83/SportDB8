USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTournamentLanguageOutrights]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcTournamentLanguageOutrights]
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


SELECT    Language.[Parameter.TournamentOutrights].ParameterTournamentId, Language.[Parameter.TournamentOutrights].TournamentId, Language.Language.LanguageId, 
                      Language.Language.Language,Language.[Parameter.TournamentOutrights].TournamentName
FROM         Language.[Parameter.TournamentOutrights] INNER JOIN
                      Language.Language ON Language.[Parameter.TournamentOutrights].LanguageId = Language.Language.LanguageId
WHERE   Language.[Parameter.TournamentOutrights].TournamentId=@TournamentId                           

END


GO
