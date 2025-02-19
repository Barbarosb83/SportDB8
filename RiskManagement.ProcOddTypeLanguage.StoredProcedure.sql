USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddTypeLanguage]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcOddTypeLanguage]
@OddTypeId int,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.[Parameter.OddsType].ParameterOddsTypeId,Language.Language.LanguageId, Language.Language.Language, Language.[Parameter.OddsType].OddsType, Language.[Parameter.OddsType].OddsTypeId
FROM         Language.[Parameter.OddsType] INNER JOIN
                      Language.Language ON Language.[Parameter.OddsType].LanguageId = Language.Language.LanguageId
                      where Language.[Parameter.OddsType].OddsTypeId=@OddTypeId

END


GO
