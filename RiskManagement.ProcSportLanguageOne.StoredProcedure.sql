USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSportLanguageOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcSportLanguageOne]
@ParameterSportIdId int


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.[Parameter.Sport].ParameterSportId, Language.[Parameter.Sport].SportId, Language.[Parameter.Sport].LanguageId, Language.Language.Language, 
                      Language.[Parameter.Sport].SportName
FROM         Language.[Parameter.Sport] INNER JOIN
                      Language.Language ON Language.[Parameter.Sport].LanguageId = Language.Language.LanguageId
Where         Language.[Parameter.Sport].ParameterSportId   =@ParameterSportIdId            

END


GO
