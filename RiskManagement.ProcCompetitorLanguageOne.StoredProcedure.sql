USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcCompetitorLanguageOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcCompetitorLanguageOne]
@ParameterCompetitorId bigint


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.ParameterCompetitor.ParameterCompetitorId, Language.ParameterCompetitor.CompetitorId, Language.ParameterCompetitor.LanguageId, 
                      Language.ParameterCompetitor.CompetitorName
FROM         Parameter.Competitor INNER JOIN
                      Language.ParameterCompetitor ON Parameter.Competitor.CompetitorId = Language.ParameterCompetitor.CompetitorId
where   Language.ParameterCompetitor.ParameterCompetitorId=@ParameterCompetitorId    

END


GO
