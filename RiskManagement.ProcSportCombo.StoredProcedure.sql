USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcSportCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:	
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcSportCombo] 
@LangId int,
@username nvarchar(max)


AS


SELECT     Parameter.Sport.SportId, Language.[Parameter.Sport].SportName
FROM         Language.[Parameter.Sport] INNER JOIN
                      Parameter.Sport ON Language.[Parameter.Sport].SportId = Parameter.Sport.SportId
where Language.[Parameter.Sport].LanguageId=@LangId
order by Language.[Parameter.Sport].SportName


GO
