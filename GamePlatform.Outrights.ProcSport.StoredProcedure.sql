USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[Outrights.ProcSport]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[Outrights.ProcSport] 
@LangId int
AS
BEGIN
SET NOCOUNT ON;

SELECT     Parameter.Sport.SportId, Language.[Parameter.Sport].SportName, 
				COUNT(Outrights.[Event].EventId) as SportEventCount, 
					Parameter.Sport.SportName AS OrginalName
FROM  Outrights.[Event] inner join Parameter.TournamentOutrights on Outrights.[Event].TournamentId=Parameter.TournamentOutrights.TournamentId
		inner join Parameter.[Category] on Parameter.[Category].CategoryId=Parameter.TournamentOutrights.CategoryId 
		inner join Parameter.Sport on Parameter.[Category].SportId=Parameter.Sport.SportId INNER JOIN
            Language.[Parameter.Sport] ON
             Parameter.Sport.SportId = Language.[Parameter.Sport].SportId 
             and Language.[Parameter.Sport].LanguageId=@LangId 
Where Outrights.[Event].EventEndDate>GETDATE()
GROUP BY  Parameter.Sport.SportId, Language.[Parameter.Sport].SportName,Parameter.Sport.SportName,Parameter.Sport.SquanceNumber
ORDER BY Parameter.Sport.SquanceNumber

END


GO
