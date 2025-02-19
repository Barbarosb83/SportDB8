USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddTypeLanguageOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcOddTypeLanguageOne]
@ParameterOddTypeId int


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.Language.LanguageId, Language.Language.Language, Language.[Parameter.OddsType].OddsType, Language.[Parameter.OddsType].OddsTypeId
FROM         Language.[Parameter.OddsType] INNER JOIN
                      Language.Language ON Language.[Parameter.OddsType].LanguageId = Language.Language.LanguageId
                      where Language.[Parameter.OddsType].ParameterOddsTypeId=@ParameterOddTypeId

END


GO
