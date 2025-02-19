USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddLanguageOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcOddLanguageOne]
@ParameterOddId int


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.[Parameter.Odds].ParameterOddId,Language.Language.LanguageId, Language.Language.Language, Language.[Parameter.Odds].OutComes, Language.[Parameter.Odds].OddsId
FROM         Language.[Parameter.Odds] INNER JOIN
                      Language.Language ON Language.[Parameter.Odds].LanguageId = Language.Language.LanguageId
                      where Language.[Parameter.Odds].ParameterOddId=@ParameterOddId

END


GO
