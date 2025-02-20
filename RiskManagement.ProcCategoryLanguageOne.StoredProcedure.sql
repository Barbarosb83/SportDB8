USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCategoryLanguageOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCategoryLanguageOne]
@ParameterCategoryId int


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.[Parameter.Category].ParameterCategoryId, Language.[Parameter.Category].LanguageId, Language.[Parameter.Category].CategoryName, 
                      Language.Language.Language
FROM         Parameter.Category INNER JOIN
                      Language.[Parameter.Category] ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId INNER JOIN
                      Language.Language ON Language.[Parameter.Category].LanguageId = Language.Language.LanguageId
WHERE     (Language.[Parameter.Category].ParameterCategoryId = @ParameterCategoryId)                    

END


GO
