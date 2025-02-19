USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddTypeLanguageOneLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcOddTypeLanguageOneLive]
@ParameterOddTypeId int


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.Language.LanguageId, Language.Language.Language,  [Language].[Parameter.LiveOddType].OddsType,  [Language].[Parameter.LiveOddType].OddTypeId as OddsTypeId
FROM         [Language].[Parameter.LiveOddType] INNER JOIN
                      Language.Language ON  [Language].[Parameter.LiveOddType] .LanguageId = Language.Language.LanguageId
                      where  [Language].[Parameter.LiveOddType].ParametersLiveOddTypeId=@ParameterOddTypeId

END



GO
