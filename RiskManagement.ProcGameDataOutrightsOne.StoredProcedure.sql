USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [RiskManagement].[ProcGameDataOutrightsOne]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [RiskManagement].[ProcGameDataOutrightsOne] 
@MatchId int,
@LangId int,
@username nvarchar(50)
AS

BEGIN
SET NOCOUNT ON;

select Outrights.Event.EventId, ISNULL(Outrights.Event.SequenceNumber,999) as  TournamentId, Outrights.Event.EventDate, Outrights.Event.EventStartDate, Outrights.Event.EventEndDate, 
                      Outrights.EventName.EventName, Parameter.TournamentOutrights.CategoryId, Language.[Parameter.Category].CategoryName, Parameter.Sport.SportId, 
                      Language.[Parameter.Sport].SportName, Outrights.Event.IsActive,dbo.FuncCashFlow(0,Outrights.Event.EventId,4,2) as CashFlow,Parameter.Sport.IconColor,
                      CAse when Outrights.Event.IsActive=0 then 3 else 1 end as StatuColor,Parameter.Sport.Icon
FROM         Language.Language INNER JOIN
                      Outrights.EventName ON Language.Language.LanguageId = Outrights.EventName.LanguageId INNER JOIN
                      Outrights.Event ON Outrights.EventName.EventId = Outrights.Event.EventId INNER JOIN
                      Parameter.TournamentOutrights ON Outrights.Event.TournamentId = Parameter.TournamentOutrights.TournamentId INNER JOIN
                      Parameter.Category ON Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId INNER JOIN
                      Language.[Parameter.Category] ON Language.Language.LanguageId = Language.[Parameter.Category].LanguageId AND 
                      Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId  INNER JOIN
                      Language.[Parameter.Sport] ON Language.Language.LanguageId = Language.[Parameter.Sport].LanguageId INNER JOIN
                      Parameter.Sport ON Parameter.Category.SportId = Parameter.Sport.SportId  AND 
                      Language.[Parameter.Sport].SportId = Parameter.Sport.SportId 
WHERE   Outrights.Event.EventId=@MatchId
END


GO
