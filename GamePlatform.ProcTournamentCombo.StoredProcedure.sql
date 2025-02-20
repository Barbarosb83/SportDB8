USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentCombo]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcTournamentCombo] 
@CategoryId int,
@LangId int


AS


SELECT     Parameter.Tournament.TournamentId, ISNULL(Language.[Parameter.Tournament].TournamentName,'') as TournamentName
FROM         Language.[Parameter.Tournament]  with (nolock) INNER JOIN
                      Parameter.Tournament  with (nolock)  ON Language.[Parameter.Tournament].TournamentId = Parameter.Tournament.TournamentId
 where Parameter.Tournament.CategoryId=@CategoryId and Language.[Parameter.Tournament].LanguageId=@LangId
 order by  Language.[Parameter.Tournament].TournamentName


GO
