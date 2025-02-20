USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCompetitorLanguage]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCompetitorLanguage]
@CompetitorId bigint,
 @PageSize  INT,
 @PageNum int,
@Username nvarchar(50),
@where nvarchar(1000),
@orderby nvarchar(100),
@LangId int


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.ParameterCompetitor.ParameterCompetitorId, Language.ParameterCompetitor.CompetitorId, Language.ParameterCompetitor.LanguageId, 
                      Language.ParameterCompetitor.CompetitorName, Language.Language.Language
FROM         Parameter.Competitor INNER JOIN
                      Language.ParameterCompetitor ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId INNER JOIN
                      Language.Language ON Language.ParameterCompetitor.LanguageId = Language.Language.LanguageId
WHERE     (Language.ParameterCompetitor.CompetitorId = @CompetitorId)                 

END


GO
