USE [Tip_SportDB]
GO
/****** Object:  StoredProcedure [GamePlatform].[ProcTournamentWRange]    Script Date: 2/19/2025 7:03:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [GamePlatform].[ProcTournamentWRange] @SportId int,
                                                       @CategoryId int,
                                                       @EventDate datetime,
                                                       @LangId int
AS

BEGIN
    SET NOCOUNT ON;

    if (@CategoryId = 0)
        begin
            SELECT Tournament_1.TournamentId      as TournamentId,
                   case
                       when CHARINDEX(',', Language.[Parameter.Tournament].TournamentName) > 0 then REPLACE(
                               SUBSTRING(Language.[Parameter.Tournament].TournamentName, 1,
                                         CHARINDEX(',', Language.[Parameter.Tournament].TournamentName)), ',', '')
                       else Language.[Parameter.Tournament].TournamentName end as TournamentName,
                   Parameter.Tournament.CategoryId,
                   Language.[Parameter.Category].CategoryName,
                   COUNT(Parameter.Tournament.TerminalTournamentId)            as TournamentSportEventCount,
                   ISNULL(Parameter.Category.Ispopular, 0)                     as IsPopular
                    ,
                   ISNULL(Parameter.Category.SequenceNumber, 999)              as SequenceNumber,
                   cast(1 as bit)                                              as IsPopularTerminal,
                   SUBSTRING(LOWER(Parameter.Iso.IsoName), 0, 3)               AS IsoName,
                   Parameter.Tournament.NewBetradarId                          as BetradarId
                    ,
                   cast(0 as int)                                              as BetType
            FROM Parameter.Tournament with (nolock)
                     INNER JOIN
                 Language.[Parameter.Tournament] with (nolock)
                 ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId
                     and Language.[Parameter.Tournament].LanguageId = @LangId
                     INNER JOIN
                 Cache.Fixture AS Tournament_1 with (nolock)
                 ON Parameter.Tournament.TournamentId = Tournament_1.TournamentId
                     inner join
                 Parameter.Category with (nolock) on Parameter.Category.CategoryId = Parameter.Tournament.CategoryId
                     INNER JOIN
                 Language.[Parameter.Category] with (nolock)
                 ON Parameter.Category.CategoryId = Language.[Parameter.Category].CategoryId
                     and Language.[Parameter.Category].LanguageId = @LangId
                     INNER JOIN
                 Parameter.Iso On Parameter.Iso.IsoId = Parameter.Category.IsoId
            where Tournament_1.SportId = @SportId
              and Tournament_1.MatchDate > GETDATE()
              and Tournament_1.MatchDate < @EventDate
            GROUP BY Tournament_1.TournamentId,
                     case
                         when CHARINDEX(',', Language.[Parameter.Tournament].TournamentName) > 0 then REPLACE(
                                 SUBSTRING(Language.[Parameter.Tournament].TournamentName, 1,
                                           CHARINDEX(',', Language.[Parameter.Tournament].TournamentName)), ',', '')
                         else Language.[Parameter.Tournament].TournamentName end, Parameter.Tournament.CategoryId,
                     Language.[Parameter.Category].CategoryName, Parameter.Tournament.SequenceNumber,
                     Parameter.Category.Ispopular, Parameter.Category.SequenceNumber,
                     Parameter.Tournament.[IsPopularTerminal], Parameter.Iso.IsoName, Parameter.Tournament.NewBetradarId
--order by   Parameter.Category.SequenceNumber asc,ISNULL((Parameter.Tournament.IsPopularTerminal),0) desc ,Language.[Parameter.Category].CategoryName,case when CHARINDEX(',', Language.[Parameter.Tournament].TournamentName)>0 then REPLACE( SUBSTRING(Language.[Parameter.Tournament].TournamentName , 1, CHARINDEX(',', Language.[Parameter.Tournament].TournamentName) ),',','') else Language.[Parameter.Tournament].TournamentName end
            UNION ALL
            SELECT DISTINCT Tournament_1.TournamentId
                          , Parameter.TournamentOutrights.TournamentName
                          , Parameter.TournamentOutrights.CategoryId
                          , PC.CategoryName
                          , COUNT(Tournament_1.EventId)                   as TournamentSportEventCount
                          , Cast(0 as bit)                                as IsPopular
                          , Parameter.TournamentOutrights.SequenceNumber
                          , cast(1 as bit)                                as IsPopularTerminal
                          , SUBSTRING(LOWER(Parameter.Iso.IsoName), 0, 3) AS IsoName
                          , Tournament_1.TournamentId                     as BetradarId
                          , cast(2 as int)                                as BetType
            FROM Parameter.TournamentOutrights with (nolock)
                     INNER JOIN
                 Outrights.Event AS Tournament_1 with (nolock)
                 ON Parameter.TournamentOutrights.TournamentId = Tournament_1.TournamentId
                     INNER JOIN
                 Outrights.Odd ON Outrights.Odd.MatchId = Tournament_1.EventId
                     INNER JOIN Parameter.Category PC with (nolock) ON
                PC.CategoryId = Parameter.TournamentOutrights.CategoryId
                     INNER JOIN
                 Parameter.Iso On Parameter.Iso.IsoId = PC.IsoId
            where Tournament_1.EventEndDate > GETDATE() -- and  Tournament_1.eve>GETDATE()
              and PC.SportId = @SportId
              and Tournament_1.IsActive = 1
--and Tournament_1.TournamentId  in (1125,13827,13891,13889,13858,13852,13845,13839)
            GROUP BY Tournament_1.TournamentId, Parameter.TournamentOutrights.TournamentName
                   , Parameter.TournamentOutrights.CategoryId
                   , Parameter.TournamentOutrights.SequenceNumber, Parameter.TournamentOutrights.CategoryId
                   , PC.CategoryName, Parameter.Iso.IsoName

--order by Parameter.Tournament.SequenceNumber, Language.[Parameter.Tournament].TournamentName
        end
    if (@CategoryId > 0)
        begin

            SELECT Tournament_1.TournamentId
                 , Language.[Parameter.Tournament].TournamentName
                 , Parameter.Tournament.CategoryId
                 , COUNT(Tournament_1.MatchId)                         as TournamentSportEventCount
                 , ISNULL(Parameter.Tournament.SequenceNumber, 999)    as SequenceNumber
                 , ISNULL(Parameter.Category.Ispopular, 0)             as IsPopular
                 , ISNULL(Parameter.Tournament.[IsPopularTerminal], 0) as IsPopularTerminal
                 , SUBSTRING(LOWER(Parameter.Iso.IsoName), 0, 3)       AS IsoName
                 , Parameter.Tournament.NewBetradarId                  as BetradarId
                 , cast(0 as int)                                      as BetType
            FROM Parameter.Tournament with (nolock)
                     INNER JOIN
                 Language.[Parameter.Tournament] with (nolock)
                 ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId
                     and Language.[Parameter.Tournament].LanguageId = @LangId
                     INNER JOIN
                 Parameter.Category with (nolock) on Parameter.Category.CategoryId = Parameter.Tournament.CategoryId
                     INNER JOIN
                 Cache.Fixture AS Tournament_1 with (nolock)
                 ON Parameter.Tournament.TournamentId = Tournament_1.TournamentId
                     INNER JOIN
                 Parameter.Iso On Parameter.Iso.IsoId = Parameter.Category.IsoId
            where Tournament_1.MatchDate <= @EventDate
              and Tournament_1.MatchDate > GETDATE()
              and Parameter.Tournament.CategoryId = @CategoryId
            GROUP BY Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName
                   , Parameter.Tournament.CategoryId
                   , Parameter.Tournament.SequenceNumber
                   , Parameter.Tournament.[IsPopularTerminal], Parameter.Category.Ispopular, Parameter.Iso.IsoName
                   , Parameter.Tournament.NewBetradarId
            UNION ALL
            SELECT DISTINCT Tournament_1.TournamentId
                          , Parameter.TournamentOutrights.TournamentName
                          , Parameter.TournamentOutrights.CategoryId
                          , COUNT(Tournament_1.EventId)                   as TournamentSportEventCount
                          , Parameter.TournamentOutrights.SequenceNumber
                          , Cast(0 as bit)                                as IsPopular
                          , cast(1 as bit)                                as IsPopularTerminal
                          , SUBSTRING(LOWER(Parameter.Iso.IsoName), 0, 3) AS IsoName
                          , Tournament_1.TournamentId                     as BetradarId
                          , cast(2 as int)                                as BetType
            FROM Parameter.TournamentOutrights with (nolock)
                     INNER JOIN
                 Outrights.Event AS Tournament_1 with (nolock)
                 ON Parameter.TournamentOutrights.TournamentId = Tournament_1.TournamentId
                     INNER JOIN
                 Outrights.Odd ON Outrights.Odd.MatchId = Tournament_1.EventId
                     INNER JOIN Parameter.Category PC with (nolock) ON
                PC.CategoryId = Parameter.TournamentOutrights.CategoryId
                     INNER JOIN
                 Parameter.Iso On Parameter.Iso.IsoId = PC.IsoId

            where Tournament_1.EventEndDate > GETDATE() -- and  Tournament_1.eve>GETDATE()
              and Parameter.TournamentOutrights.CategoryId = @CategoryId
              and Tournament_1.IsActive = 1
--and Tournament_1.TournamentId  in (1125,13827,13891,13889,13858,13852,13845,13839)
            GROUP BY Tournament_1.TournamentId, Parameter.TournamentOutrights.TournamentName
                   , Parameter.TournamentOutrights.CategoryId
                   , Parameter.TournamentOutrights.SequenceNumber, PC.CategoryName, Parameter.Iso.IsoName

        end
    if (@CategoryId = -10) --Tüm Populer Tournuvalar
        begin
            SELECT Tournament_1.TournamentId
                 , Language.[Parameter.Tournament].TournamentName
                 , Parameter.Tournament.CategoryId
                 , COUNT(Tournament_1.MatchId)                         as TournamentSportEventCount
                 , ISNULL(Parameter.Tournament.SequenceNumber, 999)    as SequenceNumber
                 , ISNULL(Parameter.Category.Ispopular, 0)             as IsPopular
                 , ISNULL(Parameter.Tournament.[IsPopularTerminal], 0) as IsPopularTerminal
                 , SUBSTRING(LOWER(Parameter.Iso.IsoName), 0, 3)       AS IsoName
                 , Parameter.Tournament.NewBetradarId                  as BetradarId
                 , cast(0 as int)                                      as BetType
            FROM Parameter.Tournament with (nolock)
                     INNER JOIN
                 Language.[Parameter.Tournament] with (nolock)
                 ON Parameter.Tournament.TournamentId = Language.[Parameter.Tournament].TournamentId
                     and Language.[Parameter.Tournament].LanguageId = @LangId
                     INNER JOIN
                 Parameter.Category with (nolock) on Parameter.Category.CategoryId = Parameter.Tournament.CategoryId
                     INNER JOIN
                 Cache.Fixture AS Tournament_1 with (nolock)
                 ON Parameter.Tournament.TournamentId = Tournament_1.TournamentId
                     INNER JOIN
                 Parameter.Iso On Parameter.Iso.IsoId = Parameter.Category.IsoId


            where Tournament_1.MatchDate <= @EventDate
              and Tournament_1.MatchDate > GETDATE()
              and Parameter.Tournament.IsPopularTerminal = 1
            GROUP BY Tournament_1.TournamentId, Language.[Parameter.Tournament].TournamentName
                   , Parameter.Tournament.CategoryId, Parameter.Tournament.SequenceNumber
                   , Parameter.Tournament.[IsPopularTerminal], Parameter.Category.Ispopular, Parameter.Iso.IsoName
                   , Parameter.Tournament.NewBetradarId

        end


END
GO
