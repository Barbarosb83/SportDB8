USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcComboOddsFormat]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcComboOddsFormat] 
@LanguageId int
AS

BEGIN
SET NOCOUNT ON;


SELECT     Parameter.OddsFormat.OddsFormatId, Parameter.OddsFormat.OddsFormatName, Language.[Parameter.OddsFormat].OddsFormat
FROM         Parameter.OddsFormat INNER JOIN
                      Language.[Parameter.OddsFormat] ON Parameter.OddsFormat.OddsFormatId = Language.[Parameter.OddsFormat].OddsFormatId
Where Language.[Parameter.OddsFormat].LanguageId=@LanguageId


END


GO
