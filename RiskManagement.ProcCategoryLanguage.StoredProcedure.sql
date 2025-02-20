USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCategoryLanguage]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCategoryLanguage]
@CategoryId int,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.[Parameter.Category].ParameterCategoryId, Language.[Parameter.Category].LanguageId, Language.[Parameter.Category].CategoryName, 
                      Language.Language.Language
FROM         Parameter.Category INNER JOIN
                      Language.[Parameter.Category] ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId INNER JOIN
                      Language.Language ON Language.[Parameter.Category].LanguageId = Language.Language.LanguageId
WHERE     (Language.[Parameter.Category].CategoryId = @CategoryId)                    

END


GO
