USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddsLanguage]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcOddsLanguage]
@OddId int,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.[Parameter.Odds].ParameterOddId,Language.Language.LanguageId, Language.Language.Language, Language.[Parameter.Odds].OutComes, Language.[Parameter.Odds].OddsId
FROM         Language.[Parameter.Odds] INNER JOIN
                      Language.Language ON Language.[Parameter.Odds].LanguageId = Language.Language.LanguageId
                      where Language.[Parameter.Odds].OddsId=@OddId

END


GO
