USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcCategoryWRange]    Script Date: 2/19/2025 7:03:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcCategoryWRange] @SportId int,
                                                     @LangId int,
                                                     @EventDate datetime
AS
BEGIN
    SET NOCOUNT ON;

    declare @TempCategory table
                          (
                              CategoryId         int,
                              CategoryName       nvarchar(100),
                              SportId            int,
                              CategoryEventCount int,
                              IsoName            nvarchar(10),
                              IsPopular          bit,
                              CategorySeqNum     int
                          )

    --SELECT     Category_1.CategoryId, Language.[Parameter.Category].CategoryName, Category_1.SportId, Category_1.CategoryEventCount, Category_1.IsoName, 
--                      Parameter.Category.Ispopular
--FROM         Parameter.Category INNER JOIN
--                      Language.[Parameter.Category] ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId and Language.[Parameter.Category].LanguageId=@LangId
--                      INNER JOIN Cache.Category AS Category_1 ON Parameter.Category.CategoryId = Category_1.CategoryId
--Where Category_1.SportId=@SportId and Category_1.EndDay=@EndDay
--Order By Parameter.Category.SequenceNumber

    insert @TempCategory
    SELECT Parameter.Tournament.CategoryId,
           case
               when Category_1.SportId = 38 then Language.[Parameter.Sport].SportName + ' ' +
                                                 Language.[Parameter.Category].CategoryName
               else Language.[Parameter.Category].CategoryName end as CategoryName,
           Category_1.SportId,
           COUNT(Category_1.MatchId)                               AS CategoryEventCount,
           SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3)          AS IsoName,
           Parameter.Category.Ispopular as IsPopular,
           Parameter.Category.SequenceNumber
    FROM Parameter.Category with (nolock)
             INNER JOIN
         Language.[Parameter.Category] with (nolock)
         ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId
             and Language.[Parameter.Category].LanguageId = @LangId
             INNER JOIN Parameter.Tournament ON [Parameter.Category].CategoryId = Parameter.Tournament.CategoryId
             INNER JOIN Cache.Fixture AS Category_1 with (nolock)
                        ON Parameter.Tournament.TournamentId = Category_1.TournamentId
             INNER JOIN
         Language.[Parameter.Sport]
         On Language.[Parameter.Sport].LanguageId = @LangId and Language.[Parameter.Sport].SportId = Category_1.SportId
             INNER JOIN
         Parameter.Iso ON Parameter.Iso.IsoId = Parameter.Category.IsoId
    Where (Category_1.SportId = @SportId and Category_1.MatchDate > GETDATE())
      and Category_1.MatchDate <= @EventDate
      and Parameter.Category.IsActive = 1
    GROUP BY Parameter.Tournament.CategoryId, Language.[Parameter.Category].CategoryName, Category_1.SportId,
             Parameter.Iso.IsoName2,
             Parameter.Category.Ispopular, Parameter.Category.SequenceNumber, Language.[Parameter.Sport].SportId,
             Language.[Parameter.Sport].SportName
    Order By Parameter.Category.SequenceNumber, Language.[Parameter.Category].CategoryName


    insert @TempCategory
    select Parameter.TournamentOutrights.CategoryId,
           Language.[Parameter.Category].CategoryName,
           Parameter.Sport.SportId,
           COUNT(DISTINCT Parameter.TournamentOutrights.TournamentId) AS CategoryEventCount,
           SUBSTRING(LOWER(Parameter.Iso.IsoName2), 0, 3)             AS IsoName,
           Parameter.Category.Ispopular  as IsPopular,
           Parameter.Category.SequenceNumber

    from Parameter.TournamentOutrights with (nolock)
             INNER JOIN
         Parameter.Category with (nolock) ON Parameter.TournamentOutrights.CategoryId = Parameter.Category.CategoryId
             INNER JOIN Parameter.Sport with (nolock) On
        Parameter.Sport.SportId = Parameter.Category.SportId --and Parameter.Sport.IsActive=1 
            and Parameter.Category.CategoryId not in (select CategoryId from @TempCategory)
             INNER JOIN Language.[Parameter.Category] with (nolock)
                        ON Language.[Parameter.Category].CategoryId = Parameter.Category.CategoryId and
                           Language.[Parameter.Category].LanguageId = @LangId
             INNER JOIN Parameter.Iso with (nolock) ON Parameter.Iso.IsoId = Parameter.Category.IsoId
    where Parameter.Sport.SportId = @SportId
      and Parameter.Category.IsActive = 1
      and Parameter.TournamentOutrights.IsActive = 1
      and Parameter.TournamentOutrights.TournamentId in (SELECT DISTINCT TournamentId
                                                         FROM Outrights.Event
                                                                  INNER JOIN Outrights.Odd ON Outrights.Odd.MatchId = Outrights.Event.EventId
                                                         where IsActive = 1
                                                           and EventEndDate > GETDATE()
                                                           and EventEndDate < @EventDate)
    GROUP BY Parameter.TournamentOutrights.CategoryId, Parameter.Sport.SportId, Parameter.Category.Ispopular
           , Parameter.Category.SequenceNumber, Language.[Parameter.Category].CategoryName
           , Parameter.Iso.IsoName2


    select * from @TempCategory order by CategoryName

END
GO
