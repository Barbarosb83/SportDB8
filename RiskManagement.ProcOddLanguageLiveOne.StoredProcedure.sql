USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddLanguageLiveOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcOddLanguageLiveOne]
@ParameterOddId int


AS




BEGIN
SET NOCOUNT ON;


SELECT     Language.[Parameter.LiveOdds].ParameterLiveOddId as ParameterOddId,Language.Language.LanguageId, Language.Language.Language, Language.[Parameter.LiveOdds].OutComes, Language.[Parameter.LiveOdds].OddsId
FROM        Language.[Parameter.LiveOdds] INNER JOIN
                      Language.Language ON Language.[Parameter.LiveOdds].LanguageId = Language.Language.LanguageId
                      where Language.[Parameter.LiveOdds].ParameterLiveOddId=@ParameterOddId

END


GO
