USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[Outrights.ProcCategory]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[Outrights.ProcCategory] 
@SportId int,
@LanguageId int
As

BEGIN
SET NOCOUNT ON;
 
if (@SportId=0)
begin
	SELECT distinct Language.[Parameter.Category].CategoryId,Language.[Parameter.Category].CategoryName
	FROM            Outrights.Event
	inner join Parameter.TournamentOutrights on Parameter.TournamentOutrights.TournamentId=Outrights.Event.TournamentId
	inner join Language.[Parameter.Category] on Language.[Parameter.Category].CategoryId=Parameter.TournamentOutrights.CategoryId and Language.[Parameter.Category].LanguageId=@LanguageId
	inner join Parameter.Category on Parameter.Category.CategoryId=Parameter.TournamentOutrights.CategoryId
	where  
	Outrights.[Event].EventEndDate>GETDATE() and 
	Outrights.[Event].IsActive=1 and  Parameter.Category.SportId=@SportId
	order by Language.[Parameter.Category].CategoryName
end
else
begin
	SELECT distinct Language.[Parameter.Category].CategoryId,Language.[Parameter.Category].CategoryName
	FROM            Outrights.Event
	inner join Parameter.TournamentOutrights on Parameter.TournamentOutrights.TournamentId=Outrights.Event.TournamentId
	inner join Language.[Parameter.Category] on Language.[Parameter.Category].CategoryId=Parameter.TournamentOutrights.CategoryId and Language.[Parameter.Category].LanguageId=@LanguageId
	inner join Parameter.Category on Parameter.Category.CategoryId=Parameter.TournamentOutrights.CategoryId
	where  Parameter.Category.SportId=@SportId and Outrights.[Event].EventEndDate>GETDATE() and Outrights.[Event].IsActive=1
	order by Language.[Parameter.Category].CategoryName
END

end


GO
