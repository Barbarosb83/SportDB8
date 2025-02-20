USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [Stadium].[ProcCategory]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

CREATE PROCEDURE [Stadium].[ProcCategory] 
@SportId int,
@LangId int,
@StadiumId bigint
AS

BEGIN
SET NOCOUNT ON;



--SELECT     Category_1.CategoryId, Language.[Parameter.Category].CategoryName, Category_1.SportId, Category_1.CategoryEventCount, Category_1.IsoName, 
--                      Parameter.Category.Ispopular
--FROM         Parameter.Category INNER JOIN
--                      Language.[Parameter.Category] ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId and Language.[Parameter.Category].LanguageId=@LangId
--                      INNER JOIN Cache.Category AS Category_1 ON Parameter.Category.CategoryId = Category_1.CategoryId
--Where Category_1.SportId=@SportId and Category_1.EndDay=@EndDay
--Order By Parameter.Category.SequenceNumber
if exists (Select Stadium.Category.CategoryId from Stadium.Category where StadiumId=@StadiumId and CategoryId=-1)
		begin
		SELECT     Parameter.Tournament.CategoryId, Language.[Parameter.Category].CategoryName, Category_1.SportId, COUNT(Category_1.MatchId) AS  CategoryEventCount,  SUBSTRING(LOWER(Parameter.Iso.IsoName), 0, 3) AS IsoName, 
							  Parameter.Category.Ispopular
		FROM         Parameter.Category with (nolock) INNER JOIN
							  Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId 
							  and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN Parameter.Tournament ON [Parameter.Category].CategoryId=Parameter.Tournament.CategoryId
							  INNER JOIN Cache.Fixture AS Category_1 with (nolock) ON Parameter.Tournament.TournamentId = Category_1.TournamentId INNER JOIN Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId
		Where Category_1.SportId=@SportId and Category_1.MatchDate<(Select Stadium.Stadium.EndDate from Stadium.Stadium where StadiumId=@StadiumId) and Category_1.MatchDate>GETDATE()
			and (SELECT     COUNT(DISTINCT OddTypeId)
                                        FROM          Match.OddTypeSetting with (nolock)
                                                      WHERE      (MatchId = Category_1.MatchId) AND (StateId = 2))>0
		GROUP BY Parameter.Tournament.CategoryId, Language.[Parameter.Category].CategoryName, Category_1.SportId, Parameter.Iso.IsoName, 
							  Parameter.Category.Ispopular,Parameter.Category.SequenceNumber
		Order By Parameter.Category.SequenceNumber, Language.[Parameter.Category].CategoryName
		end
else  
		begin
		SELECT     Parameter.Tournament.CategoryId, Language.[Parameter.Category].CategoryName, Category_1.SportId, COUNT(Category_1.MatchId) AS  CategoryEventCount,  SUBSTRING(LOWER(Parameter.Iso.IsoName), 0, 3) AS IsoName, 
							  Parameter.Category.Ispopular
		FROM         Parameter.Category with (nolock) INNER JOIN
							  Language.[Parameter.Category] with (nolock) ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId 
							  and Language.[Parameter.Category].LanguageId=@LangId INNER JOIN Parameter.Tournament ON [Parameter.Category].CategoryId=Parameter.Tournament.CategoryId
							  INNER JOIN Cache.Fixture AS Category_1 with (nolock) ON Parameter.Tournament.TournamentId = Category_1.TournamentId INNER JOIN Parameter.Iso ON Parameter.Iso.IsoId=Parameter.Category.IsoId
		Where Category_1.SportId=@SportId and Category_1.MatchDate<(Select Stadium.Stadium.EndDate from Stadium.Stadium where StadiumId=@StadiumId) and Category_1.MatchDate>GETDATE()
		and  Parameter.Category.CategoryId in (Select Stadium.Category.CategoryId from Stadium.Category where StadiumId=@StadiumId)
		and (SELECT     COUNT(DISTINCT OddTypeId)
                                        FROM          Match.OddTypeSetting with (nolock)
                                                      WHERE      (MatchId = Category_1.MatchId) AND (StateId = 2))>0
		GROUP BY Parameter.Tournament.CategoryId, Language.[Parameter.Category].CategoryName, Category_1.SportId, Parameter.Iso.IsoName, 
							  Parameter.Category.Ispopular,Parameter.Category.SequenceNumber
		Order By Parameter.Category.SequenceNumber, Language.[Parameter.Category].CategoryName
		end
END


GO
