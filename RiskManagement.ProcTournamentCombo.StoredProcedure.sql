USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTournamentCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:	
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcTournamentCombo] 
@CategoryId int,
@LangId int,
@username nvarchar(max)


AS


SELECT  DISTINCT   Parameter.Tournament.TournamentId, ISNULL(Language.[Parameter.Tournament].TournamentName,'') as TournamentName
FROM         Language.[Parameter.Tournament] INNER JOIN
                      Parameter.Tournament ON Language.[Parameter.Tournament].TournamentId = Parameter.Tournament.TournamentId
 where Parameter.Tournament.CategoryId=@CategoryId and Language.[Parameter.Tournament].LanguageId=@LangId
 order by ISNULL(Language.[Parameter.Tournament].TournamentName,'')


GO
