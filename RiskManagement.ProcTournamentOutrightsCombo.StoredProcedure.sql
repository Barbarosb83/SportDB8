USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcTournamentOutrightsCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Barbaros Babalı
-- Create date: 03.03.2015
-- Description:	
-- =============================================
CREATE PROCEDURE [RiskManagement].[ProcTournamentOutrightsCombo] 
@CategoryId int,
@LangId int,
@username nvarchar(max)


AS


SELECT     Parameter.TournamentOutrights.TournamentId, ISNULL(Language.[Parameter.TournamentOutrights].TournamentName,'') as TournamentName
FROM         Language.[Parameter.TournamentOutrights] INNER JOIN
                      Parameter.TournamentOutrights ON Language.[Parameter.TournamentOutrights].TournamentId = Parameter.TournamentOutrights.TournamentId
 where Parameter.TournamentOutrights.CategoryId=@CategoryId and Language.[Parameter.TournamentOutrights].LanguageId=@LangId
 order by  Language.[Parameter.TournamentOutrights].TournamentName


GO
