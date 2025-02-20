USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcOddTypeLanguageLive]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [RiskManagement].[ProcOddTypeLanguageLive]
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


SELECT     [Language].[Parameter.LiveOddType].ParametersLiveOddTypeId as ParameterOddsTypeId,Language.Language.LanguageId, Language.Language.Language,[Language].[Parameter.LiveOddType].OddsType, [Language].[Parameter.LiveOddType].OddTypeId as OddsTypeId
FROM         [Language].[Parameter.LiveOddType] INNER JOIN
                      Language.Language ON [Language].[Parameter.LiveOddType].LanguageId = Language.Language.LanguageId
                      where [Language].[Parameter.LiveOddType].OddTypeId=@OddTypeId

END



GO
