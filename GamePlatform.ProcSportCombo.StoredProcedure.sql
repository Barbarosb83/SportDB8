USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcSportCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcSportCombo] 
@LangId int

AS


SELECT     Parameter.Sport.SportId, Language.[Parameter.Sport].SportName
FROM         Language.[Parameter.Sport] INNER JOIN
                      Parameter.Sport ON Language.[Parameter.Sport].SportId = Parameter.Sport.SportId
where Language.[Parameter.Sport].LanguageId=@LangId and LEN( Language.[Parameter.Sport].SportName)>0
order by Parameter.Sport.SportId, Language.[Parameter.Sport].SportName


GO
